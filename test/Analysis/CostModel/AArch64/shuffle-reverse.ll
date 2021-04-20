; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=aarch64--linux-gnu -cost-model -analyze | FileCheck %s

;
; Verify the cost model for reverse shuffles.
;

define void @test_vXi32(<2 x i32> %src64, <4 x i32> %src128) {
; CHECK-LABEL: 'test_vXi32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V64 = shufflevector <2 x i32> %src64, <2 x i32> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V128 = shufflevector <4 x i32> %src128, <4 x i32> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %V64 = shufflevector <2 x i32> %src64, <2 x i32> undef, <2 x i32> <i32 1, i32 0>
  %V128 = shufflevector <4 x i32> %src128, <4 x i32> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  ret void
}

define void @test_vXi64(<2 x i64> %src128) {
; CHECK-LABEL: 'test_vXi64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V128 = shufflevector <2 x i64> %src128, <2 x i64> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %V128 = shufflevector <2 x i64> %src128, <2 x i64> undef, <2 x i32> <i32 1, i32 0>
  ret void
}

define void @test_vXf32(<2 x float> %src64, <4 x float> %src128) {
; CHECK-LABEL: 'test_vXf32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V64 = shufflevector <2 x float> %src64, <2 x float> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V128 = shufflevector <4 x float> %src128, <4 x float> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %V64 = shufflevector <2 x float> %src64, <2 x float> undef, <2 x i32> <i32 1, i32 0>
  %V128 = shufflevector <4 x float> %src128, <4 x float> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  ret void
}

define void @test_vXf64(<2 x double> %src128) {
; CHECK-LABEL: 'test_vXf64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V128 = shufflevector <2 x double> %src128, <2 x double> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %V128 = shufflevector <2 x double> %src128, <2 x double> undef, <2 x i32> <i32 1, i32 0>
  ret void
}

;
; Tests the cost model for reverse shuffles of second operand.
;

define void @test_upper_vXf32(<2 x float> %a64, <2 x float> %b64, <4 x float> %a128, <4 x float> %b128) {
; CHECK-LABEL: 'test_upper_vXf32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V64 = shufflevector <2 x float> %a64, <2 x float> %b64, <2 x i32> <i32 3, i32 2>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V128 = shufflevector <4 x float> %a128, <4 x float> %b128, <4 x i32> <i32 7, i32 6, i32 5, i32 4>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %V64 = shufflevector <2 x float> %a64, <2 x float> %b64, <2 x i32> <i32 3, i32 2>
  %V128 = shufflevector <4 x float> %a128, <4 x float> %b128, <4 x i32> <i32 7, i32 6, i32 5, i32 4>
  ret void
}
