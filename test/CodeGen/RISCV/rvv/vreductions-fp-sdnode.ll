; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+experimental-zfh,+experimental-v -target-abi=ilp32d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s --check-prefix=RV32
; RUN: llc -mtriple=riscv64 -mattr=+d,+experimental-zfh,+experimental-v -target-abi=lp64d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s --check-prefix=RV64

declare half @llvm.vector.reduce.fadd.nxv1f16(half, <vscale x 1 x half>)

define half @vreduce_fadd_nxv1f16(<vscale x 1 x half> %v, half %s) {
; RV32-LABEL: vreduce_fadd_nxv1f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; RV32-NEXT:    vfredsum.vs v25, v8, v25
; RV32-NEXT:    vsetvli zero, zero, e16,m1,ta,mu
; RV32-NEXT:    vfmv.f.s ft0, v25
; RV32-NEXT:    fadd.h fa0, fa0, ft0
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_fadd_nxv1f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; RV64-NEXT:    vfredsum.vs v25, v8, v25
; RV64-NEXT:    vsetvli zero, zero, e16,m1,ta,mu
; RV64-NEXT:    vfmv.f.s ft0, v25
; RV64-NEXT:    fadd.h fa0, fa0, ft0
; RV64-NEXT:    ret
  %red = call reassoc half @llvm.vector.reduce.fadd.nxv1f16(half %s, <vscale x 1 x half> %v)
  ret half %red
}

define half @vreduce_ord_fadd_nxv1f16(<vscale x 1 x half> %v, half %s) {
; RV32-LABEL: vreduce_ord_fadd_nxv1f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; RV32-NEXT:    vfmv.v.f v25, fa0
; RV32-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; RV32-NEXT:    vfredosum.vs v25, v8, v25
; RV32-NEXT:    vsetvli zero, zero, e16,m1,ta,mu
; RV32-NEXT:    vfmv.f.s fa0, v25
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_ord_fadd_nxv1f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; RV64-NEXT:    vfmv.v.f v25, fa0
; RV64-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; RV64-NEXT:    vfredosum.vs v25, v8, v25
; RV64-NEXT:    vsetvli zero, zero, e16,m1,ta,mu
; RV64-NEXT:    vfmv.f.s fa0, v25
; RV64-NEXT:    ret
  %red = call half @llvm.vector.reduce.fadd.nxv1f16(half %s, <vscale x 1 x half> %v)
  ret half %red
}

declare half @llvm.vector.reduce.fadd.nxv2f16(half, <vscale x 2 x half>)

define half @vreduce_fadd_nxv2f16(<vscale x 2 x half> %v, half %s) {
; RV32-LABEL: vreduce_fadd_nxv2f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; RV32-NEXT:    vfredsum.vs v25, v8, v25
; RV32-NEXT:    vsetvli zero, zero, e16,m1,ta,mu
; RV32-NEXT:    vfmv.f.s ft0, v25
; RV32-NEXT:    fadd.h fa0, fa0, ft0
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_fadd_nxv2f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; RV64-NEXT:    vfredsum.vs v25, v8, v25
; RV64-NEXT:    vsetvli zero, zero, e16,m1,ta,mu
; RV64-NEXT:    vfmv.f.s ft0, v25
; RV64-NEXT:    fadd.h fa0, fa0, ft0
; RV64-NEXT:    ret
  %red = call reassoc half @llvm.vector.reduce.fadd.nxv2f16(half %s, <vscale x 2 x half> %v)
  ret half %red
}

define half @vreduce_ord_fadd_nxv2f16(<vscale x 2 x half> %v, half %s) {
; RV32-LABEL: vreduce_ord_fadd_nxv2f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; RV32-NEXT:    vfmv.v.f v25, fa0
; RV32-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; RV32-NEXT:    vfredosum.vs v25, v8, v25
; RV32-NEXT:    vsetvli zero, zero, e16,m1,ta,mu
; RV32-NEXT:    vfmv.f.s fa0, v25
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_ord_fadd_nxv2f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; RV64-NEXT:    vfmv.v.f v25, fa0
; RV64-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; RV64-NEXT:    vfredosum.vs v25, v8, v25
; RV64-NEXT:    vsetvli zero, zero, e16,m1,ta,mu
; RV64-NEXT:    vfmv.f.s fa0, v25
; RV64-NEXT:    ret
  %red = call half @llvm.vector.reduce.fadd.nxv2f16(half %s, <vscale x 2 x half> %v)
  ret half %red
}

