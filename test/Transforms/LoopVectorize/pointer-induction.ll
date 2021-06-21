; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s  -loop-vectorize -force-vector-interleave=1 -force-vector-width=4 -S | FileCheck %s
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"


; Function Attrs: nofree norecurse nounwind
define void @a(i8* readnone %b) {
; CHECK-LABEL: @a(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B1:%.*]] = ptrtoint i8* [[B:%.*]] to i64
; CHECK-NEXT:    [[CMP_NOT4:%.*]] = icmp eq i8* [[B]], null
; CHECK-NEXT:    br i1 [[CMP_NOT4]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY_PREHEADER:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = sub i64 0, [[B1]]
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[TMP0]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[TMP0]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[TMP0]], [[N_MOD_VF]]
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[N_VEC]], -1
; CHECK-NEXT:    [[IND_END:%.*]] = getelementptr i8, i8* null, i64 [[TMP1]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[POINTER_PHI:%.*]] = phi i8* [ null, [[VECTOR_PH]] ], [ [[PTR_IND:%.*]], [[PRED_STORE_CONTINUE7:%.*]] ]
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE7]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr i8, i8* [[POINTER_PHI]], <4 x i64> <i64 0, i64 -1, i64 -2, i64 -3>
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i8, <4 x i8*> [[TMP2]], i64 -1
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i8*> [[TMP3]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr i8, i8* [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr i8, i8* [[TMP5]], i32 -3
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i8* [[TMP6]] to <4 x i8>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i8>, <4 x i8>* [[TMP7]], align 1
; CHECK-NEXT:    [[REVERSE:%.*]] = shufflevector <4 x i8> [[WIDE_LOAD]], <4 x i8> poison, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    [[TMP8:%.*]] = icmp eq <4 x i8> [[REVERSE]], zeroinitializer
; CHECK-NEXT:    [[TMP9:%.*]] = xor <4 x i1> [[TMP8]], <i1 true, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <4 x i1> [[TMP9]], i32 0
; CHECK-NEXT:    br i1 [[TMP10]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; CHECK:       pred.store.if:
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <4 x i8*> [[TMP3]], i32 0
; CHECK-NEXT:    store i8 95, i8* [[TMP11]], align 1
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE]]
; CHECK:       pred.store.continue:
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <4 x i1> [[TMP9]], i32 1
; CHECK-NEXT:    br i1 [[TMP12]], label [[PRED_STORE_IF2:%.*]], label [[PRED_STORE_CONTINUE3:%.*]]
; CHECK:       pred.store.if2:
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <4 x i8*> [[TMP3]], i32 1
; CHECK-NEXT:    store i8 95, i8* [[TMP13]], align 1
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE3]]
; CHECK:       pred.store.continue3:
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <4 x i1> [[TMP9]], i32 2
; CHECK-NEXT:    br i1 [[TMP14]], label [[PRED_STORE_IF4:%.*]], label [[PRED_STORE_CONTINUE5:%.*]]
; CHECK:       pred.store.if4:
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <4 x i8*> [[TMP3]], i32 2
; CHECK-NEXT:    store i8 95, i8* [[TMP15]], align 1
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE5]]
; CHECK:       pred.store.continue5:
; CHECK-NEXT:    [[TMP16:%.*]] = extractelement <4 x i1> [[TMP9]], i32 3
; CHECK-NEXT:    br i1 [[TMP16]], label [[PRED_STORE_IF6:%.*]], label [[PRED_STORE_CONTINUE7]]
; CHECK:       pred.store.if6:
; CHECK-NEXT:    [[TMP17:%.*]] = extractelement <4 x i8*> [[TMP3]], i32 3
; CHECK-NEXT:    store i8 95, i8* [[TMP17]], align 1
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE7]]
; CHECK:       pred.store.continue7:
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP18:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    [[PTR_IND]] = getelementptr i8, i8* [[POINTER_PHI]], i64 -4
; CHECK-NEXT:    br i1 [[TMP18]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[TMP0]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i8* [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ null, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[C_05:%.*]] = phi i8* [ [[INCDEC_PTR:%.*]], [[IF_END:%.*]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[INCDEC_PTR]] = getelementptr inbounds i8, i8* [[C_05]], i64 -1
; CHECK-NEXT:    [[TMP19:%.*]] = load i8, i8* [[INCDEC_PTR]], align 1
; CHECK-NEXT:    [[TOBOOL_NOT:%.*]] = icmp eq i8 [[TMP19]], 0
; CHECK-NEXT:    br i1 [[TOBOOL_NOT]], label [[IF_END]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i8 95, i8* [[INCDEC_PTR]], align 1
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[CMP_NOT:%.*]] = icmp eq i8* [[INCDEC_PTR]], [[B]]
; CHECK-NEXT:    br i1 [[CMP_NOT]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
;

entry:
  %cmp.not4 = icmp eq i8* %b, null
  br i1 %cmp.not4, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.cond.cleanup.loopexit:                        ; preds = %if.end
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader, %if.end
  %c.05 = phi i8* [ %incdec.ptr, %if.end ], [ null, %for.body.preheader ]
  %incdec.ptr = getelementptr inbounds i8, i8* %c.05, i64 -1
  %0 = load i8, i8* %incdec.ptr, align 1
  %tobool.not = icmp eq i8 %0, 0
  br i1 %tobool.not, label %if.end, label %if.then

if.then:                                          ; preds = %for.body
  store i8 95, i8* %incdec.ptr, align 1
  br label %if.end

if.end:                                           ; preds = %for.body, %if.then
  %cmp.not = icmp eq i8* %incdec.ptr, %b
  br i1 %cmp.not, label %for.cond.cleanup.loopexit, label %for.body
}

