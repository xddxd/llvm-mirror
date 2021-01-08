; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin -mattr=+avx2 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx2 | FileCheck %s

;
; 128-bit Vectors
;

define <4 x float> @test_unpacklo_hadd_v4f32(<4 x float> %0, <4 x float> %1, <4 x float> %2, <4 x float> %3) {
; CHECK-LABEL: test_unpacklo_hadd_v4f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vhaddps %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,2,1,3]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <4 x float> @llvm.x86.sse3.hadd.ps(<4 x float> %0, <4 x float> %1) #4
  %6 = tail call <4 x float> @llvm.x86.sse3.hadd.ps(<4 x float> %2, <4 x float> %3) #4
  %7 = shufflevector <4 x float> %5, <4 x float> %6, <4 x i32> <i32 0, i32 4, i32 1, i32 5>
  ret <4 x float> %7
}

define <4 x float> @test_unpackhi_hadd_v4f32(<4 x float> %0, <4 x float> %1, <4 x float> %2, <4 x float> %3) {
; CHECK-LABEL: test_unpackhi_hadd_v4f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vhaddps %xmm3, %xmm1, %xmm0
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,2,1,3]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <4 x float> @llvm.x86.sse3.hadd.ps(<4 x float> %0, <4 x float> %1) #4
  %6 = tail call <4 x float> @llvm.x86.sse3.hadd.ps(<4 x float> %2, <4 x float> %3) #4
  %7 = shufflevector <4 x float> %5, <4 x float> %6, <4 x i32> <i32 2, i32 6, i32 3, i32 7>
  ret <4 x float> %7
}

define <4 x float> @test_unpacklo_hsub_v4f32(<4 x float> %0, <4 x float> %1, <4 x float> %2, <4 x float> %3) {
; CHECK-LABEL: test_unpacklo_hsub_v4f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vhsubps %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,2,1,3]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <4 x float> @llvm.x86.sse3.hsub.ps(<4 x float> %0, <4 x float> %1) #4
  %6 = tail call <4 x float> @llvm.x86.sse3.hsub.ps(<4 x float> %2, <4 x float> %3) #4
  %7 = shufflevector <4 x float> %5, <4 x float> %6, <4 x i32> <i32 0, i32 4, i32 1, i32 5>
  ret <4 x float> %7
}

define <4 x float> @test_unpackhi_hsub_v4f32(<4 x float> %0, <4 x float> %1, <4 x float> %2, <4 x float> %3) {
; CHECK-LABEL: test_unpackhi_hsub_v4f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vhsubps %xmm3, %xmm1, %xmm0
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,2,1,3]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <4 x float> @llvm.x86.sse3.hsub.ps(<4 x float> %0, <4 x float> %1) #4
  %6 = tail call <4 x float> @llvm.x86.sse3.hsub.ps(<4 x float> %2, <4 x float> %3) #4
  %7 = shufflevector <4 x float> %5, <4 x float> %6, <4 x i32> <i32 2, i32 6, i32 3, i32 7>
  ret <4 x float> %7
}

define <4 x i32> @test_unpacklo_hadd_v4i32(<4 x i32> %0, <4 x i32> %1, <4 x i32> %2, <4 x i32> %3) {
; CHECK-LABEL: test_unpacklo_hadd_v4i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vphaddd %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,1,3]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32> %0, <4 x i32> %1) #5
  %6 = tail call <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32> %2, <4 x i32> %3) #5
  %7 = shufflevector <4 x i32> %5, <4 x i32> %6, <4 x i32> <i32 0, i32 4, i32 1, i32 5>
  ret <4 x i32> %7
}

define <4 x i32> @test_unpackhi_hadd_v4i32(<4 x i32> %0, <4 x i32> %1, <4 x i32> %2, <4 x i32> %3) {
; CHECK-LABEL: test_unpackhi_hadd_v4i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vphaddd %xmm3, %xmm1, %xmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,1,3]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32> %0, <4 x i32> %1) #5
  %6 = tail call <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32> %2, <4 x i32> %3) #5
  %7 = shufflevector <4 x i32> %5, <4 x i32> %6, <4 x i32> <i32 2, i32 6, i32 3, i32 7>
  ret <4 x i32> %7
}

define <4 x i32> @test_unpacklo_hsub_v4i32(<4 x i32> %0, <4 x i32> %1, <4 x i32> %2, <4 x i32> %3) {
; CHECK-LABEL: test_unpacklo_hsub_v4i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vphsubd %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,1,3]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32> %0, <4 x i32> %1) #5
  %6 = tail call <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32> %2, <4 x i32> %3) #5
  %7 = shufflevector <4 x i32> %5, <4 x i32> %6, <4 x i32> <i32 0, i32 4, i32 1, i32 5>
  ret <4 x i32> %7
}