declare half @llvm.vector.reduce.fadd.nxv4f16(half, <vscale x 4 x half>)

define half @vreduce_fadd_nxv4f16(<vscale x 4 x half> %v, half %s) {
; RV32-LABEL: vreduce_fadd_nxv4f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vfredsum.vs v25, v8, v25
; RV32-NEXT:    vfmv.f.s ft0, v25
; RV32-NEXT:    fadd.h fa0, fa0, ft0
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_fadd_nxv4f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vfredsum.vs v25, v8, v25
; RV64-NEXT:    vfmv.f.s ft0, v25
; RV64-NEXT:    fadd.h fa0, fa0, ft0
; RV64-NEXT:    ret
  %red = call reassoc half @llvm.vector.reduce.fadd.nxv4f16(half %s, <vscale x 4 x half> %v)
  ret half %red
}

define half @vreduce_ord_fadd_nxv4f16(<vscale x 4 x half> %v, half %s) {
; RV32-LABEL: vreduce_ord_fadd_nxv4f16:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; RV32-NEXT:    vfmv.v.f v25, fa0
; RV32-NEXT:    vfredosum.vs v25, v8, v25
; RV32-NEXT:    vfmv.f.s fa0, v25
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_ord_fadd_nxv4f16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; RV64-NEXT:    vfmv.v.f v25, fa0
; RV64-NEXT:    vfredosum.vs v25, v8, v25
; RV64-NEXT:    vfmv.f.s fa0, v25
; RV64-NEXT:    ret
  %red = call half @llvm.vector.reduce.fadd.nxv4f16(half %s, <vscale x 4 x half> %v)
  ret half %red
}

declare float @llvm.vector.reduce.fadd.nxv1f32(float, <vscale x 1 x float>)

define float @vreduce_fadd_nxv1f32(<vscale x 1 x float> %v, float %s) {
; RV32-LABEL: vreduce_fadd_nxv1f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; RV32-NEXT:    vfredsum.vs v25, v8, v25
; RV32-NEXT:    vsetvli zero, zero, e32,m1,ta,mu
; RV32-NEXT:    vfmv.f.s ft0, v25
; RV32-NEXT:    fadd.s fa0, fa0, ft0
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_fadd_nxv1f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; RV64-NEXT:    vfredsum.vs v25, v8, v25
; RV64-NEXT:    vsetvli zero, zero, e32,m1,ta,mu
; RV64-NEXT:    vfmv.f.s ft0, v25
; RV64-NEXT:    fadd.s fa0, fa0, ft0
; RV64-NEXT:    ret
  %red = call reassoc float @llvm.vector.reduce.fadd.nxv1f32(float %s, <vscale x 1 x float> %v)
  ret float %red
}

define float @vreduce_ord_fadd_nxv1f32(<vscale x 1 x float> %v, float %s) {
; RV32-LABEL: vreduce_ord_fadd_nxv1f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; RV32-NEXT:    vfmv.v.f v25, fa0
; RV32-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; RV32-NEXT:    vfredosum.vs v25, v8, v25
; RV32-NEXT:    vsetvli zero, zero, e32,m1,ta,mu
; RV32-NEXT:    vfmv.f.s fa0, v25
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_ord_fadd_nxv1f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; RV64-NEXT:    vfmv.v.f v25, fa0
; RV64-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; RV64-NEXT:    vfredosum.vs v25, v8, v25
; RV64-NEXT:    vsetvli zero, zero, e32,m1,ta,mu
; RV64-NEXT:    vfmv.f.s fa0, v25
; RV64-NEXT:    ret
  %red = call float @llvm.vector.reduce.fadd.nxv1f32(float %s, <vscale x 1 x float> %v)
  ret float %red
}

declare float @llvm.vector.reduce.fadd.nxv2f32(float, <vscale x 2 x float>)

define float @vreduce_fadd_nxv2f32(<vscale x 2 x float> %v, float %s) {
; RV32-LABEL: vreduce_fadd_nxv2f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vfredsum.vs v25, v8, v25
; RV32-NEXT:    vfmv.f.s ft0, v25
; RV32-NEXT:    fadd.s fa0, fa0, ft0
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_fadd_nxv2f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vfredsum.vs v25, v8, v25
; RV64-NEXT:    vfmv.f.s ft0, v25
; RV64-NEXT:    fadd.s fa0, fa0, ft0
; RV64-NEXT:    ret
  %red = call reassoc float @llvm.vector.reduce.fadd.nxv2f32(float %s, <vscale x 2 x float> %v)
  ret float %red
}

