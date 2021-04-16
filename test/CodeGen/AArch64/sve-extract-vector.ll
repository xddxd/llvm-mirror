; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s --check-prefixes=CHECK

; Should codegen to a nop, since idx is zero.
define <2 x i64> @extract_v2i64_nxv2i64(<vscale x 2 x i64> %vec) nounwind {
; CHECK-LABEL: extract_v2i64_nxv2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %retval = call <2 x i64> @llvm.experimental.vector.extract.v2i64.nxv2i64(<vscale x 2 x i64> %vec, i64 0)
  ret <2 x i64> %retval
}

; Goes through memory currently; idx != 0.
define <2 x i64> @extract_v2i64_nxv2i64_idx1(<vscale x 2 x i64> %vec) nounwind {
; CHECK-LABEL: extract_v2i64_nxv2i64_idx1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    st1d { z0.d }, p0, [sp]
; CHECK-NEXT:    ldur q0, [sp, #8]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
%retval = call <2 x i64> @llvm.experimental.vector.extract.v2i64.nxv2i64(<vscale x 2 x i64> %vec, i64 1)
ret <2 x i64> %retval
}

; Should codegen to a nop, since idx is zero.
define <4 x i32> @extract_v4i32_nxv4i32(<vscale x 4 x i32> %vec) nounwind {
; CHECK-LABEL: extract_v4i32_nxv4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
%retval = call <4 x i32> @llvm.experimental.vector.extract.v4i32.nxv4i32(<vscale x 4 x i32> %vec, i64 0)
ret <4 x i32> %retval
}

; Goes through memory currently; idx != 0.
define <4 x i32> @extract_v4i32_nxv4i32_idx1(<vscale x 4 x i32> %vec) nounwind {
; CHECK-LABEL: extract_v4i32_nxv4i32_idx1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    st1w { z0.s }, p0, [sp]
; CHECK-NEXT:    ldur q0, [sp, #4]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <4 x i32> @llvm.experimental.vector.extract.v4i32.nxv4i32(<vscale x 4 x i32> %vec, i64 1)
  ret <4 x i32> %retval
}

; Should codegen to a nop, since idx is zero.
define <8 x i16> @extract_v8i16_nxv8i16(<vscale x 8 x i16> %vec) nounwind {
; CHECK-LABEL: extract_v8i16_nxv8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %retval = call <8 x i16> @llvm.experimental.vector.extract.v8i16.nxv8i16(<vscale x 8 x i16> %vec, i64 0)
  ret <8 x i16> %retval
}

; Goes through memory currently; idx != 0.
define <8 x i16> @extract_v8i16_nxv8i16_idx1(<vscale x 8 x i16> %vec) nounwind {
; CHECK-LABEL: extract_v8i16_nxv8i16_idx1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    st1h { z0.h }, p0, [sp]
; CHECK-NEXT:    ldur q0, [sp, #2]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <8 x i16> @llvm.experimental.vector.extract.v8i16.nxv8i16(<vscale x 8 x i16> %vec, i64 1)
  ret <8 x i16> %retval
}

; Should codegen to a nop, since idx is zero.
define <16 x i8> @extract_v16i8_nxv16i8(<vscale x 16 x i8> %vec) nounwind {
; CHECK-LABEL: extract_v16i8_nxv16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %retval = call <16 x i8> @llvm.experimental.vector.extract.v16i8.nxv16i8(<vscale x 16 x i8> %vec, i64 0)
  ret <16 x i8> %retval
}

; Goes through memory currently; idx != 0.
define <16 x i8> @extract_v16i8_nxv16i8_idx1(<vscale x 16 x i8> %vec) nounwind {
; CHECK-LABEL: extract_v16i8_nxv16i8_idx1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    st1b { z0.b }, p0, [sp]
; CHECK-NEXT:    ldur q0, [sp, #1]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <16 x i8> @llvm.experimental.vector.extract.v16i8.nxv16i8(<vscale x 16 x i8> %vec, i64 1)
  ret <16 x i8> %retval
}

declare <2 x i64> @llvm.experimental.vector.extract.v2i64.nxv2i64(<vscale x 2 x i64>, i64)
declare <4 x i32> @llvm.experimental.vector.extract.v4i32.nxv4i32(<vscale x 4 x i32>, i64)
declare <8 x i16> @llvm.experimental.vector.extract.v8i16.nxv8i16(<vscale x 8 x i16>, i64)
declare <16 x i8> @llvm.experimental.vector.extract.v16i8.nxv16i8(<vscale x 16 x i8>, i64)
