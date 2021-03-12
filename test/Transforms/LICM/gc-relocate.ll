; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -basic-aa -licm < %s | FileCheck %s

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:1-p2:32:8:8:32-ni:2"
target triple = "x86_64-unknown-linux-gnu"

define i8 addrspace(1)* @test(i8 addrspace(1)* %arg) #0 gc "statepoint-example" personality i32* ()* @wobble {
; CHECK-LABEL: @test(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP:%.*]] = call token (i64, i32, i32 (i32, i8 addrspace(1)*, i32, i32, i32)*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_i32i32p1i8i32i32i32f(i64 1, i32 16, i32 (i32, i8 addrspace(1)*, i32, i32, i32)* nonnull @zot, i32 5, i32 0, i32 undef, i8 addrspace(1)* undef, i32 undef, i32 undef, i32 undef, i32 0, i32 0) [ "deopt"(i32 0, i32 0, i32 0, i32 235, i32 3, i32 32, i32 0, i32 0, i8 addrspace(1)* undef, i32 3, i32 undef, i32 3, float undef, i32 0, i8 addrspace(1)* undef, i32 7, i8* null, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 0, i8 addrspace(1)* undef, i32 4, double undef, i32 7, i8* null, i32 0, i8 addrspace(1)* undef, i32 3, float undef, i32 0, i8 addrspace(1)* undef, i32 0, i8 addrspace(1)* undef, i32 0, i8 addrspace(1)* undef, i32 0, i8 addrspace(1)* undef, i32 0, i8 addrspace(1)* undef, i32 0, i8 addrspace(1)* null, i32 3, i32 -15108, i32 7, i8* null, i32 7, i8* null, i32 7, i8* null, i32 7, i8* null, i32 7, i8* null), "gc-live"(i8 addrspace(1)* [[ARG:%.*]]) ]
; CHECK-NEXT:    [[RES:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[TMP]], i32 0, i32 0)
; CHECK-NEXT:    br i1 false, label [[BB1]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[RES_LCSSA:%.*]] = phi i8 addrspace(1)* [ [[RES]], [[BB1]] ]
; CHECK-NEXT:    ret i8 addrspace(1)* [[RES_LCSSA]]
;
bb:
  br label %bb1

bb1:
  %tmp = call token (i64, i32, i32 (i32, i8 addrspace(1)*, i32, i32, i32)*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_i32i32p1i8i32i32i32f(i64 1, i32 16, i32 (i32, i8 addrspace(1)*, i32, i32, i32)* nonnull @zot, i32 5, i32 0, i32 undef, i8 addrspace(1)* undef, i32 undef, i32 undef, i32 undef, i32 0, i32 0) [ "deopt"(i32 0, i32 0, i32 0, i32 235, i32 3, i32 32, i32 0, i32 0, i8 addrspace(1)* undef, i32 3, i32 undef, i32 3, float undef, i32 0, i8 addrspace(1)* undef, i32 7, i8* null, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 3, i32 undef, i32 0, i8 addrspace(1)* undef, i32 4, double undef, i32 7, i8* null, i32 0, i8 addrspace(1)* undef, i32 3, float undef, i32 0, i8 addrspace(1)* undef, i32 0, i8 addrspace(1)* undef, i32 0, i8 addrspace(1)* undef, i32 0, i8 addrspace(1)* undef, i32 0, i8 addrspace(1)* undef, i32 0, i8 addrspace(1)* null, i32 3, i32 -15108, i32 7, i8* null, i32 7, i8* null, i32 7, i8* null, i32 7, i8* null, i32 7, i8* null), "gc-live"(i8 addrspace(1)* %arg) ]
  %res = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token %tmp, i32 0, i32 0)
  br i1 undef, label %bb1, label %bb2

bb2:
  ret i8 addrspace(1)* %res
}

declare i32* @wobble()
declare i32 @zot(i32, i8 addrspace(1)*, i32, i32, i32)
declare token @llvm.experimental.gc.statepoint.p0f_isVoidi32f(i64, i32, void (i32)*, i32, i32, ...)

; Function Attrs: nounwind readnone
declare i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token, i32, i32) #0
declare token @llvm.experimental.gc.statepoint.p0f_i32i32p1i8i32i32i32f(i64, i32, i32 (i32, i8 addrspace(1)*, i32, i32, i32)*, i32, i32, ...)

attributes #0 = { nounwind readnone }
