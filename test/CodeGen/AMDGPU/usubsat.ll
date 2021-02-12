; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdpal -mcpu=tahiti < %s | FileCheck --check-prefix=GFX6 %s
; RUN: llc -mtriple=amdgcn-amd-amdpal -mcpu=fiji < %s | FileCheck --check-prefix=GFX8 %s
; RUN: llc -mtriple=amdgcn-amd-amdpal -mcpu=gfx900 < %s | FileCheck --check-prefix=GFX9 %s

define i8 @v_usubsat_i8(i8 %lhs, i8 %rhs) {
; GFX6-LABEL: v_usubsat_i8:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    s_movk_i32 s4, 0xff
; GFX6-NEXT:    v_and_b32_e32 v1, s4, v1
; GFX6-NEXT:    v_and_b32_e32 v0, s4, v0
; GFX6-NEXT:    v_max_u32_e32 v0, v0, v1
; GFX6-NEXT:    v_sub_i32_e32 v0, vcc, v0, v1
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_usubsat_i8:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_lshlrev_b16_e32 v1, 8, v1
; GFX8-NEXT:    v_lshlrev_b16_e32 v0, 8, v0
; GFX8-NEXT:    v_sub_u16_e64 v0, v0, v1 clamp
; GFX8-NEXT:    v_lshrrev_b16_e32 v0, 8, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_usubsat_i8:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_lshlrev_b16_e32 v1, 8, v1
; GFX9-NEXT:    v_lshlrev_b16_e32 v0, 8, v0
; GFX9-NEXT:    v_sub_u16_e64 v0, v0, v1 clamp
; GFX9-NEXT:    v_lshrrev_b16_e32 v0, 8, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %result = call i8 @llvm.usub.sat.i8(i8 %lhs, i8 %rhs)
  ret i8 %result
}

define i16 @v_usubsat_i16(i16 %lhs, i16 %rhs) {
; GFX6-LABEL: v_usubsat_i16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    s_mov_b32 s4, 0xffff
; GFX6-NEXT:    v_and_b32_e32 v1, s4, v1
; GFX6-NEXT:    v_and_b32_e32 v0, s4, v0
; GFX6-NEXT:    v_max_u32_e32 v0, v0, v1
; GFX6-NEXT:    v_sub_i32_e32 v0, vcc, v0, v1
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_usubsat_i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_u16_e64 v0, v0, v1 clamp
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_usubsat_i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_sub_u16_e64 v0, v0, v1 clamp
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %result = call i16 @llvm.usub.sat.i16(i16 %lhs, i16 %rhs)
  ret i16 %result
}

define i32 @v_usubsat_i32(i32 %lhs, i32 %rhs) {
; GFX6-LABEL: v_usubsat_i32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_max_u32_e32 v0, v0, v1
; GFX6-NEXT:    v_sub_i32_e32 v0, vcc, v0, v1
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_usubsat_i32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_u32_e64 v0, s[4:5], v0, v1 clamp
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_usubsat_i32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_sub_u32_e64 v0, v0, v1 clamp
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %result = call i32 @llvm.usub.sat.i32(i32 %lhs, i32 %rhs)
  ret i32 %result
}

define <2 x i16> @v_usubsat_v2i16(<2 x i16> %lhs, <2 x i16> %rhs) {
; GFX6-LABEL: v_usubsat_v2i16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    s_mov_b32 s4, 0xffff
; GFX6-NEXT:    v_and_b32_e32 v4, s4, v2
; GFX6-NEXT:    v_and_b32_e32 v0, s4, v0
; GFX6-NEXT:    v_and_b32_e32 v5, s4, v3
; GFX6-NEXT:    v_and_b32_e32 v1, s4, v1
; GFX6-NEXT:    v_max_u32_e32 v1, v1, v5
; GFX6-NEXT:    v_max_u32_e32 v0, v0, v4
; GFX6-NEXT:    v_sub_i32_e32 v1, vcc, v1, v3
; GFX6-NEXT:    v_sub_i32_e32 v0, vcc, v0, v2
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX6-NEXT:    v_and_b32_e32 v0, s4, v0
; GFX6-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX6-NEXT:    v_lshrrev_b32_e32 v1, 16, v0
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_usubsat_v2i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_u16_sdwa v2, v0, v1 clamp dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_sub_u16_e64 v0, v0, v1 clamp
; GFX8-NEXT:    v_or_b32_sdwa v0, v0, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_usubsat_v2i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_sub_u16 v0, v0, v1 clamp
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %result = call <2 x i16> @llvm.usub.sat.v2i16(<2 x i16> %lhs, <2 x i16> %rhs)
  ret <2 x i16> %result
}

