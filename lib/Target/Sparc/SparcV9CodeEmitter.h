

#ifndef SPARCV9CODEEMITTER_H
#define SPARCV9CODEEMITTER_H

#include "llvm/BasicBlock.h"
#include "llvm/CodeGen/MachineCodeEmitter.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstr.h"

class SparcV9CodeEmitter : public MachineFunctionPass {
  MachineCodeEmitter &MCE;
  BasicBlock *currBB;

public:
  SparcV9CodeEmitter(MachineCodeEmitter &M) : MCE(M) {}
    
  bool runOnMachineFunction(MachineFunction &F);
    
  /// Function generated by the CodeEmitterGenerator using TableGen
  ///
  static unsigned getBinaryCodeForInstr(MachineInstr &MI);

private:    
  static int64_t getMachineOpValue(MachineOperand &MO);
  static unsigned getValueBit(int64_t Val, unsigned bit);

  void emitConstant(unsigned Val, unsigned Size);

  void emitBasicBlock(MachineBasicBlock &MBB);
  void emitInstruction(MachineInstr &MI);
    
};

#endif
