; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -debugify-and-strip-all-safe < %s -O3 -mtriple=aarch64-eabi -verify-machineinstrs | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-linaro-linux-gnueabi"

; CMN is an alias of ADDS.

define void @test_add_cbz(i32 %a, i32 %b, i32* %ptr) {
; CHECK-LABEL: test_add_cbz:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmn w0, w1
; CHECK-NEXT:    b.eq .LBB0_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    str wzr, [x2]
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB0_2: // %L2
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    str w8, [x2]
; CHECK-NEXT:    ret
  %c = add nsw i32 %a, %b
  %d = icmp ne i32 %c, 0
  br i1 %d, label %L1, label %L2
L1:
  store i32 0, i32* %ptr, align 4
  ret void
L2:
  store i32 1, i32* %ptr, align 4
  ret void
}

define void @test_add_cbz_multiple_use(i32 %a, i32 %b, i32* %ptr) {
; CHECK-LABEL: test_add_cbz_multiple_use:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds w8, w0, w1
; CHECK-NEXT:    b.eq .LBB1_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    str wzr, [x2]
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB1_2: // %L2
; CHECK-NEXT:    str w8, [x2]
; CHECK-NEXT:    ret
  %c = add nsw i32 %a, %b
  %d = icmp ne i32 %c, 0
  br i1 %d, label %L1, label %L2
L1:
  store i32 0, i32* %ptr, align 4
  ret void
L2:
  store i32 %c, i32* %ptr, align 4
  ret void
}

define void @test_add_cbz_64(i64 %a, i64 %b, i64* %ptr) {
; CHECK-LABEL: test_add_cbz_64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmn x0, x1
; CHECK-NEXT:    b.eq .LBB2_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    str xzr, [x2]
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB2_2: // %L2
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    str x8, [x2]
; CHECK-NEXT:    ret
  %c = add nsw i64 %a, %b
  %d = icmp ne i64 %c, 0
  br i1 %d, label %L1, label %L2
L1:
  store i64 0, i64* %ptr, align 4
  ret void
L2:
  store i64 1, i64* %ptr, align 4
  ret void
}

define void @test_and_cbz(i32 %a, i32* %ptr) {
; CHECK-LABEL: test_and_cbz:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x6
; CHECK-NEXT:    b.eq .LBB3_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    str wzr, [x1]
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB3_2: // %L2
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    str w8, [x1]
; CHECK-NEXT:    ret
  %c = and i32 %a, 6
  %d = icmp ne i32 %c, 0
  br i1 %d, label %L1, label %L2
L1:
  store i32 0, i32* %ptr, align 4
  ret void
L2:
  store i32 1, i32* %ptr, align 4
  ret void
}

define void @test_bic_cbnz(i32 %a, i32 %b, i32* %ptr) {
; CHECK-LABEL: test_bic_cbnz:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bics wzr, w1, w0
; CHECK-NEXT:    b.ne .LBB4_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    str wzr, [x2]
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB4_2: // %L2
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    str w8, [x2]
; CHECK-NEXT:    ret
  %c = and i32 %a, %b
  %d = icmp eq i32 %c, %b
  br i1 %d, label %L1, label %L2
L1:
  store i32 0, i32* %ptr, align 4
  ret void
L2:
  store i32 1, i32* %ptr, align 4
  ret void
}

define void @test_add_tbz(i32 %a, i32 %b, i32* %ptr) {
; CHECK-LABEL: test_add_tbz:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    adds w8, w0, w1
; CHECK-NEXT:    b.pl .LBB5_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    str w8, [x2]
; CHECK-NEXT:  .LBB5_2: // %L2
; CHECK-NEXT:    ret
entry:
  %add = add nsw i32 %a, %b
  %cmp36 = icmp sge i32 %add, 0
  br i1 %cmp36, label %L2, label %L1
L1:
  store i32 %add, i32* %ptr, align 8
  br label %L2
L2:
  ret void
}

define void @test_subs_tbz(i32 %a, i32 %b, i32* %ptr) {
; CHECK-LABEL: test_subs_tbz:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    subs w8, w0, w1
; CHECK-NEXT:    b.pl .LBB6_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    str w8, [x2]
; CHECK-NEXT:  .LBB6_2: // %L2
; CHECK-NEXT:    ret
entry:
  %sub = sub nsw i32 %a, %b
  %cmp36 = icmp sge i32 %sub, 0
  br i1 %cmp36, label %L2, label %L1
L1:
  store i32 %sub, i32* %ptr, align 8
  br label %L2
L2:
  ret void
}

define void @test_add_tbnz(i32 %a, i32 %b, i32* %ptr) {
; CHECK-LABEL: test_add_tbnz:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    adds w8, w0, w1
; CHECK-NEXT:    b.mi .LBB7_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    str w8, [x2]
; CHECK-NEXT:  .LBB7_2: // %L2
; CHECK-NEXT:    ret
entry:
  %add = add nsw i32 %a, %b
  %cmp36 = icmp slt i32 %add, 0
  br i1 %cmp36, label %L2, label %L1
L1:
  store i32 %add, i32* %ptr, align 8
  br label %L2
L2:
  ret void
}

define void @test_subs_tbnz(i32 %a, i32 %b, i32* %ptr) {
; CHECK-LABEL: test_subs_tbnz:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    subs w8, w0, w1
; CHECK-NEXT:    b.mi .LBB8_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    str w8, [x2]
; CHECK-NEXT:  .LBB8_2: // %L2
; CHECK-NEXT:    ret
entry:
  %sub = sub nsw i32 %a, %b
  %cmp36 = icmp slt i32 %sub, 0
  br i1 %cmp36, label %L2, label %L1
L1:
  store i32 %sub, i32* %ptr, align 8
  br label %L2
L2:
  ret void
}

declare void @foo()
declare void @bar(i32)

; Don't transform since the call will clobber the NZCV bits.
define void @test_call_clobber(i32 %unused, i32 %a) {
; CHECK-LABEL: test_call_clobber:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    stp x30, x19, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w19, -8
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    and w19, w1, #0x6
; CHECK-NEXT:    mov w0, w19
; CHECK-NEXT:    bl bar
; CHECK-NEXT:    cbnz w19, .LBB9_2
; CHECK-NEXT:  // %bb.1: // %if.end
; CHECK-NEXT:    ldp x30, x19, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB9_2: // %if.then
; CHECK-NEXT:    bl foo
entry:
  %c = and i32 %a, 6
  call void @bar(i32 %c)
  %tobool = icmp eq i32 %c, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:
  tail call void @foo()
  unreachable

if.end:
  ret void
}