define <3 x i16> @v_usubsat_v3i16(<3 x i16> %lhs, <3 x i16> %rhs) {
; GFX6-LABEL: v_usubsat_v3i16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    s_mov_b32 s4, 0xffff
; GFX6-NEXT:    v_and_b32_e32 v6, s4, v3
; GFX6-NEXT:    v_and_b32_e32 v0, s4, v0
; GFX6-NEXT:    v_and_b32_e32 v7, s4, v4
; GFX6-NEXT:    v_and_b32_e32 v1, s4, v1
; GFX6-NEXT:    v_max_u32_e32 v1, v1, v7
; GFX6-NEXT:    v_max_u32_e32 v0, v0, v6
; GFX6-NEXT:    v_and_b32_e32 v5, s4, v5
; GFX6-NEXT:    v_and_b32_e32 v2, s4, v2
; GFX6-NEXT:    v_sub_i32_e32 v1, vcc, v1, v4
; GFX6-NEXT:    v_sub_i32_e32 v0, vcc, v0, v3
; GFX6-NEXT:    v_max_u32_e32 v2, v2, v5
; GFX6-NEXT:    v_sub_i32_e32 v3, vcc, v2, v5
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX6-NEXT:    v_and_b32_e32 v0, s4, v0
; GFX6-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX6-NEXT:    v_and_b32_e32 v2, s4, v3
; GFX6-NEXT:    v_alignbit_b32 v1, v3, v1, 16
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_usubsat_v3i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_u16_sdwa v4, v0, v2 clamp dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_sub_u16_e64 v0, v0, v2 clamp
; GFX8-NEXT:    v_sub_u16_e64 v1, v1, v3 clamp
; GFX8-NEXT:    v_or_b32_sdwa v0, v0, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_usubsat_v3i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_sub_u16 v0, v0, v2 clamp
; GFX9-NEXT:    v_pk_sub_u16 v1, v1, v3 clamp
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %result = call <3 x i16> @llvm.usub.sat.v3i16(<3 x i16> %lhs, <3 x i16> %rhs)
  ret <3 x i16> %result
}

define <2 x float> @v_usubsat_v4i16(<4 x i16> %lhs, <4 x i16> %rhs) {
; GFX6-LABEL: v_usubsat_v4i16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    s_mov_b32 s4, 0xffff
; GFX6-NEXT:    v_and_b32_e32 v10, s4, v4
; GFX6-NEXT:    v_and_b32_e32 v0, s4, v0
; GFX6-NEXT:    v_and_b32_e32 v11, s4, v5
; GFX6-NEXT:    v_and_b32_e32 v1, s4, v1
; GFX6-NEXT:    v_max_u32_e32 v1, v1, v11
; GFX6-NEXT:    v_max_u32_e32 v0, v0, v10
; GFX6-NEXT:    v_sub_i32_e32 v1, vcc, v1, v5
; GFX6-NEXT:    v_sub_i32_e32 v0, vcc, v0, v4
; GFX6-NEXT:    v_and_b32_e32 v8, s4, v6
; GFX6-NEXT:    v_and_b32_e32 v2, s4, v2
; GFX6-NEXT:    v_and_b32_e32 v9, s4, v7
; GFX6-NEXT:    v_and_b32_e32 v3, s4, v3
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX6-NEXT:    v_and_b32_e32 v0, s4, v0
; GFX6-NEXT:    v_max_u32_e32 v2, v2, v8
; GFX6-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX6-NEXT:    v_max_u32_e32 v1, v3, v9
; GFX6-NEXT:    v_sub_i32_e32 v1, vcc, v1, v7
; GFX6-NEXT:    v_sub_i32_e32 v2, vcc, v2, v6
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX6-NEXT:    v_and_b32_e32 v2, 0xffff, v2
; GFX6-NEXT:    v_or_b32_e32 v1, v2, v1
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_usubsat_v4i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_u16_sdwa v4, v0, v2 clamp dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_sub_u16_e64 v0, v0, v2 clamp
; GFX8-NEXT:    v_sub_u16_sdwa v2, v1, v3 clamp dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_sub_u16_e64 v1, v1, v3 clamp
; GFX8-NEXT:    v_or_b32_sdwa v0, v0, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v1, v1, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_usubsat_v4i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_sub_u16 v0, v0, v2 clamp
; GFX9-NEXT:    v_pk_sub_u16 v1, v1, v3 clamp
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %result = call <4 x i16> @llvm.usub.sat.v4i16(<4 x i16> %lhs, <4 x i16> %rhs)
  %cast = bitcast <4 x i16> %result to <2 x float>
  ret <2 x float> %cast
}

