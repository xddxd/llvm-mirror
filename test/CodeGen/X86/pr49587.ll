; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O0 -fast-isel -mtriple=x86_64-- < %s | FileCheck %s

define i32 @test(i64 %arg) nounwind {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    subq $1, %rdi
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; CHECK-NEXT:    jb .LBB0_2
; CHECK-NEXT:  # %bb.1: # %no_overflow
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    movl %eax, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; CHECK-NEXT:    jmp .LBB0_2
; CHECK-NEXT:  .LBB0_2: # %merge
; CHECK-NEXT:    movl {{[-0-9]+}}(%r{{[sb]}}p), %eax # 4-byte Reload
; CHECK-NEXT:    retq
entry:
  %usubo = tail call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %arg, i64 1)
  %overflow = extractvalue { i64, i1 } %usubo, 1
  br i1 %overflow, label %merge, label %no_overflow

no_overflow:
  br label %merge

merge:
  %phi = phi i32 [ 1, %no_overflow ], [ 0, %entry ]
  ret i32 %phi
}

declare { i64, i1 } @llvm.usub.with.overflow.i64(i64, i64)
