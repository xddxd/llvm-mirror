; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -O0 -stop-after=irtranslator -global-isel -global-isel-abort=1 -verify-machineinstrs %s -o - | FileCheck %s

target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-linux-gnu"

define i32 @args_i32(i32 %w0, i32 %w1, i32 %w2, i32 %w3,
  ; CHECK-LABEL: name: args_i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $w0, $w1, $w2, $w3, $w4, $w5, $w6, $w7
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $w0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $w2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $w3
  ; CHECK:   [[COPY4:%[0-9]+]]:_(s32) = COPY $w4
  ; CHECK:   [[COPY5:%[0-9]+]]:_(s32) = COPY $w5
  ; CHECK:   [[COPY6:%[0-9]+]]:_(s32) = COPY $w6
  ; CHECK:   [[COPY7:%[0-9]+]]:_(s32) = COPY $w7
  ; CHECK:   $w0 = COPY [[COPY]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
                     i32 %w4, i32 %w5, i32 %w6, i32 %w7) {
  ret i32 %w0
}

define i64 @args_i64(i64 %x0, i64 %x1, i64 %x2, i64 %x3,
  ; CHECK-LABEL: name: args_i64
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x0, $x1, $x2, $x3, $x4, $x5, $x6, $x7
  ; CHECK:   [[COPY:%[0-9]+]]:_(s64) = COPY $x0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s64) = COPY $x1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s64) = COPY $x2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s64) = COPY $x3
  ; CHECK:   [[COPY4:%[0-9]+]]:_(s64) = COPY $x4
  ; CHECK:   [[COPY5:%[0-9]+]]:_(s64) = COPY $x5
  ; CHECK:   [[COPY6:%[0-9]+]]:_(s64) = COPY $x6
  ; CHECK:   [[COPY7:%[0-9]+]]:_(s64) = COPY $x7
  ; CHECK:   $x0 = COPY [[COPY]](s64)
  ; CHECK:   RET_ReallyLR implicit $x0
                     i64 %x4, i64 %x5, i64 %x6, i64 %x7) {
  ret i64 %x0
}


define i8* @args_ptrs(i8* %x0, i16* %x1, <2 x i8>* %x2, {i8, i16, i32}* %x3,
  ; CHECK-LABEL: name: args_ptrs
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x0, $x1, $x2, $x3, $x4, $x5, $x6, $x7
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(p0) = COPY $x1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(p0) = COPY $x2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(p0) = COPY $x3
  ; CHECK:   [[COPY4:%[0-9]+]]:_(p0) = COPY $x4
  ; CHECK:   [[COPY5:%[0-9]+]]:_(p0) = COPY $x5
  ; CHECK:   [[COPY6:%[0-9]+]]:_(p0) = COPY $x6
  ; CHECK:   [[COPY7:%[0-9]+]]:_(p0) = COPY $x7
  ; CHECK:   $x0 = COPY [[COPY]](p0)
  ; CHECK:   RET_ReallyLR implicit $x0
                      [3 x float]* %x4, double* %x5, i8* %x6, i8* %x7) {
  ret i8* %x0
}

define [1 x double] @args_arr([1 x double] %d0) {
  ; CHECK-LABEL: name: args_arr
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $d0
  ; CHECK:   [[COPY:%[0-9]+]]:_(s64) = COPY $d0
  ; CHECK:   $d0 = COPY [[COPY]](s64)
  ; CHECK:   RET_ReallyLR implicit $d0
  ret [1 x double] %d0
}

declare void @varargs(i32, double, i64, ...)
define void @test_varargs() {
  ; CHECK-LABEL: name: test_varargs
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 42
  ; CHECK:   [[C1:%[0-9]+]]:_(s64) = G_FCONSTANT double 1.000000e+00
  ; CHECK:   [[C2:%[0-9]+]]:_(s64) = G_CONSTANT i64 12
  ; CHECK:   [[C3:%[0-9]+]]:_(s8) = G_CONSTANT i8 3
  ; CHECK:   [[C4:%[0-9]+]]:_(s16) = G_CONSTANT i16 1
  ; CHECK:   [[C5:%[0-9]+]]:_(s32) = G_CONSTANT i32 4
  ; CHECK:   [[C6:%[0-9]+]]:_(s32) = G_FCONSTANT float 1.000000e+00
  ; CHECK:   [[C7:%[0-9]+]]:_(s64) = G_FCONSTANT double 2.000000e+00
  ; CHECK:   ADJCALLSTACKDOWN 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   $w0 = COPY [[C]](s32)
  ; CHECK:   $d0 = COPY [[C1]](s64)
  ; CHECK:   $x1 = COPY [[C2]](s64)
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[C3]](s8)
  ; CHECK:   $w2 = COPY [[ANYEXT]](s32)
  ; CHECK:   [[ANYEXT1:%[0-9]+]]:_(s32) = G_ANYEXT [[C4]](s16)
  ; CHECK:   $w3 = COPY [[ANYEXT1]](s32)
  ; CHECK:   $w4 = COPY [[C5]](s32)
  ; CHECK:   $s1 = COPY [[C6]](s32)
  ; CHECK:   $d2 = COPY [[C7]](s64)
  ; CHECK:   BL @varargs, csr_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $w0, implicit $d0, implicit $x1, implicit $w2, implicit $w3, implicit $w4, implicit $s1, implicit $d2
  ; CHECK:   ADJCALLSTACKUP 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   RET_ReallyLR
  call void(i32, double, i64, ...) @varargs(i32 42, double 1.0, i64 12, i8 3, i16 1, i32 4, float 1.0, double 2.0)
  ret void
}