define <2 x i32> @v_usubsat_v2i32(<2 x i32> %lhs, <2 x i32> %rhs) {
; GFX6-LABEL: v_usubsat_v2i32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_max_u32_e32 v0, v0, v2
; GFX6-NEXT:    v_max_u32_e32 v1, v1, v3
; GFX6-NEXT:    v_sub_i32_e32 v0, vcc, v0, v2
; GFX6-NEXT:    v_sub_i32_e32 v1, vcc, v1, v3
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_usubsat_v2i32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_u32_e64 v0, s[4:5], v0, v2 clamp
; GFX8-NEXT:    v_sub_u32_e64 v1, s[4:5], v1, v3 clamp
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_usubsat_v2i32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_sub_u32_e64 v0, v0, v2 clamp
; GFX9-NEXT:    v_sub_u32_e64 v1, v1, v3 clamp
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %result = call <2 x i32> @llvm.usub.sat.v2i32(<2 x i32> %lhs, <2 x i32> %rhs)
  ret <2 x i32> %result
}

define <3 x i32> @v_usubsat_v3i32(<3 x i32> %lhs, <3 x i32> %rhs) {
; GFX6-LABEL: v_usubsat_v3i32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_max_u32_e32 v0, v0, v3
; GFX6-NEXT:    v_max_u32_e32 v1, v1, v4
; GFX6-NEXT:    v_max_u32_e32 v2, v2, v5
; GFX6-NEXT:    v_sub_i32_e32 v0, vcc, v0, v3
; GFX6-NEXT:    v_sub_i32_e32 v1, vcc, v1, v4
; GFX6-NEXT:    v_sub_i32_e32 v2, vcc, v2, v5
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_usubsat_v3i32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_u32_e64 v0, s[4:5], v0, v3 clamp
; GFX8-NEXT:    v_sub_u32_e64 v1, s[4:5], v1, v4 clamp
; GFX8-NEXT:    v_sub_u32_e64 v2, s[4:5], v2, v5 clamp
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_usubsat_v3i32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_sub_u32_e64 v0, v0, v3 clamp
; GFX9-NEXT:    v_sub_u32_e64 v1, v1, v4 clamp
; GFX9-NEXT:    v_sub_u32_e64 v2, v2, v5 clamp
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %result = call <3 x i32> @llvm.usub.sat.v3i32(<3 x i32> %lhs, <3 x i32> %rhs)
  ret <3 x i32> %result
}

define <4 x i32> @v_usubsat_v4i32(<4 x i32> %lhs, <4 x i32> %rhs) {
; GFX6-LABEL: v_usubsat_v4i32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_max_u32_e32 v0, v0, v4
; GFX6-NEXT:    v_max_u32_e32 v1, v1, v5
; GFX6-NEXT:    v_max_u32_e32 v2, v2, v6
; GFX6-NEXT:    v_max_u32_e32 v3, v3, v7
; GFX6-NEXT:    v_sub_i32_e32 v0, vcc, v0, v4
; GFX6-NEXT:    v_sub_i32_e32 v1, vcc, v1, v5
; GFX6-NEXT:    v_sub_i32_e32 v2, vcc, v2, v6
; GFX6-NEXT:    v_sub_i32_e32 v3, vcc, v3, v7
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_usubsat_v4i32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_u32_e64 v0, s[4:5], v0, v4 clamp
; GFX8-NEXT:    v_sub_u32_e64 v1, s[4:5], v1, v5 clamp
; GFX8-NEXT:    v_sub_u32_e64 v2, s[4:5], v2, v6 clamp
; GFX8-NEXT:    v_sub_u32_e64 v3, s[4:5], v3, v7 clamp
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_usubsat_v4i32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_sub_u32_e64 v0, v0, v4 clamp
; GFX9-NEXT:    v_sub_u32_e64 v1, v1, v5 clamp
; GFX9-NEXT:    v_sub_u32_e64 v2, v2, v6 clamp
; GFX9-NEXT:    v_sub_u32_e64 v3, v3, v7 clamp
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %result = call <4 x i32> @llvm.usub.sat.v4i32(<4 x i32> %lhs, <4 x i32> %rhs)
  ret <4 x i32> %result
}

