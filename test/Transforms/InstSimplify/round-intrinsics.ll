; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instsimplify %s | FileCheck %s

define float @sitofp_floor(i32 %arg) {
; CHECK-LABEL: @sitofp_floor(
; CHECK-NEXT:    [[CVT:%.*]] = sitofp i32 [[ARG:%.*]] to float
; CHECK-NEXT:    [[ROUND:%.*]] = call float @llvm.floor.f32(float [[CVT]])
; CHECK-NEXT:    ret float [[ROUND]]
;
  %cvt = sitofp i32 %arg to float
  %round = call float @llvm.floor.f32(float %cvt)
  ret float %round
}

define float @uitofp_floor(i32 %arg) {
; CHECK-LABEL: @uitofp_floor(
; CHECK-NEXT:    [[CVT:%.*]] = uitofp i32 [[ARG:%.*]] to float
; CHECK-NEXT:    [[ROUND:%.*]] = call float @llvm.floor.f32(float [[CVT]])
; CHECK-NEXT:    ret float [[ROUND]]
;
  %cvt = uitofp i32 %arg to float
  %round = call float @llvm.floor.f32(float %cvt)
  ret float %round
}

define float @sitofp_trunc(i32 %arg) {
; CHECK-LABEL: @sitofp_trunc(
; CHECK-NEXT:    [[CVT:%.*]] = sitofp i32 [[ARG:%.*]] to float
; CHECK-NEXT:    [[ROUND:%.*]] = call float @llvm.trunc.f32(float [[CVT]])
; CHECK-NEXT:    ret float [[ROUND]]
;
  %cvt = sitofp i32 %arg to float
  %round = call float @llvm.trunc.f32(float %cvt)
  ret float %round
}

define float @uitofp_trunc(i32 %arg) {
; CHECK-LABEL: @uitofp_trunc(
; CHECK-NEXT:    [[CVT:%.*]] = uitofp i32 [[ARG:%.*]] to float
; CHECK-NEXT:    [[ROUND:%.*]] = call float @llvm.trunc.f32(float [[CVT]])
; CHECK-NEXT:    ret float [[ROUND]]
;
  %cvt = uitofp i32 %arg to float
  %round = call float @llvm.trunc.f32(float %cvt)
  ret float %round
}

define float @sitofp_round(i32 %arg) {
; CHECK-LABEL: @sitofp_round(
; CHECK-NEXT:    [[CVT:%.*]] = sitofp i32 [[ARG:%.*]] to float
; CHECK-NEXT:    [[ROUND:%.*]] = call float @llvm.round.f32(float [[CVT]])
; CHECK-NEXT:    ret float [[ROUND]]
;
  %cvt = sitofp i32 %arg to float
  %round = call float @llvm.round.f32(float %cvt)
  ret float %round
}

define float @uitofp_round(i32 %arg) {
; CHECK-LABEL: @uitofp_round(
; CHECK-NEXT:    [[CVT:%.*]] = uitofp i32 [[ARG:%.*]] to float
; CHECK-NEXT:    [[ROUND:%.*]] = call float @llvm.round.f32(float [[CVT]])
; CHECK-NEXT:    ret float [[ROUND]]
;
  %cvt = uitofp i32 %arg to float
  %round = call float @llvm.round.f32(float %cvt)
  ret float %round
}

define float @sitofp_nearbyint(i32 %arg) {
; CHECK-LABEL: @sitofp_nearbyint(
; CHECK-NEXT:    [[CVT:%.*]] = sitofp i32 [[ARG:%.*]] to float
; CHECK-NEXT:    [[NEARBYINT:%.*]] = call float @llvm.nearbyint.f32(float [[CVT]])
; CHECK-NEXT:    ret float [[NEARBYINT]]
;
  %cvt = sitofp i32 %arg to float
  %nearbyint = call float @llvm.nearbyint.f32(float %cvt)
  ret float %nearbyint
}

define float @uitofp_nearbyint(i32 %arg) {
; CHECK-LABEL: @uitofp_nearbyint(
; CHECK-NEXT:    [[CVT:%.*]] = uitofp i32 [[ARG:%.*]] to float
; CHECK-NEXT:    [[NEARBYINT:%.*]] = call float @llvm.nearbyint.f32(float [[CVT]])
; CHECK-NEXT:    ret float [[NEARBYINT]]
;
  %cvt = uitofp i32 %arg to float
  %nearbyint = call float @llvm.nearbyint.f32(float %cvt)
  ret float %nearbyint
}

define float @sitofp_rint(i32 %arg) {
; CHECK-LABEL: @sitofp_rint(
; CHECK-NEXT:    [[CVT:%.*]] = sitofp i32 [[ARG:%.*]] to float
; CHECK-NEXT:    [[RINT:%.*]] = call float @llvm.rint.f32(float [[CVT]])
; CHECK-NEXT:    ret float [[RINT]]
;
  %cvt = sitofp i32 %arg to float
  %rint = call float @llvm.rint.f32(float %cvt)
  ret float %rint
}

define float @uitofp_rint(i32 %arg) {
; CHECK-LABEL: @uitofp_rint(
; CHECK-NEXT:    [[CVT:%.*]] = uitofp i32 [[ARG:%.*]] to float
; CHECK-NEXT:    [[RINT:%.*]] = call float @llvm.rint.f32(float [[CVT]])
; CHECK-NEXT:    ret float [[RINT]]
;
  %cvt = uitofp i32 %arg to float
  %rint = call float @llvm.rint.f32(float %cvt)
  ret float %rint
}

declare float @llvm.floor.f32(float) #0
declare float @llvm.trunc.f32(float) #0
declare float @llvm.round.f32(float) #0
declare float @llvm.nearbyint.f32(float) #0
declare float @llvm.rint.f32(float) #0

attributes #0 = { nounwind readnone speculatable }