define float @vreduce_ord_fadd_nxv2f32(<vscale x 2 x float> %v, float %s) {
; RV32-LABEL: vreduce_ord_fadd_nxv2f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; RV32-NEXT:    vfmv.v.f v25, fa0
; RV32-NEXT:    vfredosum.vs v25, v8, v25
; RV32-NEXT:    vfmv.f.s fa0, v25
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_ord_fadd_nxv2f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; RV64-NEXT:    vfmv.v.f v25, fa0
; RV64-NEXT:    vfredosum.vs v25, v8, v25
; RV64-NEXT:    vfmv.f.s fa0, v25
; RV64-NEXT:    ret
  %red = call float @llvm.vector.reduce.fadd.nxv2f32(float %s, <vscale x 2 x float> %v)
  ret float %red
}

declare float @llvm.vector.reduce.fadd.nxv4f32(float, <vscale x 4 x float>)

define float @vreduce_fadd_nxv4f32(<vscale x 4 x float> %v, float %s) {
; RV32-LABEL: vreduce_fadd_nxv4f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; RV32-NEXT:    vfredsum.vs v25, v8, v25
; RV32-NEXT:    vsetvli zero, zero, e32,m1,ta,mu
; RV32-NEXT:    vfmv.f.s ft0, v25
; RV32-NEXT:    fadd.s fa0, fa0, ft0
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_fadd_nxv4f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; RV64-NEXT:    vfredsum.vs v25, v8, v25
; RV64-NEXT:    vsetvli zero, zero, e32,m1,ta,mu
; RV64-NEXT:    vfmv.f.s ft0, v25
; RV64-NEXT:    fadd.s fa0, fa0, ft0
; RV64-NEXT:    ret
  %red = call reassoc float @llvm.vector.reduce.fadd.nxv4f32(float %s, <vscale x 4 x float> %v)
  ret float %red
}

define float @vreduce_ord_fadd_nxv4f32(<vscale x 4 x float> %v, float %s) {
; RV32-LABEL: vreduce_ord_fadd_nxv4f32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; RV32-NEXT:    vfmv.v.f v25, fa0
; RV32-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; RV32-NEXT:    vfredosum.vs v25, v8, v25
; RV32-NEXT:    vsetvli zero, zero, e32,m1,ta,mu
; RV32-NEXT:    vfmv.f.s fa0, v25
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_ord_fadd_nxv4f32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; RV64-NEXT:    vfmv.v.f v25, fa0
; RV64-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; RV64-NEXT:    vfredosum.vs v25, v8, v25
; RV64-NEXT:    vsetvli zero, zero, e32,m1,ta,mu
; RV64-NEXT:    vfmv.f.s fa0, v25
; RV64-NEXT:    ret
  %red = call float @llvm.vector.reduce.fadd.nxv4f32(float %s, <vscale x 4 x float> %v)
  ret float %red
}

declare double @llvm.vector.reduce.fadd.nxv1f64(double, <vscale x 1 x double>)

define double @vreduce_fadd_nxv1f64(<vscale x 1 x double> %v, double %s) {
; RV32-LABEL: vreduce_fadd_nxv1f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vfredsum.vs v25, v8, v25
; RV32-NEXT:    vfmv.f.s ft0, v25
; RV32-NEXT:    fadd.d fa0, fa0, ft0
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_fadd_nxv1f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vfredsum.vs v25, v8, v25
; RV64-NEXT:    vfmv.f.s ft0, v25
; RV64-NEXT:    fadd.d fa0, fa0, ft0
; RV64-NEXT:    ret
  %red = call reassoc double @llvm.vector.reduce.fadd.nxv1f64(double %s, <vscale x 1 x double> %v)
  ret double %red
}

define double @vreduce_ord_fadd_nxv1f64(<vscale x 1 x double> %v, double %s) {
; RV32-LABEL: vreduce_ord_fadd_nxv1f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; RV32-NEXT:    vfmv.v.f v25, fa0
; RV32-NEXT:    vfredosum.vs v25, v8, v25
; RV32-NEXT:    vfmv.f.s fa0, v25
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_ord_fadd_nxv1f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; RV64-NEXT:    vfmv.v.f v25, fa0
; RV64-NEXT:    vfredosum.vs v25, v8, v25
; RV64-NEXT:    vfmv.f.s fa0, v25
; RV64-NEXT:    ret
  %red = call double @llvm.vector.reduce.fadd.nxv1f64(double %s, <vscale x 1 x double> %v)
  ret double %red
}