define <8 x i32> @v_usubsat_v8i32(<8 x i32> %lhs, <8 x i32> %rhs) {
; GFX6-LABEL: v_usubsat_v8i32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_max_u32_e32 v0, v0, v8
; GFX6-NEXT:    v_max_u32_e32 v1, v1, v9
; GFX6-NEXT:    v_max_u32_e32 v2, v2, v10
; GFX6-NEXT:    v_max_u32_e32 v3, v3, v11
; GFX6-NEXT:    v_max_u32_e32 v4, v4, v12
; GFX6-NEXT:    v_max_u32_e32 v5, v5, v13
; GFX6-NEXT:    v_max_u32_e32 v6, v6, v14
; GFX6-NEXT:    v_max_u32_e32 v7, v7, v15
; GFX6-NEXT:    v_sub_i32_e32 v0, vcc, v0, v8
; GFX6-NEXT:    v_sub_i32_e32 v1, vcc, v1, v9
; GFX6-NEXT:    v_sub_i32_e32 v2, vcc, v2, v10
; GFX6-NEXT:    v_sub_i32_e32 v3, vcc, v3, v11
; GFX6-NEXT:    v_sub_i32_e32 v4, vcc, v4, v12
; GFX6-NEXT:    v_sub_i32_e32 v5, vcc, v5, v13
; GFX6-NEXT:    v_sub_i32_e32 v6, vcc, v6, v14
; GFX6-NEXT:    v_sub_i32_e32 v7, vcc, v7, v15
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_usubsat_v8i32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_u32_e64 v0, s[4:5], v0, v8 clamp
; GFX8-NEXT:    v_sub_u32_e64 v1, s[4:5], v1, v9 clamp
; GFX8-NEXT:    v_sub_u32_e64 v2, s[4:5], v2, v10 clamp
; GFX8-NEXT:    v_sub_u32_e64 v3, s[4:5], v3, v11 clamp
; GFX8-NEXT:    v_sub_u32_e64 v4, s[4:5], v4, v12 clamp
; GFX8-NEXT:    v_sub_u32_e64 v5, s[4:5], v5, v13 clamp
; GFX8-NEXT:    v_sub_u32_e64 v6, s[4:5], v6, v14 clamp
; GFX8-NEXT:    v_sub_u32_e64 v7, s[4:5], v7, v15 clamp
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_usubsat_v8i32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_sub_u32_e64 v0, v0, v8 clamp
; GFX9-NEXT:    v_sub_u32_e64 v1, v1, v9 clamp
; GFX9-NEXT:    v_sub_u32_e64 v2, v2, v10 clamp
; GFX9-NEXT:    v_sub_u32_e64 v3, v3, v11 clamp
; GFX9-NEXT:    v_sub_u32_e64 v4, v4, v12 clamp
; GFX9-NEXT:    v_sub_u32_e64 v5, v5, v13 clamp
; GFX9-NEXT:    v_sub_u32_e64 v6, v6, v14 clamp
; GFX9-NEXT:    v_sub_u32_e64 v7, v7, v15 clamp
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %result = call <8 x i32> @llvm.usub.sat.v8i32(<8 x i32> %lhs, <8 x i32> %rhs)
  ret <8 x i32> %result
}