; signext/zeroext parameters on the stack: not part of any real ABI as far as I
; know, but ELF currently allocates 8 bytes for a signext parameter on the
; stack. The ADJCALLSTACK ops should reflect this, even if the difference is
; theoretical.
declare void @stack_ext_needed([8 x i64], i8 signext %in)
define void @test_stack_ext_needed() {
  ; CHECK-LABEL: name: test_stack_ext_needed
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   [[DEF:%[0-9]+]]:_(s64) = G_IMPLICIT_DEF
  ; CHECK:   [[C:%[0-9]+]]:_(s8) = G_CONSTANT i8 42
  ; CHECK:   ADJCALLSTACKDOWN 8, 0, implicit-def $sp, implicit $sp
  ; CHECK:   $x0 = COPY [[DEF]](s64)
  ; CHECK:   $x1 = COPY [[DEF]](s64)
  ; CHECK:   $x2 = COPY [[DEF]](s64)
  ; CHECK:   $x3 = COPY [[DEF]](s64)
  ; CHECK:   $x4 = COPY [[DEF]](s64)
  ; CHECK:   $x5 = COPY [[DEF]](s64)
  ; CHECK:   $x6 = COPY [[DEF]](s64)
  ; CHECK:   $x7 = COPY [[DEF]](s64)
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $sp
  ; CHECK:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 0
  ; CHECK:   [[PTR_ADD:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C1]](s64)
  ; CHECK:   G_STORE [[C]](s8), [[PTR_ADD]](p0) :: (store 1 into stack)
  ; CHECK:   BL @stack_ext_needed, csr_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $x0, implicit $x1, implicit $x2, implicit $x3, implicit $x4, implicit $x5, implicit $x6, implicit $x7
  ; CHECK:   ADJCALLSTACKUP 8, 0, implicit-def $sp, implicit $sp
  ; CHECK:   RET_ReallyLR
  call void @stack_ext_needed([8 x i64] undef, i8 signext 42)
  ret void
}

; Check that we can lower incoming i128 types into constituent s64 gprs.
define void @callee_s128(i128 %a, i128 %b, i128 *%ptr) {
  ; CHECK-LABEL: name: callee_s128
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x0, $x1, $x2, $x3, $x4
  ; CHECK:   [[COPY:%[0-9]+]]:_(s64) = COPY $x0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s64) = COPY $x1
  ; CHECK:   [[MV:%[0-9]+]]:_(s128) = G_MERGE_VALUES [[COPY]](s64), [[COPY1]](s64)
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s64) = COPY $x2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s64) = COPY $x3
  ; CHECK:   [[MV1:%[0-9]+]]:_(s128) = G_MERGE_VALUES [[COPY2]](s64), [[COPY3]](s64)
  ; CHECK:   [[COPY4:%[0-9]+]]:_(p0) = COPY $x4
  ; CHECK:   G_STORE [[MV1]](s128), [[COPY4]](p0) :: (store 16 into %ir.ptr)
  ; CHECK:   RET_ReallyLR
  store i128 %b, i128 *%ptr
  ret void
}

; Check we can lower outgoing s128 arguments into s64 gprs.
define void @caller_s128(i128 *%ptr) {
  ; CHECK-LABEL: name: caller_s128
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x0
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK:   [[LOAD:%[0-9]+]]:_(s128) = G_LOAD [[COPY]](p0) :: (load 16 from %ir.ptr)
  ; CHECK:   ADJCALLSTACKDOWN 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   [[UV:%[0-9]+]]:_(s64), [[UV1:%[0-9]+]]:_(s64) = G_UNMERGE_VALUES [[LOAD]](s128)
  ; CHECK:   $x0 = COPY [[UV]](s64)
  ; CHECK:   $x1 = COPY [[UV1]](s64)
  ; CHECK:   [[UV2:%[0-9]+]]:_(s64), [[UV3:%[0-9]+]]:_(s64) = G_UNMERGE_VALUES [[LOAD]](s128)
  ; CHECK:   $x2 = COPY [[UV2]](s64)
  ; CHECK:   $x3 = COPY [[UV3]](s64)
  ; CHECK:   $x4 = COPY [[COPY]](p0)
  ; CHECK:   BL @callee_s128, csr_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $x0, implicit $x1, implicit $x2, implicit $x3, implicit $x4
  ; CHECK:   ADJCALLSTACKUP 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   RET_ReallyLR
  %v = load i128, i128 *%ptr
  call void @callee_s128(i128 %v, i128 %v, i128 *%ptr)
  ret void
}