declare double @llvm.vector.reduce.fadd.nxv2f64(double, <vscale x 2 x double>)

define double @vreduce_fadd_nxv2f64(<vscale x 2 x double> %v, double %s) {
; RV32-LABEL: vreduce_fadd_nxv2f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vsetvli a0, zero, e64,m2,ta,mu
; RV32-NEXT:    vfredsum.vs v25, v8, v25
; RV32-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV32-NEXT:    vfmv.f.s ft0, v25
; RV32-NEXT:    fadd.d fa0, fa0, ft0
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_fadd_nxv2f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vsetvli a0, zero, e64,m2,ta,mu
; RV64-NEXT:    vfredsum.vs v25, v8, v25
; RV64-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV64-NEXT:    vfmv.f.s ft0, v25
; RV64-NEXT:    fadd.d fa0, fa0, ft0
; RV64-NEXT:    ret
  %red = call reassoc double @llvm.vector.reduce.fadd.nxv2f64(double %s, <vscale x 2 x double> %v)
  ret double %red
}

define double @vreduce_ord_fadd_nxv2f64(<vscale x 2 x double> %v, double %s) {
; RV32-LABEL: vreduce_ord_fadd_nxv2f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; RV32-NEXT:    vfmv.v.f v25, fa0
; RV32-NEXT:    vsetvli a0, zero, e64,m2,ta,mu
; RV32-NEXT:    vfredosum.vs v25, v8, v25
; RV32-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV32-NEXT:    vfmv.f.s fa0, v25
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_ord_fadd_nxv2f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; RV64-NEXT:    vfmv.v.f v25, fa0
; RV64-NEXT:    vsetvli a0, zero, e64,m2,ta,mu
; RV64-NEXT:    vfredosum.vs v25, v8, v25
; RV64-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV64-NEXT:    vfmv.f.s fa0, v25
; RV64-NEXT:    ret
  %red = call double @llvm.vector.reduce.fadd.nxv2f64(double %s, <vscale x 2 x double> %v)
  ret double %red
}

declare double @llvm.vector.reduce.fadd.nxv4f64(double, <vscale x 4 x double>)

define double @vreduce_fadd_nxv4f64(<vscale x 4 x double> %v, double %s) {
; RV32-LABEL: vreduce_fadd_nxv4f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; RV32-NEXT:    vmv.v.i v25, 0
; RV32-NEXT:    vsetvli a0, zero, e64,m4,ta,mu
; RV32-NEXT:    vfredsum.vs v25, v8, v25
; RV32-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV32-NEXT:    vfmv.f.s ft0, v25
; RV32-NEXT:    fadd.d fa0, fa0, ft0
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_fadd_nxv4f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; RV64-NEXT:    vmv.v.i v25, 0
; RV64-NEXT:    vsetvli a0, zero, e64,m4,ta,mu
; RV64-NEXT:    vfredsum.vs v25, v8, v25
; RV64-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV64-NEXT:    vfmv.f.s ft0, v25
; RV64-NEXT:    fadd.d fa0, fa0, ft0
; RV64-NEXT:    ret
  %red = call reassoc double @llvm.vector.reduce.fadd.nxv4f64(double %s, <vscale x 4 x double> %v)
  ret double %red
}

define double @vreduce_ord_fadd_nxv4f64(<vscale x 4 x double> %v, double %s) {
; RV32-LABEL: vreduce_ord_fadd_nxv4f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; RV32-NEXT:    vfmv.v.f v25, fa0
; RV32-NEXT:    vsetvli a0, zero, e64,m4,ta,mu
; RV32-NEXT:    vfredosum.vs v25, v8, v25
; RV32-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV32-NEXT:    vfmv.f.s fa0, v25
; RV32-NEXT:    ret
;
; RV64-LABEL: vreduce_ord_fadd_nxv4f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; RV64-NEXT:    vfmv.v.f v25, fa0
; RV64-NEXT:    vsetvli a0, zero, e64,m4,ta,mu
; RV64-NEXT:    vfredosum.vs v25, v8, v25
; RV64-NEXT:    vsetvli zero, zero, e64,m1,ta,mu
; RV64-NEXT:    vfmv.f.s fa0, v25
; RV64-NEXT:    ret
  %red = call double @llvm.vector.reduce.fadd.nxv4f64(double %s, <vscale x 4 x double> %v)
  ret double %red
}