define <4 x i32> @test_unpackhi_hsub_v4i32(<4 x i32> %0, <4 x i32> %1, <4 x i32> %2, <4 x i32> %3) {
; CHECK-LABEL: test_unpackhi_hsub_v4i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vphsubd %xmm3, %xmm1, %xmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,1,3]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32> %0, <4 x i32> %1) #5
  %6 = tail call <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32> %2, <4 x i32> %3) #5
  %7 = shufflevector <4 x i32> %5, <4 x i32> %6, <4 x i32> <i32 2, i32 6, i32 3, i32 7>
  ret <4 x i32> %7
}

;
; 256-bit Vectors
;

define <8 x float> @test_unpacklo_hadd_v8f32(<8 x float> %0, <8 x float> %1, <8 x float> %2, <8 x float> %3) {
; CHECK-LABEL: test_unpacklo_hadd_v8f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vhaddps %ymm2, %ymm0, %ymm0
; CHECK-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[0,2,1,3,4,6,5,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <8 x float> @llvm.x86.avx.hadd.ps.256(<8 x float> %0, <8 x float> %1) #4
  %6 = tail call <8 x float> @llvm.x86.avx.hadd.ps.256(<8 x float> %2, <8 x float> %3) #4
  %7 = shufflevector <8 x float> %5, <8 x float> %6, <8 x i32> <i32 0, i32 8, i32 1, i32 9, i32 4, i32 12, i32 5, i32 13>
  ret <8 x float> %7
}

define <8 x float> @test_unpackhi_hadd_v8f32(<8 x float> %0, <8 x float> %1, <8 x float> %2, <8 x float> %3) {
; CHECK-LABEL: test_unpackhi_hadd_v8f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vhaddps %ymm3, %ymm1, %ymm0
; CHECK-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[0,2,1,3,4,6,5,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <8 x float> @llvm.x86.avx.hadd.ps.256(<8 x float> %0, <8 x float> %1) #4
  %6 = tail call <8 x float> @llvm.x86.avx.hadd.ps.256(<8 x float> %2, <8 x float> %3) #4
  %7 = shufflevector <8 x float> %5, <8 x float> %6, <8 x i32> <i32 2, i32 10, i32 3, i32 11, i32 6, i32 14, i32 7, i32 15>
  ret <8 x float> %7
}

define <8 x float> @test_unpacklo_hsub_v8f32(<8 x float> %0, <8 x float> %1, <8 x float> %2, <8 x float> %3) {
; CHECK-LABEL: test_unpacklo_hsub_v8f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vhsubps %ymm2, %ymm0, %ymm0
; CHECK-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[0,2,1,3,4,6,5,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <8 x float> @llvm.x86.avx.hsub.ps.256(<8 x float> %0, <8 x float> %1) #4
  %6 = tail call <8 x float> @llvm.x86.avx.hsub.ps.256(<8 x float> %2, <8 x float> %3) #4
  %7 = shufflevector <8 x float> %5, <8 x float> %6, <8 x i32> <i32 0, i32 8, i32 1, i32 9, i32 4, i32 12, i32 5, i32 13>
  ret <8 x float> %7
}

define <8 x float> @test_unpackhi_hsub_v8f32(<8 x float> %0, <8 x float> %1, <8 x float> %2, <8 x float> %3) {
; CHECK-LABEL: test_unpackhi_hsub_v8f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vhsubps %ymm3, %ymm1, %ymm0
; CHECK-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[0,2,1,3,4,6,5,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <8 x float> @llvm.x86.avx.hsub.ps.256(<8 x float> %0, <8 x float> %1) #4
  %6 = tail call <8 x float> @llvm.x86.avx.hsub.ps.256(<8 x float> %2, <8 x float> %3) #4
  %7 = shufflevector <8 x float> %5, <8 x float> %6, <8 x i32> <i32 2, i32 10, i32 3, i32 11, i32 6, i32 14, i32 7, i32 15>
  ret <8 x float> %7
}

define <8 x i32> @test_unpacklo_hadd_v8i32(<8 x i32> %0, <8 x i32> %1, <8 x i32> %2, <8 x i32> %3) {
; CHECK-LABEL: test_unpacklo_hadd_v8i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vphaddd %ymm2, %ymm0, %ymm0
; CHECK-NEXT:    vpshufd {{.*#+}} ymm0 = ymm0[0,2,1,3,4,6,5,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <8 x i32> @llvm.x86.avx2.phadd.d(<8 x i32> %0, <8 x i32> %1) #5
  %6 = tail call <8 x i32> @llvm.x86.avx2.phadd.d(<8 x i32> %2, <8 x i32> %3) #5
  %7 = shufflevector <8 x i32> %5, <8 x i32> %6, <8 x i32> <i32 0, i32 8, i32 1, i32 9, i32 4, i32 12, i32 5, i32 13>
  ret <8 x i32> %7
}

define <8 x i32> @test_unpackhi_hadd_v8i32(<8 x i32> %0, <8 x i32> %1, <8 x i32> %2, <8 x i32> %3) {
; CHECK-LABEL: test_unpackhi_hadd_v8i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vphaddd %ymm3, %ymm1, %ymm0
; CHECK-NEXT:    vpshufd {{.*#+}} ymm0 = ymm0[0,2,1,3,4,6,5,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <8 x i32> @llvm.x86.avx2.phadd.d(<8 x i32> %0, <8 x i32> %1) #5
  %6 = tail call <8 x i32> @llvm.x86.avx2.phadd.d(<8 x i32> %2, <8 x i32> %3) #5
  %7 = shufflevector <8 x i32> %5, <8 x i32> %6, <8 x i32> <i32 2, i32 10, i32 3, i32 11, i32 6, i32 14, i32 7, i32 15>
  ret <8 x i32> %7
}

define <8 x i32> @test_unpacklo_hsub_v8i32(<8 x i32> %0, <8 x i32> %1, <8 x i32> %2, <8 x i32> %3) {
; CHECK-LABEL: test_unpacklo_hsub_v8i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vphsubd %ymm2, %ymm0, %ymm0
; CHECK-NEXT:    vpshufd {{.*#+}} ymm0 = ymm0[0,2,1,3,4,6,5,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <8 x i32> @llvm.x86.avx2.phsub.d(<8 x i32> %0, <8 x i32> %1) #5
  %6 = tail call <8 x i32> @llvm.x86.avx2.phsub.d(<8 x i32> %2, <8 x i32> %3) #5
  %7 = shufflevector <8 x i32> %5, <8 x i32> %6, <8 x i32> <i32 0, i32 8, i32 1, i32 9, i32 4, i32 12, i32 5, i32 13>
  ret <8 x i32> %7
}

define <8 x i32> @test_unpackhi_hsub_v8i32(<8 x i32> %0, <8 x i32> %1, <8 x i32> %2, <8 x i32> %3) {
; CHECK-LABEL: test_unpackhi_hsub_v8i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vphsubd %ymm3, %ymm1, %ymm0
; CHECK-NEXT:    vpshufd {{.*#+}} ymm0 = ymm0[0,2,1,3,4,6,5,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %5 = tail call <8 x i32> @llvm.x86.avx2.phsub.d(<8 x i32> %0, <8 x i32> %1) #5
  %6 = tail call <8 x i32> @llvm.x86.avx2.phsub.d(<8 x i32> %2, <8 x i32> %3) #5
  %7 = shufflevector <8 x i32> %5, <8 x i32> %6, <8 x i32> <i32 2, i32 10, i32 3, i32 11, i32 6, i32 14, i32 7, i32 15>
  ret <8 x i32> %7
}

declare <4 x float> @llvm.x86.sse3.hadd.ps(<4 x float>, <4 x float>)
declare <4 x float> @llvm.x86.sse3.hsub.ps(<4 x float>, <4 x float>)
declare <2 x double> @llvm.x86.sse3.hadd.pd(<2 x double>, <2 x double>)
declare <2 x double> @llvm.x86.sse3.hsub.pd(<2 x double>, <2 x double>)

declare <8 x i16> @llvm.x86.ssse3.phadd.w.128(<8 x i16>, <8 x i16>)
declare <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32>, <4 x i32>)
declare <8 x i16> @llvm.x86.ssse3.phsub.w.128(<8 x i16>, <8 x i16>)
declare <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32>, <4 x i32>)

declare <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16>, <8 x i16>)
declare <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32>, <4 x i32>)
declare <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16>, <8 x i16>)
declare <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32>, <4 x i32>)

declare <8 x float> @llvm.x86.avx.hadd.ps.256(<8 x float>, <8 x float>)
declare <8 x float> @llvm.x86.avx.hsub.ps.256(<8 x float>, <8 x float>)
declare <4 x double> @llvm.x86.avx.hadd.pd.256(<4 x double>, <4 x double>)
declare <4 x double> @llvm.x86.avx.hsub.pd.256(<4 x double>, <4 x double>)

declare <16 x i16> @llvm.x86.avx2.phadd.w(<16 x i16>, <16 x i16>)
declare <8 x i32> @llvm.x86.avx2.phadd.d(<8 x i32>, <8 x i32>)
declare <16 x i16> @llvm.x86.avx2.phsub.w(<16 x i16>, <16 x i16>)
declare <8 x i32> @llvm.x86.avx2.phsub.d(<8 x i32>, <8 x i32>)

declare <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16>, <16 x i16>)
declare <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32>, <8 x i32>)
declare <32 x i8> @llvm.x86.avx2.packuswb(<16 x i16>, <16 x i16>)
declare <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32>, <8 x i32>)