declare i64 @i8i16callee(i64 %a1, i64 %a2, i64 %a3, i8 signext %a4, i16 signext %a5, i64 %a6, i64 %a7, i64 %a8, i8 signext %b1, i16 signext %b2, i8 signext %b3, i8 signext %b4) nounwind readnone noinline

define i32 @i8i16caller() nounwind readnone {
  ; CHECK-LABEL: name: i8i16caller
  ; CHECK: bb.1.entry:
  ; CHECK:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 0
  ; CHECK:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 1
  ; CHECK:   [[C2:%[0-9]+]]:_(s64) = G_CONSTANT i64 2
  ; CHECK:   [[C3:%[0-9]+]]:_(s8) = G_CONSTANT i8 3
  ; CHECK:   [[C4:%[0-9]+]]:_(s16) = G_CONSTANT i16 4
  ; CHECK:   [[C5:%[0-9]+]]:_(s64) = G_CONSTANT i64 5
  ; CHECK:   [[C6:%[0-9]+]]:_(s64) = G_CONSTANT i64 6
  ; CHECK:   [[C7:%[0-9]+]]:_(s64) = G_CONSTANT i64 7
  ; CHECK:   [[C8:%[0-9]+]]:_(s8) = G_CONSTANT i8 97
  ; CHECK:   [[C9:%[0-9]+]]:_(s16) = G_CONSTANT i16 98
  ; CHECK:   [[C10:%[0-9]+]]:_(s8) = G_CONSTANT i8 99
  ; CHECK:   [[C11:%[0-9]+]]:_(s8) = G_CONSTANT i8 100
  ; CHECK:   ADJCALLSTACKDOWN 32, 0, implicit-def $sp, implicit $sp
  ; CHECK:   $x0 = COPY [[C]](s64)
  ; CHECK:   $x1 = COPY [[C1]](s64)
  ; CHECK:   $x2 = COPY [[C2]](s64)
  ; CHECK:   [[SEXT:%[0-9]+]]:_(s32) = G_SEXT [[C3]](s8)
  ; CHECK:   $w3 = COPY [[SEXT]](s32)
  ; CHECK:   [[SEXT1:%[0-9]+]]:_(s32) = G_SEXT [[C4]](s16)
  ; CHECK:   $w4 = COPY [[SEXT1]](s32)
  ; CHECK:   $x5 = COPY [[C5]](s64)
  ; CHECK:   $x6 = COPY [[C6]](s64)
  ; CHECK:   $x7 = COPY [[C7]](s64)
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $sp
  ; CHECK:   [[C12:%[0-9]+]]:_(s64) = G_CONSTANT i64 0
  ; CHECK:   [[PTR_ADD:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C12]](s64)
  ; CHECK:   G_STORE [[C8]](s8), [[PTR_ADD]](p0) :: (store 1 into stack)
  ; CHECK:   [[C13:%[0-9]+]]:_(s64) = G_CONSTANT i64 8
  ; CHECK:   [[PTR_ADD1:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C13]](s64)
  ; CHECK:   G_STORE [[C9]](s16), [[PTR_ADD1]](p0) :: (store 2 into stack + 8, align 1)
  ; CHECK:   [[C14:%[0-9]+]]:_(s64) = G_CONSTANT i64 16
  ; CHECK:   [[PTR_ADD2:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C14]](s64)
  ; CHECK:   G_STORE [[C10]](s8), [[PTR_ADD2]](p0) :: (store 1 into stack + 16)
  ; CHECK:   [[C15:%[0-9]+]]:_(s64) = G_CONSTANT i64 24
  ; CHECK:   [[PTR_ADD3:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C15]](s64)
  ; CHECK:   G_STORE [[C11]](s8), [[PTR_ADD3]](p0) :: (store 1 into stack + 24)
  ; CHECK:   BL @i8i16callee, csr_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $x0, implicit $x1, implicit $x2, implicit $w3, implicit $w4, implicit $x5, implicit $x6, implicit $x7, implicit-def $x0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s64) = COPY $x0
  ; CHECK:   ADJCALLSTACKUP 32, 0, implicit-def $sp, implicit $sp
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s32) = G_TRUNC [[COPY1]](s64)
  ; CHECK:   $w0 = COPY [[TRUNC]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
entry:
  %call = tail call i64 @i8i16callee(i64 0, i64 1, i64 2, i8 signext 3, i16 signext 4, i64 5, i64 6, i64 7, i8 97, i16  98, i8  99, i8  100)
  %conv = trunc i64 %call to i32
  ret i32 %conv
}

