; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -lower-matrix-intrinsics -fuse-matrix-tile-size=2 -matrix-allow-contract -force-fuse-matrix -instcombine -verify-dom-info %s -S | FileCheck %s

; REQUIRES: aarch64-registered-target

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "aarch64-apple-ios"

define void @test(<6 x double> * %A, <6 x double> * %B, <9 x double>* %C, i1 %cond) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC_CAST195:%.*]] = bitcast <6 x double>* [[A:%.*]] to <3 x double>*
; CHECK-NEXT:    [[COL_LOAD196:%.*]] = load <3 x double>, <3 x double>* [[VEC_CAST195]], align 8
; CHECK-NEXT:    [[VEC_GEP197:%.*]] = getelementptr <6 x double>, <6 x double>* [[A]], i64 0, i64 3
; CHECK-NEXT:    [[VEC_CAST198:%.*]] = bitcast double* [[VEC_GEP197]] to <3 x double>*
; CHECK-NEXT:    [[COL_LOAD199:%.*]] = load <3 x double>, <3 x double>* [[VEC_CAST198]], align 8
; CHECK-NEXT:    [[VEC_CAST200:%.*]] = bitcast <6 x double>* [[B:%.*]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD201:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST200]], align 8
; CHECK-NEXT:    [[VEC_GEP202:%.*]] = getelementptr <6 x double>, <6 x double>* [[B]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST203:%.*]] = bitcast double* [[VEC_GEP202]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD204:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST203]], align 8
; CHECK-NEXT:    [[VEC_GEP205:%.*]] = getelementptr <6 x double>, <6 x double>* [[B]], i64 0, i64 4
; CHECK-NEXT:    [[VEC_CAST206:%.*]] = bitcast double* [[VEC_GEP205]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD207:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST206]], align 8
; CHECK-NEXT:    [[STORE_BEGIN:%.*]] = ptrtoint <9 x double>* [[C:%.*]] to i64
; CHECK-NEXT:    [[STORE_END:%.*]] = add nuw nsw i64 [[STORE_BEGIN]], 72
; CHECK-NEXT:    [[LOAD_BEGIN:%.*]] = ptrtoint <6 x double>* [[A]] to i64
; CHECK-NEXT:    [[TMP0:%.*]] = icmp ugt i64 [[STORE_END]], [[LOAD_BEGIN]]
; CHECK-NEXT:    br i1 [[TMP0]], label [[ALIAS_CONT:%.*]], label [[NO_ALIAS:%.*]]
; CHECK:       alias_cont:
; CHECK-NEXT:    [[LOAD_END:%.*]] = add nuw nsw i64 [[LOAD_BEGIN]], 48
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i64 [[LOAD_END]], [[STORE_BEGIN]]
; CHECK-NEXT:    br i1 [[TMP1]], label [[COPY:%.*]], label [[NO_ALIAS]]
; CHECK:       copy:
; CHECK-NEXT:    [[TMP2:%.*]] = alloca <6 x double>, align 64
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast <6 x double>* [[TMP2]] to i8*
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <6 x double>* [[A]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 64 dereferenceable(48) [[TMP3]], i8* noundef nonnull align 8 dereferenceable(48) [[TMP4]], i64 48, i1 false)
; CHECK-NEXT:    br label [[NO_ALIAS]]
; CHECK:       no_alias:
; CHECK-NEXT:    [[TMP5:%.*]] = phi <6 x double>* [ [[A]], [[ENTRY:%.*]] ], [ [[A]], [[ALIAS_CONT]] ], [ [[TMP2]], [[COPY]] ]
; CHECK-NEXT:    [[STORE_BEGIN4:%.*]] = ptrtoint <9 x double>* [[C]] to i64
; CHECK-NEXT:    [[STORE_END5:%.*]] = add nuw nsw i64 [[STORE_BEGIN4]], 72
; CHECK-NEXT:    [[LOAD_BEGIN6:%.*]] = ptrtoint <6 x double>* [[B]] to i64
; CHECK-NEXT:    [[TMP6:%.*]] = icmp ugt i64 [[STORE_END5]], [[LOAD_BEGIN6]]
; CHECK-NEXT:    br i1 [[TMP6]], label [[ALIAS_CONT1:%.*]], label [[NO_ALIAS3:%.*]]
; CHECK:       alias_cont1:
; CHECK-NEXT:    [[LOAD_END7:%.*]] = add nuw nsw i64 [[LOAD_BEGIN6]], 48
; CHECK-NEXT:    [[TMP7:%.*]] = icmp ugt i64 [[LOAD_END7]], [[STORE_BEGIN4]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[COPY2:%.*]], label [[NO_ALIAS3]]
; CHECK:       copy2:
; CHECK-NEXT:    [[TMP8:%.*]] = alloca <6 x double>, align 64
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast <6 x double>* [[TMP8]] to i8*
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast <6 x double>* [[B]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 64 dereferenceable(48) [[TMP9]], i8* noundef nonnull align 8 dereferenceable(48) [[TMP10]], i64 48, i1 false)
; CHECK-NEXT:    br label [[NO_ALIAS3]]
; CHECK:       no_alias3:
; CHECK-NEXT:    [[TMP11:%.*]] = phi <6 x double>* [ [[B]], [[NO_ALIAS]] ], [ [[B]], [[ALIAS_CONT1]] ], [ [[TMP8]], [[COPY2]] ]
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast <6 x double>* [[TMP5]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST]], align 8
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP5]], i64 0, i64 3
; CHECK-NEXT:    [[VEC_CAST8:%.*]] = bitcast double* [[VEC_GEP]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD9:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST8]], align 8
; CHECK-NEXT:    [[VEC_CAST11:%.*]] = bitcast <6 x double>* [[TMP11]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD12:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST11]], align 8
; CHECK-NEXT:    [[VEC_GEP13:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP11]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST14:%.*]] = bitcast double* [[VEC_GEP13]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD15:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST14]], align 8
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <2 x double> [[COL_LOAD12]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP12:%.*]] = fmul contract <2 x double> [[COL_LOAD]], [[SPLAT_SPLAT]]
; CHECK-NEXT:    [[SPLAT_SPLAT18:%.*]] = shufflevector <2 x double> [[COL_LOAD12]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP13:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD9]], <2 x double> [[SPLAT_SPLAT18]], <2 x double> [[TMP12]])
; CHECK-NEXT:    [[SPLAT_SPLAT21:%.*]] = shufflevector <2 x double> [[COL_LOAD15]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP14:%.*]] = fmul contract <2 x double> [[COL_LOAD]], [[SPLAT_SPLAT21]]
; CHECK-NEXT:    [[SPLAT_SPLAT24:%.*]] = shufflevector <2 x double> [[COL_LOAD15]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP15:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD9]], <2 x double> [[SPLAT_SPLAT24]], <2 x double> [[TMP14]])
; CHECK-NEXT:    [[VEC_CAST26:%.*]] = bitcast <9 x double>* [[C]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP13]], <2 x double>* [[VEC_CAST26]], align 8
; CHECK-NEXT:    [[VEC_GEP27:%.*]] = getelementptr <9 x double>, <9 x double>* [[C]], i64 0, i64 3
; CHECK-NEXT:    [[VEC_CAST28:%.*]] = bitcast double* [[VEC_GEP27]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP15]], <2 x double>* [[VEC_CAST28]], align 8
; CHECK-NEXT:    [[TMP16:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP5]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST30:%.*]] = bitcast double* [[TMP16]] to <1 x double>*
; CHECK-NEXT:    [[COL_LOAD31:%.*]] = load <1 x double>, <1 x double>* [[VEC_CAST30]], align 8
; CHECK-NEXT:    [[VEC_GEP32:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP5]], i64 0, i64 5
; CHECK-NEXT:    [[VEC_CAST33:%.*]] = bitcast double* [[VEC_GEP32]] to <1 x double>*
; CHECK-NEXT:    [[COL_LOAD34:%.*]] = load <1 x double>, <1 x double>* [[VEC_CAST33]], align 8
; CHECK-NEXT:    [[VEC_CAST36:%.*]] = bitcast <6 x double>* [[TMP11]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD37:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST36]], align 8
; CHECK-NEXT:    [[VEC_GEP38:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP11]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST39:%.*]] = bitcast double* [[VEC_GEP38]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD40:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST39]], align 8
; CHECK-NEXT:    [[SPLAT_SPLATINSERT42:%.*]] = shufflevector <2 x double> [[COL_LOAD37]], <2 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP17:%.*]] = fmul contract <1 x double> [[COL_LOAD31]], [[SPLAT_SPLATINSERT42]]
; CHECK-NEXT:    [[SPLAT_SPLATINSERT45:%.*]] = shufflevector <2 x double> [[COL_LOAD37]], <2 x double> undef, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP18:%.*]] = call contract <1 x double> @llvm.fmuladd.v1f64(<1 x double> [[COL_LOAD34]], <1 x double> [[SPLAT_SPLATINSERT45]], <1 x double> [[TMP17]])
; CHECK-NEXT:    [[SPLAT_SPLATINSERT48:%.*]] = shufflevector <2 x double> [[COL_LOAD40]], <2 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP19:%.*]] = fmul contract <1 x double> [[COL_LOAD31]], [[SPLAT_SPLATINSERT48]]
; CHECK-NEXT:    [[SPLAT_SPLATINSERT51:%.*]] = shufflevector <2 x double> [[COL_LOAD40]], <2 x double> undef, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP20:%.*]] = call contract <1 x double> @llvm.fmuladd.v1f64(<1 x double> [[COL_LOAD34]], <1 x double> [[SPLAT_SPLATINSERT51]], <1 x double> [[TMP19]])
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr <9 x double>, <9 x double>* [[C]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST54:%.*]] = bitcast double* [[TMP21]] to <1 x double>*
; CHECK-NEXT:    store <1 x double> [[TMP18]], <1 x double>* [[VEC_CAST54]], align 8
; CHECK-NEXT:    [[VEC_GEP55:%.*]] = getelementptr <9 x double>, <9 x double>* [[C]], i64 0, i64 5
; CHECK-NEXT:    [[VEC_CAST56:%.*]] = bitcast double* [[VEC_GEP55]] to <1 x double>*
; CHECK-NEXT:    store <1 x double> [[TMP20]], <1 x double>* [[VEC_CAST56]], align 8
; CHECK-NEXT:    [[VEC_CAST58:%.*]] = bitcast <6 x double>* [[TMP5]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD59:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST58]], align 8
; CHECK-NEXT:    [[VEC_GEP60:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP5]], i64 0, i64 3
; CHECK-NEXT:    [[VEC_CAST61:%.*]] = bitcast double* [[VEC_GEP60]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD62:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST61]], align 8
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP11]], i64 0, i64 4
; CHECK-NEXT:    [[VEC_CAST64:%.*]] = bitcast double* [[TMP22]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD65:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST64]], align 8
; CHECK-NEXT:    [[SPLAT_SPLAT68:%.*]] = shufflevector <2 x double> [[COL_LOAD65]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP23:%.*]] = fmul contract <2 x double> [[COL_LOAD59]], [[SPLAT_SPLAT68]]
; CHECK-NEXT:    [[SPLAT_SPLAT71:%.*]] = shufflevector <2 x double> [[COL_LOAD65]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP24:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD62]], <2 x double> [[SPLAT_SPLAT71]], <2 x double> [[TMP23]])
; CHECK-NEXT:    [[TMP25:%.*]] = getelementptr <9 x double>, <9 x double>* [[C]], i64 0, i64 6
; CHECK-NEXT:    [[VEC_CAST73:%.*]] = bitcast double* [[TMP25]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP24]], <2 x double>* [[VEC_CAST73]], align 8
; CHECK-NEXT:    [[TMP26:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP5]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST75:%.*]] = bitcast double* [[TMP26]] to <1 x double>*
; CHECK-NEXT:    [[COL_LOAD76:%.*]] = load <1 x double>, <1 x double>* [[VEC_CAST75]], align 8
; CHECK-NEXT:    [[VEC_GEP77:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP5]], i64 0, i64 5
; CHECK-NEXT:    [[VEC_CAST78:%.*]] = bitcast double* [[VEC_GEP77]] to <1 x double>*
; CHECK-NEXT:    [[COL_LOAD79:%.*]] = load <1 x double>, <1 x double>* [[VEC_CAST78]], align 8
; CHECK-NEXT:    [[TMP27:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP11]], i64 0, i64 4
; CHECK-NEXT:    [[VEC_CAST81:%.*]] = bitcast double* [[TMP27]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD82:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST81]], align 8
; CHECK-NEXT:    [[SPLAT_SPLATINSERT84:%.*]] = shufflevector <2 x double> [[COL_LOAD82]], <2 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP28:%.*]] = fmul contract <1 x double> [[COL_LOAD76]], [[SPLAT_SPLATINSERT84]]
; CHECK-NEXT:    [[SPLAT_SPLATINSERT87:%.*]] = shufflevector <2 x double> [[COL_LOAD82]], <2 x double> undef, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP29:%.*]] = call contract <1 x double> @llvm.fmuladd.v1f64(<1 x double> [[COL_LOAD79]], <1 x double> [[SPLAT_SPLATINSERT87]], <1 x double> [[TMP28]])
; CHECK-NEXT:    [[TMP30:%.*]] = getelementptr <9 x double>, <9 x double>* [[C]], i64 0, i64 8
; CHECK-NEXT:    [[VEC_CAST90:%.*]] = bitcast double* [[TMP30]] to <1 x double>*
; CHECK-NEXT:    store <1 x double> [[TMP29]], <1 x double>* [[VEC_CAST90]], align 8
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    [[TMP31:%.*]] = fadd contract <3 x double> [[COL_LOAD196]], [[COL_LOAD196]]
; CHECK-NEXT:    [[TMP32:%.*]] = fadd contract <3 x double> [[COL_LOAD199]], [[COL_LOAD199]]
; CHECK-NEXT:    [[VEC_CAST213:%.*]] = bitcast <6 x double>* [[A]] to <3 x double>*
; CHECK-NEXT:    store <3 x double> [[TMP31]], <3 x double>* [[VEC_CAST213]], align 8
; CHECK-NEXT:    [[VEC_GEP214:%.*]] = getelementptr <6 x double>, <6 x double>* [[A]], i64 0, i64 3
; CHECK-NEXT:    [[VEC_CAST215:%.*]] = bitcast double* [[VEC_GEP214]] to <3 x double>*
; CHECK-NEXT:    store <3 x double> [[TMP32]], <3 x double>* [[VEC_CAST215]], align 8
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       false:
; CHECK-NEXT:    [[TMP33:%.*]] = fadd contract <2 x double> [[COL_LOAD201]], [[COL_LOAD201]]
; CHECK-NEXT:    [[TMP34:%.*]] = fadd contract <2 x double> [[COL_LOAD204]], [[COL_LOAD204]]
; CHECK-NEXT:    [[TMP35:%.*]] = fadd contract <2 x double> [[COL_LOAD207]], [[COL_LOAD207]]
; CHECK-NEXT:    [[VEC_CAST208:%.*]] = bitcast <6 x double>* [[B]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP33]], <2 x double>* [[VEC_CAST208]], align 8
; CHECK-NEXT:    [[VEC_GEP209:%.*]] = getelementptr <6 x double>, <6 x double>* [[B]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST210:%.*]] = bitcast double* [[VEC_GEP209]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP34]], <2 x double>* [[VEC_CAST210]], align 8
; CHECK-NEXT:    [[VEC_GEP211:%.*]] = getelementptr <6 x double>, <6 x double>* [[B]], i64 0, i64 4
; CHECK-NEXT:    [[VEC_CAST212:%.*]] = bitcast double* [[VEC_GEP211]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP35]], <2 x double>* [[VEC_CAST212]], align 8
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[STORE_BEGIN94:%.*]] = ptrtoint <9 x double>* [[C]] to i64
; CHECK-NEXT:    [[STORE_END95:%.*]] = add nuw nsw i64 [[STORE_BEGIN94]], 72
; CHECK-NEXT:    [[LOAD_BEGIN96:%.*]] = ptrtoint <6 x double>* [[A]] to i64
; CHECK-NEXT:    [[TMP36:%.*]] = icmp ugt i64 [[STORE_END95]], [[LOAD_BEGIN96]]
; CHECK-NEXT:    br i1 [[TMP36]], label [[ALIAS_CONT91:%.*]], label [[NO_ALIAS93:%.*]]
; CHECK:       alias_cont91:
; CHECK-NEXT:    [[LOAD_END97:%.*]] = add nuw nsw i64 [[LOAD_BEGIN96]], 48
; CHECK-NEXT:    [[TMP37:%.*]] = icmp ugt i64 [[LOAD_END97]], [[STORE_BEGIN94]]
; CHECK-NEXT:    br i1 [[TMP37]], label [[COPY92:%.*]], label [[NO_ALIAS93]]
; CHECK:       copy92:
; CHECK-NEXT:    [[TMP38:%.*]] = alloca <6 x double>, align 64
; CHECK-NEXT:    [[TMP39:%.*]] = bitcast <6 x double>* [[TMP38]] to i8*
; CHECK-NEXT:    [[TMP40:%.*]] = bitcast <6 x double>* [[A]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 64 dereferenceable(48) [[TMP39]], i8* noundef nonnull align 8 dereferenceable(48) [[TMP40]], i64 48, i1 false)
; CHECK-NEXT:    br label [[NO_ALIAS93]]
; CHECK:       no_alias93:
; CHECK-NEXT:    [[TMP41:%.*]] = phi <6 x double>* [ [[A]], [[END]] ], [ [[A]], [[ALIAS_CONT91]] ], [ [[TMP38]], [[COPY92]] ]
; CHECK-NEXT:    [[STORE_BEGIN101:%.*]] = ptrtoint <9 x double>* [[C]] to i64
; CHECK-NEXT:    [[STORE_END102:%.*]] = add nuw nsw i64 [[STORE_BEGIN101]], 72
; CHECK-NEXT:    [[LOAD_BEGIN103:%.*]] = ptrtoint <6 x double>* [[B]] to i64
; CHECK-NEXT:    [[TMP42:%.*]] = icmp ugt i64 [[STORE_END102]], [[LOAD_BEGIN103]]
; CHECK-NEXT:    br i1 [[TMP42]], label [[ALIAS_CONT98:%.*]], label [[NO_ALIAS100:%.*]]
; CHECK:       alias_cont98:
; CHECK-NEXT:    [[LOAD_END104:%.*]] = add nuw nsw i64 [[LOAD_BEGIN103]], 48
; CHECK-NEXT:    [[TMP43:%.*]] = icmp ugt i64 [[LOAD_END104]], [[STORE_BEGIN101]]
; CHECK-NEXT:    br i1 [[TMP43]], label [[COPY99:%.*]], label [[NO_ALIAS100]]
; CHECK:       copy99:
; CHECK-NEXT:    [[TMP44:%.*]] = alloca <6 x double>, align 64
; CHECK-NEXT:    [[TMP45:%.*]] = bitcast <6 x double>* [[TMP44]] to i8*
; CHECK-NEXT:    [[TMP46:%.*]] = bitcast <6 x double>* [[B]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 64 dereferenceable(48) [[TMP45]], i8* noundef nonnull align 8 dereferenceable(48) [[TMP46]], i64 48, i1 false)
; CHECK-NEXT:    br label [[NO_ALIAS100]]
; CHECK:       no_alias100:
; CHECK-NEXT:    [[TMP47:%.*]] = phi <6 x double>* [ [[B]], [[NO_ALIAS93]] ], [ [[B]], [[ALIAS_CONT98]] ], [ [[TMP44]], [[COPY99]] ]
; CHECK-NEXT:    [[VEC_CAST106:%.*]] = bitcast <6 x double>* [[TMP41]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD107:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST106]], align 8
; CHECK-NEXT:    [[VEC_GEP108:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP41]], i64 0, i64 3
; CHECK-NEXT:    [[VEC_CAST109:%.*]] = bitcast double* [[VEC_GEP108]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD110:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST109]], align 8
; CHECK-NEXT:    [[VEC_CAST112:%.*]] = bitcast <6 x double>* [[TMP47]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD113:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST112]], align 8
; CHECK-NEXT:    [[VEC_GEP114:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP47]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST115:%.*]] = bitcast double* [[VEC_GEP114]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD116:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST115]], align 8
; CHECK-NEXT:    [[SPLAT_SPLAT119:%.*]] = shufflevector <2 x double> [[COL_LOAD113]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP48:%.*]] = fmul contract <2 x double> [[COL_LOAD107]], [[SPLAT_SPLAT119]]
; CHECK-NEXT:    [[SPLAT_SPLAT122:%.*]] = shufflevector <2 x double> [[COL_LOAD113]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP49:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD110]], <2 x double> [[SPLAT_SPLAT122]], <2 x double> [[TMP48]])
; CHECK-NEXT:    [[SPLAT_SPLAT125:%.*]] = shufflevector <2 x double> [[COL_LOAD116]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP50:%.*]] = fmul contract <2 x double> [[COL_LOAD107]], [[SPLAT_SPLAT125]]
; CHECK-NEXT:    [[SPLAT_SPLAT128:%.*]] = shufflevector <2 x double> [[COL_LOAD116]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP51:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD110]], <2 x double> [[SPLAT_SPLAT128]], <2 x double> [[TMP50]])
; CHECK-NEXT:    [[VEC_CAST130:%.*]] = bitcast <9 x double>* [[C]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP49]], <2 x double>* [[VEC_CAST130]], align 8
; CHECK-NEXT:    [[VEC_GEP131:%.*]] = getelementptr <9 x double>, <9 x double>* [[C]], i64 0, i64 3
; CHECK-NEXT:    [[VEC_CAST132:%.*]] = bitcast double* [[VEC_GEP131]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP51]], <2 x double>* [[VEC_CAST132]], align 8
; CHECK-NEXT:    [[TMP52:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP41]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST134:%.*]] = bitcast double* [[TMP52]] to <1 x double>*
; CHECK-NEXT:    [[COL_LOAD135:%.*]] = load <1 x double>, <1 x double>* [[VEC_CAST134]], align 8
; CHECK-NEXT:    [[VEC_GEP136:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP41]], i64 0, i64 5
; CHECK-NEXT:    [[VEC_CAST137:%.*]] = bitcast double* [[VEC_GEP136]] to <1 x double>*
; CHECK-NEXT:    [[COL_LOAD138:%.*]] = load <1 x double>, <1 x double>* [[VEC_CAST137]], align 8
; CHECK-NEXT:    [[VEC_CAST140:%.*]] = bitcast <6 x double>* [[TMP47]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD141:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST140]], align 8
; CHECK-NEXT:    [[VEC_GEP142:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP47]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST143:%.*]] = bitcast double* [[VEC_GEP142]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD144:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST143]], align 8
; CHECK-NEXT:    [[SPLAT_SPLATINSERT146:%.*]] = shufflevector <2 x double> [[COL_LOAD141]], <2 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP53:%.*]] = fmul contract <1 x double> [[COL_LOAD135]], [[SPLAT_SPLATINSERT146]]
; CHECK-NEXT:    [[SPLAT_SPLATINSERT149:%.*]] = shufflevector <2 x double> [[COL_LOAD141]], <2 x double> undef, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP54:%.*]] = call contract <1 x double> @llvm.fmuladd.v1f64(<1 x double> [[COL_LOAD138]], <1 x double> [[SPLAT_SPLATINSERT149]], <1 x double> [[TMP53]])
; CHECK-NEXT:    [[SPLAT_SPLATINSERT152:%.*]] = shufflevector <2 x double> [[COL_LOAD144]], <2 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP55:%.*]] = fmul contract <1 x double> [[COL_LOAD135]], [[SPLAT_SPLATINSERT152]]
; CHECK-NEXT:    [[SPLAT_SPLATINSERT155:%.*]] = shufflevector <2 x double> [[COL_LOAD144]], <2 x double> undef, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP56:%.*]] = call contract <1 x double> @llvm.fmuladd.v1f64(<1 x double> [[COL_LOAD138]], <1 x double> [[SPLAT_SPLATINSERT155]], <1 x double> [[TMP55]])
; CHECK-NEXT:    [[TMP57:%.*]] = getelementptr <9 x double>, <9 x double>* [[C]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST158:%.*]] = bitcast double* [[TMP57]] to <1 x double>*
; CHECK-NEXT:    store <1 x double> [[TMP54]], <1 x double>* [[VEC_CAST158]], align 8
; CHECK-NEXT:    [[VEC_GEP159:%.*]] = getelementptr <9 x double>, <9 x double>* [[C]], i64 0, i64 5
; CHECK-NEXT:    [[VEC_CAST160:%.*]] = bitcast double* [[VEC_GEP159]] to <1 x double>*
; CHECK-NEXT:    store <1 x double> [[TMP56]], <1 x double>* [[VEC_CAST160]], align 8
; CHECK-NEXT:    [[VEC_CAST162:%.*]] = bitcast <6 x double>* [[TMP41]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD163:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST162]], align 8
; CHECK-NEXT:    [[VEC_GEP164:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP41]], i64 0, i64 3
; CHECK-NEXT:    [[VEC_CAST165:%.*]] = bitcast double* [[VEC_GEP164]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD166:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST165]], align 8
; CHECK-NEXT:    [[TMP58:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP47]], i64 0, i64 4
; CHECK-NEXT:    [[VEC_CAST168:%.*]] = bitcast double* [[TMP58]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD169:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST168]], align 8
; CHECK-NEXT:    [[SPLAT_SPLAT172:%.*]] = shufflevector <2 x double> [[COL_LOAD169]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP59:%.*]] = fmul contract <2 x double> [[COL_LOAD163]], [[SPLAT_SPLAT172]]
; CHECK-NEXT:    [[SPLAT_SPLAT175:%.*]] = shufflevector <2 x double> [[COL_LOAD169]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP60:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD166]], <2 x double> [[SPLAT_SPLAT175]], <2 x double> [[TMP59]])
; CHECK-NEXT:    [[TMP61:%.*]] = getelementptr <9 x double>, <9 x double>* [[C]], i64 0, i64 6
; CHECK-NEXT:    [[VEC_CAST177:%.*]] = bitcast double* [[TMP61]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP60]], <2 x double>* [[VEC_CAST177]], align 8
; CHECK-NEXT:    [[TMP62:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP41]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST179:%.*]] = bitcast double* [[TMP62]] to <1 x double>*
; CHECK-NEXT:    [[COL_LOAD180:%.*]] = load <1 x double>, <1 x double>* [[VEC_CAST179]], align 8
; CHECK-NEXT:    [[VEC_GEP181:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP41]], i64 0, i64 5
; CHECK-NEXT:    [[VEC_CAST182:%.*]] = bitcast double* [[VEC_GEP181]] to <1 x double>*
; CHECK-NEXT:    [[COL_LOAD183:%.*]] = load <1 x double>, <1 x double>* [[VEC_CAST182]], align 8
; CHECK-NEXT:    [[TMP63:%.*]] = getelementptr <6 x double>, <6 x double>* [[TMP47]], i64 0, i64 4
; CHECK-NEXT:    [[VEC_CAST185:%.*]] = bitcast double* [[TMP63]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD186:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST185]], align 8
; CHECK-NEXT:    [[SPLAT_SPLATINSERT188:%.*]] = shufflevector <2 x double> [[COL_LOAD186]], <2 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP64:%.*]] = fmul contract <1 x double> [[COL_LOAD180]], [[SPLAT_SPLATINSERT188]]
; CHECK-NEXT:    [[SPLAT_SPLATINSERT191:%.*]] = shufflevector <2 x double> [[COL_LOAD186]], <2 x double> undef, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP65:%.*]] = call contract <1 x double> @llvm.fmuladd.v1f64(<1 x double> [[COL_LOAD183]], <1 x double> [[SPLAT_SPLATINSERT191]], <1 x double> [[TMP64]])
; CHECK-NEXT:    [[TMP66:%.*]] = getelementptr <9 x double>, <9 x double>* [[C]], i64 0, i64 8
; CHECK-NEXT:    [[VEC_CAST194:%.*]] = bitcast double* [[TMP66]] to <1 x double>*
; CHECK-NEXT:    store <1 x double> [[TMP65]], <1 x double>* [[VEC_CAST194]], align 8
; CHECK-NEXT:    ret void
;
entry:
  %a = load <6 x double>, <6 x double>* %A, align 8
  %b = load <6 x double>, <6 x double>* %B, align 8
  %c = call <9 x double> @llvm.matrix.multiply(<6 x double> %a, <6 x double> %b, i32 3, i32 2, i32 3)
  store <9 x double> %c, <9 x double>* %C, align 8

  br i1 %cond, label %true, label %false

true:
  %a.add = fadd <6 x double> %a, %a
  store <6 x double> %a.add, <6 x double>* %A, align 8
  br label %end

false:
  %b.add = fadd <6 x double> %b, %b
  store <6 x double> %b.add, <6 x double>* %B, align 8
  br label %end

end:
  %a.2 = load <6 x double>, <6 x double>* %A, align 8
  %b.2 = load <6 x double>, <6 x double>* %B, align 8
  %c.2 = call <9 x double> @llvm.matrix.multiply(<6 x double> %a.2, <6 x double> %b.2, i32 3, i32 2, i32 3)
  store <9 x double> %c.2, <9 x double>* %C, align 8
  ret void
}

declare <9 x double> @llvm.matrix.multiply(<6 x double>, <6 x double>, i32, i32, i32)