define <16 x i32> @v_usubsat_v16i32(<16 x i32> %lhs, <16 x i32> %rhs) {
; GFX6-LABEL: v_usubsat_v16i32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_max_u32_e32 v0, v0, v16
; GFX6-NEXT:    v_max_u32_e32 v1, v1, v17
; GFX6-NEXT:    v_max_u32_e32 v2, v2, v18
; GFX6-NEXT:    v_max_u32_e32 v3, v3, v19
; GFX6-NEXT:    v_max_u32_e32 v4, v4, v20
; GFX6-NEXT:    v_max_u32_e32 v5, v5, v21
; GFX6-NEXT:    v_max_u32_e32 v6, v6, v22
; GFX6-NEXT:    v_max_u32_e32 v7, v7, v23
; GFX6-NEXT:    v_max_u32_e32 v8, v8, v24
; GFX6-NEXT:    v_max_u32_e32 v9, v9, v25
; GFX6-NEXT:    v_max_u32_e32 v10, v10, v26
; GFX6-NEXT:    v_max_u32_e32 v11, v11, v27
; GFX6-NEXT:    v_max_u32_e32 v12, v12, v28
; GFX6-NEXT:    v_max_u32_e32 v13, v13, v29
; GFX6-NEXT:    v_max_u32_e32 v14, v14, v30
; GFX6-NEXT:    v_max_u32_e32 v15, v15, v31
; GFX6-NEXT:    v_sub_i32_e32 v0, vcc, v0, v16
; GFX6-NEXT:    v_sub_i32_e32 v1, vcc, v1, v17
; GFX6-NEXT:    v_sub_i32_e32 v2, vcc, v2, v18
; GFX6-NEXT:    v_sub_i32_e32 v3, vcc, v3, v19
; GFX6-NEXT:    v_sub_i32_e32 v4, vcc, v4, v20
; GFX6-NEXT:    v_sub_i32_e32 v5, vcc, v5, v21
; GFX6-NEXT:    v_sub_i32_e32 v6, vcc, v6, v22
; GFX6-NEXT:    v_sub_i32_e32 v7, vcc, v7, v23
; GFX6-NEXT:    v_sub_i32_e32 v8, vcc, v8, v24
; GFX6-NEXT:    v_sub_i32_e32 v9, vcc, v9, v25
; GFX6-NEXT:    v_sub_i32_e32 v10, vcc, v10, v26
; GFX6-NEXT:    v_sub_i32_e32 v11, vcc, v11, v27
; GFX6-NEXT:    v_sub_i32_e32 v12, vcc, v12, v28
; GFX6-NEXT:    v_sub_i32_e32 v13, vcc, v13, v29
; GFX6-NEXT:    v_sub_i32_e32 v14, vcc, v14, v30
; GFX6-NEXT:    v_sub_i32_e32 v15, vcc, v15, v31
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_usubsat_v16i32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_u32_e64 v0, s[4:5], v0, v16 clamp
; GFX8-NEXT:    v_sub_u32_e64 v1, s[4:5], v1, v17 clamp
; GFX8-NEXT:    v_sub_u32_e64 v2, s[4:5], v2, v18 clamp
; GFX8-NEXT:    v_sub_u32_e64 v3, s[4:5], v3, v19 clamp
; GFX8-NEXT:    v_sub_u32_e64 v4, s[4:5], v4, v20 clamp
; GFX8-NEXT:    v_sub_u32_e64 v5, s[4:5], v5, v21 clamp
; GFX8-NEXT:    v_sub_u32_e64 v6, s[4:5], v6, v22 clamp
; GFX8-NEXT:    v_sub_u32_e64 v7, s[4:5], v7, v23 clamp
; GFX8-NEXT:    v_sub_u32_e64 v8, s[4:5], v8, v24 clamp
; GFX8-NEXT:    v_sub_u32_e64 v9, s[4:5], v9, v25 clamp
; GFX8-NEXT:    v_sub_u32_e64 v10, s[4:5], v10, v26 clamp
; GFX8-NEXT:    v_sub_u32_e64 v11, s[4:5], v11, v27 clamp
; GFX8-NEXT:    v_sub_u32_e64 v12, s[4:5], v12, v28 clamp
; GFX8-NEXT:    v_sub_u32_e64 v13, s[4:5], v13, v29 clamp
; GFX8-NEXT:    v_sub_u32_e64 v14, s[4:5], v14, v30 clamp
; GFX8-NEXT:    v_sub_u32_e64 v15, s[4:5], v15, v31 clamp
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_usubsat_v16i32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_sub_u32_e64 v0, v0, v16 clamp
; GFX9-NEXT:    v_sub_u32_e64 v1, v1, v17 clamp
; GFX9-NEXT:    v_sub_u32_e64 v2, v2, v18 clamp
; GFX9-NEXT:    v_sub_u32_e64 v3, v3, v19 clamp
; GFX9-NEXT:    v_sub_u32_e64 v4, v4, v20 clamp
; GFX9-NEXT:    v_sub_u32_e64 v5, v5, v21 clamp
; GFX9-NEXT:    v_sub_u32_e64 v6, v6, v22 clamp
; GFX9-NEXT:    v_sub_u32_e64 v7, v7, v23 clamp
; GFX9-NEXT:    v_sub_u32_e64 v8, v8, v24 clamp
; GFX9-NEXT:    v_sub_u32_e64 v9, v9, v25 clamp
; GFX9-NEXT:    v_sub_u32_e64 v10, v10, v26 clamp
; GFX9-NEXT:    v_sub_u32_e64 v11, v11, v27 clamp
; GFX9-NEXT:    v_sub_u32_e64 v12, v12, v28 clamp
; GFX9-NEXT:    v_sub_u32_e64 v13, v13, v29 clamp
; GFX9-NEXT:    v_sub_u32_e64 v14, v14, v30 clamp
; GFX9-NEXT:    v_sub_u32_e64 v15, v15, v31 clamp
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %result = call <16 x i32> @llvm.usub.sat.v16i32(<16 x i32> %lhs, <16 x i32> %rhs)
  ret <16 x i32> %result
}


