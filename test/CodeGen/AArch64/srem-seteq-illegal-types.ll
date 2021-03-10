; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s

define i1 @test_srem_odd(i29 %X) nounwind {
; CHECK-LABEL: test_srem_odd:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w9, #33099
; CHECK-NEXT:    mov w10, #64874
; CHECK-NEXT:    sbfx w8, w0, #0, #29
; CHECK-NEXT:    movk w9, #48986, lsl #16
; CHECK-NEXT:    movk w10, #330, lsl #16
; CHECK-NEXT:    madd w8, w8, w9, w10
; CHECK-NEXT:    mov w9, #64213
; CHECK-NEXT:    movk w9, #661, lsl #16
; CHECK-NEXT:    cmp w8, w9
; CHECK-NEXT:    cset w0, lo
; CHECK-NEXT:    ret
  %srem = srem i29 %X, 99
  %cmp = icmp eq i29 %srem, 0
  ret i1 %cmp
}

define i1 @test_srem_even(i4 %X) nounwind {
; CHECK-LABEL: test_srem_even:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w9, #43691
; CHECK-NEXT:    sbfx w8, w0, #0, #4
; CHECK-NEXT:    movk w9, #10922, lsl #16
; CHECK-NEXT:    smull x9, w8, w9
; CHECK-NEXT:    lsr x10, x9, #63
; CHECK-NEXT:    lsr x9, x9, #32
; CHECK-NEXT:    add w9, w9, w10
; CHECK-NEXT:    mov w10, #6
; CHECK-NEXT:    msub w8, w9, w10, w8
; CHECK-NEXT:    cmp w8, #1 // =1
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %srem = srem i4 %X, 6
  %cmp = icmp eq i4 %srem, 1
  ret i1 %cmp
}

define i1 @test_srem_pow2_setne(i6 %X) nounwind {
; CHECK-LABEL: test_srem_pow2_setne:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sbfx w8, w0, #0, #6
; CHECK-NEXT:    ubfx w8, w8, #9, #2
; CHECK-NEXT:    add w8, w0, w8
; CHECK-NEXT:    and w8, w8, #0x3c
; CHECK-NEXT:    sub w8, w0, w8
; CHECK-NEXT:    tst w8, #0x3f
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %srem = srem i6 %X, 4
  %cmp = icmp ne i6 %srem, 0
  ret i1 %cmp
}

define <3 x i1> @test_srem_vec(<3 x i33> %X) nounwind {
; CHECK-LABEL: test_srem_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x10, #7281
; CHECK-NEXT:    movk x10, #29127, lsl #16
; CHECK-NEXT:    movk x10, #50972, lsl #32
; CHECK-NEXT:    sbfx x9, x2, #0, #33
; CHECK-NEXT:    movk x10, #7281, lsl #48
; CHECK-NEXT:    mov x11, #8589934591
; CHECK-NEXT:    mov x12, #7282
; CHECK-NEXT:    movk x12, #29127, lsl #16
; CHECK-NEXT:    dup v0.2d, x11
; CHECK-NEXT:    adrp x11, .LCPI3_0
; CHECK-NEXT:    smulh x10, x9, x10
; CHECK-NEXT:    movk x12, #50972, lsl #32
; CHECK-NEXT:    ldr q1, [x11, :lo12:.LCPI3_0]
; CHECK-NEXT:    adrp x11, .LCPI3_1
; CHECK-NEXT:    sub x10, x10, x9
; CHECK-NEXT:    sbfx x8, x1, #0, #33
; CHECK-NEXT:    movk x12, #7281, lsl #48
; CHECK-NEXT:    ldr q2, [x11, :lo12:.LCPI3_1]
; CHECK-NEXT:    asr x11, x10, #3
; CHECK-NEXT:    add x10, x11, x10, lsr #63
; CHECK-NEXT:    smulh x11, x8, x12
; CHECK-NEXT:    add x11, x11, x11, lsr #63
; CHECK-NEXT:    add x11, x11, x11, lsl #3
; CHECK-NEXT:    sub x8, x8, x11
; CHECK-NEXT:    sbfx x11, x0, #0, #33
; CHECK-NEXT:    smulh x12, x11, x12
; CHECK-NEXT:    add x12, x12, x12, lsr #63
; CHECK-NEXT:    add x12, x12, x12, lsl #3
; CHECK-NEXT:    sub x11, x11, x12
; CHECK-NEXT:    add x10, x10, x10, lsl #3
; CHECK-NEXT:    fmov d3, x11
; CHECK-NEXT:    add x9, x9, x10
; CHECK-NEXT:    mov v3.d[1], x8
; CHECK-NEXT:    fmov d4, x9
; CHECK-NEXT:    and v4.16b, v4.16b, v0.16b
; CHECK-NEXT:    and v0.16b, v3.16b, v0.16b
; CHECK-NEXT:    cmeq v0.2d, v0.2d, v1.2d
; CHECK-NEXT:    cmeq v1.2d, v4.2d, v2.2d
; CHECK-NEXT:    mvn v0.16b, v0.16b
; CHECK-NEXT:    mvn v1.16b, v1.16b
; CHECK-NEXT:    xtn v0.2s, v0.2d
; CHECK-NEXT:    xtn v1.2s, v1.2d
; CHECK-NEXT:    mov w1, v0.s[1]
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    fmov w2, s1
; CHECK-NEXT:    ret
  %srem = srem <3 x i33> %X, <i33 9, i33 9, i33 -9>
  %cmp = icmp ne <3 x i33> %srem, <i33 3, i33 -3, i33 3>
  ret <3 x i1> %cmp
}
