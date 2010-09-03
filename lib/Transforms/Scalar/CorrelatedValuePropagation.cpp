//===- CorrelatedValuePropagation.cpp - Propagate CFG-derived info --------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the Correlated Value Propagation pass.
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "correlated-value-propagation"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Function.h"
#include "llvm/Instructions.h"
#include "llvm/Pass.h"
#include "llvm/Analysis/LazyValueInfo.h"
#include "llvm/Transforms/Utils/Local.h"
#include "llvm/ADT/Statistic.h"
using namespace llvm;

STATISTIC(NumPhis,      "Number of phis propagated");
STATISTIC(NumSelects,   "Number of selects propagated");
STATISTIC(NumMemAccess, "Number of memory access targets propagated");

namespace {
  class CorrelatedValuePropagation : public FunctionPass {
    LazyValueInfo *LVI;
    
    bool processSelect(SelectInst *SI);
    bool processPHI(PHINode *P);
    bool processMemAccess(Instruction *I);
    
  public:
    static char ID;
    CorrelatedValuePropagation(): FunctionPass(ID) { }
    
    bool runOnFunction(Function &F);
    
    virtual void getAnalysisUsage(AnalysisUsage &AU) const {
      AU.addRequired<LazyValueInfo>();
    }
  };
}

char CorrelatedValuePropagation::ID = 0;
INITIALIZE_PASS(CorrelatedValuePropagation, "correlated-propagation",
                "Value Propagation", false, false);

// Public interface to the Value Propagation pass
Pass *llvm::createCorrelatedValuePropagationPass() {
  return new CorrelatedValuePropagation();
}

bool CorrelatedValuePropagation::processSelect(SelectInst *S) {
  if (S->getType()->isVectorTy()) return false;
  if (isa<Constant>(S->getOperand(0))) return false;
  
  Constant *C = LVI->getConstant(S->getOperand(0), S->getParent());
  if (!C) return false;
  
  ConstantInt *CI = dyn_cast<ConstantInt>(C);
  if (!CI) return false;
  
  S->replaceAllUsesWith(S->getOperand(CI->isOne() ? 1 : 2));
  S->eraseFromParent();

  ++NumSelects;
  
  return true;
}

bool CorrelatedValuePropagation::processPHI(PHINode *P) {
  bool Changed = false;
  
  BasicBlock *BB = P->getParent();
  for (unsigned i = 0, e = P->getNumIncomingValues(); i < e; ++i) {
    Value *Incoming = P->getIncomingValue(i);
    if (isa<Constant>(Incoming)) continue;
    
    Constant *C = LVI->getConstantOnEdge(P->getIncomingValue(i),
                                         P->getIncomingBlock(i),
                                         BB);
    if (!C) continue;
    
    P->setIncomingValue(i, C);
    Changed = true;
  }
  
  if (Value *ConstVal = P->hasConstantValue()) {
    P->replaceAllUsesWith(ConstVal);
    P->eraseFromParent();
    Changed = true;
  }
  
  ++NumPhis;
  
  return Changed;
}

bool CorrelatedValuePropagation::processMemAccess(Instruction *I) {
  Value *Pointer = 0;
  if (LoadInst *L = dyn_cast<LoadInst>(I))
    Pointer = L->getPointerOperand();
  else
    Pointer = cast<StoreInst>(I)->getPointerOperand();
  
  if (isa<Constant>(Pointer)) return false;
  
  Constant *C = LVI->getConstant(Pointer, I->getParent());
  if (!C) return false;
  
  ++NumMemAccess;
  I->replaceUsesOfWith(Pointer, C);
  return true;
}

bool CorrelatedValuePropagation::runOnFunction(Function &F) {
  LVI = &getAnalysis<LazyValueInfo>();
  
  bool FnChanged = false;
  
  for (Function::iterator FI = F.begin(), FE = F.end(); FI != FE; ++FI) {
    bool BBChanged = false;
    for (BasicBlock::iterator BI = FI->begin(), BE = FI->end(); BI != BE; ) {
      Instruction *II = BI++;
      switch (II->getOpcode()) {
      case Instruction::Select:
        BBChanged |= processSelect(cast<SelectInst>(II));
        break;
      case Instruction::PHI:
        BBChanged |= processPHI(cast<PHINode>(II));
        break;
      case Instruction::Load:
      case Instruction::Store:
        BBChanged |= processMemAccess(II);
        break;
      }
    }
    
    // Propagating correlated values might leave cruft around.
    // Try to clean it up before we continue.
    if (BBChanged)
      SimplifyInstructionsInBlock(FI);
    
    FnChanged |= BBChanged;
  }
  
  return FnChanged;
}
