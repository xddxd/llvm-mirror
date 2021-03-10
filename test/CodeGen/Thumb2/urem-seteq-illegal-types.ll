; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv7-none-eabi < %s | FileCheck %s

define i1 @test_urem_odd(i13 %X) nounwind {
; CHECK-LABEL: test_urem_odd:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r1, #52429
; CHECK-NEXT:    bfc r0, #13, #19
; CHECK-NEXT:    movt r1, #52428
; CHECK-NEXT:    muls r1, r0, r1
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    cmn.w r1, #-858993460
; CHECK-NEXT:    it lo
; CHECK-NEXT:    movlo r0, #1
; CHECK-NEXT:    bx lr
  %urem = urem i13 %X, 5
  %cmp = icmp eq i13 %urem, 0
  ret i1 %cmp
}

define i1 @test_urem_even(i27 %X) nounwind {
; CHECK-LABEL: test_urem_even:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r1, #28087
; CHECK-NEXT:    bic r0, r0, #-134217728
; CHECK-NEXT:    movt r1, #46811
; CHECK-NEXT:    movw r2, #9363
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    movt r2, #4681
; CHECK-NEXT:    ror.w r1, r0, #1
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    cmp r1, r2
; CHECK-NEXT:    it lo
; CHECK-NEXT:    movlo r0, #1
; CHECK-NEXT:    bx lr
  %urem = urem i27 %X, 14
  %cmp = icmp eq i27 %urem, 0
  ret i1 %cmp
}

define i1 @test_urem_odd_setne(i4 %X) nounwind {
; CHECK-LABEL: test_urem_odd_setne:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r1, #52429
; CHECK-NEXT:    and r0, r0, #15
; CHECK-NEXT:    movt r1, #52428
; CHECK-NEXT:    muls r1, r0, r1
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    cmp.w r1, #858993459
; CHECK-NEXT:    it hi
; CHECK-NEXT:    movhi r0, #1
; CHECK-NEXT:    bx lr
  %urem = urem i4 %X, 5
  %cmp = icmp ne i4 %urem, 0
  ret i1 %cmp
}

define i1 @test_urem_negative_odd(i9 %X) nounwind {
; CHECK-LABEL: test_urem_negative_odd:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r1, #57651
; CHECK-NEXT:    bfc r0, #9, #23
; CHECK-NEXT:    movt r1, #43302
; CHECK-NEXT:    movw r2, #17191
; CHECK-NEXT:    muls r1, r0, r1
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    movt r2, #129
; CHECK-NEXT:    cmp r1, r2
; CHECK-NEXT:    it hi
; CHECK-NEXT:    movhi r0, #1
; CHECK-NEXT:    bx lr
  %urem = urem i9 %X, -5
  %cmp = icmp ne i9 %urem, 0
  ret i1 %cmp
}

define <3 x i1> @test_urem_vec(<3 x i11> %X) nounwind {
; CHECK-LABEL: test_urem_vec:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    movw r3, #18725
; CHECK-NEXT:    bfc r1, #11, #21
; CHECK-NEXT:    movt r3, #9362
; CHECK-NEXT:    bfc r2, #11, #21
; CHECK-NEXT:    umull r3, r12, r1, r3
; CHECK-NEXT:    bfc r0, #11, #21
; CHECK-NEXT:    movw r3, #25663
; CHECK-NEXT:    movt r3, #160
; CHECK-NEXT:    umull r3, lr, r2, r3
; CHECK-NEXT:    vldr d17, .LCPI4_0
; CHECK-NEXT:    movw r3, #43691
; CHECK-NEXT:    movt r3, #43690
; CHECK-NEXT:    umull r3, r4, r0, r3
; CHECK-NEXT:    sub.w r3, r1, r12
; CHECK-NEXT:    add.w r3, r12, r3, lsr #1
; CHECK-NEXT:    lsr.w r12, r3, #2
; CHECK-NEXT:    sub.w r3, r2, lr
; CHECK-NEXT:    lsrs r4, r4, #2
; CHECK-NEXT:    add.w r4, r4, r4, lsl #1
; CHECK-NEXT:    add.w r3, lr, r3, lsr #1
; CHECK-NEXT:    sub.w r0, r0, r4, lsl #1
; CHECK-NEXT:    lsr.w lr, r3, #10
; CHECK-NEXT:    movw r3, #2043
; CHECK-NEXT:    vmov.16 d16[0], r0
; CHECK-NEXT:    sub.w r0, r12, r12, lsl #3
; CHECK-NEXT:    mls r2, lr, r3, r2
; CHECK-NEXT:    add r0, r1
; CHECK-NEXT:    vmov.16 d16[1], r0
; CHECK-NEXT:    vmov.16 d16[2], r2
; CHECK-NEXT:    vbic.i16 d16, #0xf800
; CHECK-NEXT:    vceq.i16 d16, d16, d17
; CHECK-NEXT:    vmvn d16, d16
; CHECK-NEXT:    vmov.u16 r0, d16[0]
; CHECK-NEXT:    vmov.u16 r1, d16[1]
; CHECK-NEXT:    vmov.u16 r2, d16[2]
; CHECK-NEXT:    pop {r4, pc}
; CHECK-NEXT:    .p2align 3
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI4_0:
; CHECK-NEXT:    .short 0 @ 0x0
; CHECK-NEXT:    .short 1 @ 0x1
; CHECK-NEXT:    .short 2 @ 0x2
; CHECK-NEXT:    .short 0 @ 0x0
  %urem = urem <3 x i11> %X, <i11 6, i11 7, i11 -5>
  %cmp = icmp ne <3 x i11> %urem, <i11 0, i11 1, i11 2>
  ret <3 x i1> %cmp
}