define i64 @v_usubsat_i64(i64 %lhs, i64 %rhs) {
; GFX6-LABEL: v_usubsat_i64:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_sub_i32_e32 v2, vcc, v0, v2
; GFX6-NEXT:    v_subb_u32_e32 v3, vcc, v1, v3, vcc
; GFX6-NEXT:    v_cmp_gt_u64_e32 vcc, v[2:3], v[0:1]
; GFX6-NEXT:    v_cndmask_b32_e64 v0, v2, 0, vcc
; GFX6-NEXT:    v_cndmask_b32_e64 v1, v3, 0, vcc
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_usubsat_i64:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_sub_u32_e32 v2, vcc, v0, v2
; GFX8-NEXT:    v_subb_u32_e32 v3, vcc, v1, v3, vcc
; GFX8-NEXT:    v_cmp_gt_u64_e32 vcc, v[2:3], v[0:1]
; GFX8-NEXT:    v_cndmask_b32_e64 v0, v2, 0, vcc
; GFX8-NEXT:    v_cndmask_b32_e64 v1, v3, 0, vcc
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_usubsat_i64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_sub_co_u32_e32 v2, vcc, v0, v2
; GFX9-NEXT:    v_subb_co_u32_e32 v3, vcc, v1, v3, vcc
; GFX9-NEXT:    v_cmp_gt_u64_e32 vcc, v[2:3], v[0:1]
; GFX9-NEXT:    v_cndmask_b32_e64 v0, v2, 0, vcc
; GFX9-NEXT:    v_cndmask_b32_e64 v1, v3, 0, vcc
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %result = call i64 @llvm.usub.sat.i64(i64 %lhs, i64 %rhs)
  ret i64 %result
}

declare i8 @llvm.usub.sat.i8(i8, i8) #0
declare i16 @llvm.usub.sat.i16(i16, i16) #0
declare <2 x i16> @llvm.usub.sat.v2i16(<2 x i16>, <2 x i16>) #0
declare <3 x i16> @llvm.usub.sat.v3i16(<3 x i16>, <3 x i16>) #0
declare <4 x i16> @llvm.usub.sat.v4i16(<4 x i16>, <4 x i16>) #0
declare i32 @llvm.usub.sat.i32(i32, i32) #0
declare <2 x i32> @llvm.usub.sat.v2i32(<2 x i32>, <2 x i32>) #0
declare <3 x i32> @llvm.usub.sat.v3i32(<3 x i32>, <3 x i32>) #0
declare <4 x i32> @llvm.usub.sat.v4i32(<4 x i32>, <4 x i32>) #0
declare <8 x i32> @llvm.usub.sat.v8i32(<8 x i32>, <8 x i32>) #0
declare <16 x i32> @llvm.usub.sat.v16i32(<16 x i32>, <16 x i32>) #0
declare i64 @llvm.usub.sat.i64(i64, i64) #0

attributes #0 = { nounwind readnone speculatable willreturn }
