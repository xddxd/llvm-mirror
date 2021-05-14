; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -force-vector-width=4 -force-vector-interleave=1 -S %s | FileCheck %s


@p = external local_unnamed_addr global [257 x i32], align 16
@q = external local_unnamed_addr global [257 x i32], align 16

; Test case for PR43398.

define void @can_sink_after_store(i32 %x, i32* %ptr, i64 %tc) local_unnamed_addr #0 {
; CHECK-LABEL: @can_sink_after_store(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[PREHEADER:%.*]]
; CHECK:       preheader:
; CHECK-NEXT:    [[IDX_PHI_TRANS:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 1
; CHECK-NEXT:    [[DOTPRE:%.*]] = load i32, i32* [[IDX_PHI_TRANS]], align 4
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[VECTOR_RECUR_INIT:%.*]] = insertelement <4 x i32> poison, i32 [[DOTPRE]], i32 3
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VECTOR_RECUR:%.*]] = phi <4 x i32> [ [[VECTOR_RECUR_INIT]], [[VECTOR_PH]] ], [ [[WIDE_LOAD:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = add i64 1, [[INDEX]]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[OFFSET_IDX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD]] = load <4 x i32>, <4 x i32>* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <4 x i32> [[VECTOR_RECUR]], <4 x i32> [[WIDE_LOAD]], <4 x i32> <i32 3, i32 4, i32 5, i32 6>
; CHECK-NEXT:    [[TMP5:%.*]] = add <4 x i32> [[TMP4]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP6:%.*]] = add <4 x i32> [[TMP5]], [[WIDE_LOAD]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @q, i64 0, i64 [[TMP0]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[TMP7]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast i32* [[TMP8]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP6]], <4 x i32>* [[TMP9]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP10:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1996
; CHECK-NEXT:    br i1 [[TMP10]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP0:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1999, 1996
; CHECK-NEXT:    [[VECTOR_RECUR_EXTRACT:%.*]] = extractelement <4 x i32> [[WIDE_LOAD]], i32 3
; CHECK-NEXT:    [[VECTOR_RECUR_EXTRACT_FOR_PHI:%.*]] = extractelement <4 x i32> [[WIDE_LOAD]], i32 2
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[SCALAR_RECUR_INIT:%.*]] = phi i32 [ [[DOTPRE]], [[PREHEADER]] ], [ [[VECTOR_RECUR_EXTRACT]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 1997, [[MIDDLE_BLOCK]] ], [ 1, [[PREHEADER]] ]
; CHECK-NEXT:    br label [[FOR:%.*]]
; CHECK:       for:
; CHECK-NEXT:    [[SCALAR_RECUR:%.*]] = phi i32 [ [[SCALAR_RECUR_INIT]], [[SCALAR_PH]] ], [ [[PRE_NEXT:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[ADD_1:%.*]] = add i32 [[SCALAR_RECUR]], [[X]]
; CHECK-NEXT:    [[IDX_1:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 [[IV]]
; CHECK-NEXT:    [[PRE_NEXT]] = load i32, i32* [[IDX_1]], align 4
; CHECK-NEXT:    [[ADD_2:%.*]] = add i32 [[ADD_1]], [[PRE_NEXT]]
; CHECK-NEXT:    [[IDX_2:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @q, i64 0, i64 [[IV]]
; CHECK-NEXT:    store i32 [[ADD_2]], i32* [[IDX_2]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_NEXT]], 2000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[EXIT]], label [[FOR]], [[LOOP2:!llvm.loop !.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;

entry:
  br label %preheader

preheader:
  %idx.phi.trans = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 1
  %.pre = load i32, i32* %idx.phi.trans, align 4
  br label %for

for:
  %pre.phi = phi i32 [ %.pre, %preheader ], [ %pre.next, %for ]
  %iv = phi i64 [ 1, %preheader ], [ %iv.next, %for ]
  %add.1 = add i32 %pre.phi, %x
  %idx.1 = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 %iv
  %pre.next = load i32, i32* %idx.1, align 4
  %add.2 = add i32 %add.1, %pre.next
  %idx.2 = getelementptr inbounds [257 x i32], [257 x i32]* @q, i64 0, i64 %iv
  store i32 %add.2, i32* %idx.2, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 2000
  br i1 %exitcond, label %exit, label %for

exit:
  ret void
}

; We can sink potential trapping instructions, as this will only delay the trap
; and not introduce traps on additional paths.
define void @sink_sdiv(i32 %x, i32* %ptr, i64 %tc) local_unnamed_addr #0 {
; CHECK-LABEL: @sink_sdiv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[PREHEADER:%.*]]
; CHECK:       preheader:
; CHECK-NEXT:    [[IDX_PHI_TRANS:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 1
; CHECK-NEXT:    [[DOTPRE:%.*]] = load i32, i32* [[IDX_PHI_TRANS]], align 4
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[VECTOR_RECUR_INIT:%.*]] = insertelement <4 x i32> poison, i32 [[DOTPRE]], i32 3
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VECTOR_RECUR:%.*]] = phi <4 x i32> [ [[VECTOR_RECUR_INIT]], [[VECTOR_PH]] ], [ [[WIDE_LOAD:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = add i64 1, [[INDEX]]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[OFFSET_IDX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD]] = load <4 x i32>, <4 x i32>* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <4 x i32> [[VECTOR_RECUR]], <4 x i32> [[WIDE_LOAD]], <4 x i32> <i32 3, i32 4, i32 5, i32 6>
; CHECK-NEXT:    [[TMP5:%.*]] = sdiv <4 x i32> [[TMP4]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP6:%.*]] = add <4 x i32> [[TMP5]], [[WIDE_LOAD]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @q, i64 0, i64 [[TMP0]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[TMP7]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast i32* [[TMP8]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP6]], <4 x i32>* [[TMP9]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP10:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1996
; CHECK-NEXT:    br i1 [[TMP10]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP4:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1999, 1996
; CHECK-NEXT:    [[VECTOR_RECUR_EXTRACT:%.*]] = extractelement <4 x i32> [[WIDE_LOAD]], i32 3
; CHECK-NEXT:    [[VECTOR_RECUR_EXTRACT_FOR_PHI:%.*]] = extractelement <4 x i32> [[WIDE_LOAD]], i32 2
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[SCALAR_RECUR_INIT:%.*]] = phi i32 [ [[DOTPRE]], [[PREHEADER]] ], [ [[VECTOR_RECUR_EXTRACT]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 1997, [[MIDDLE_BLOCK]] ], [ 1, [[PREHEADER]] ]
; CHECK-NEXT:    br label [[FOR:%.*]]
; CHECK:       for:
; CHECK-NEXT:    [[SCALAR_RECUR:%.*]] = phi i32 [ [[SCALAR_RECUR_INIT]], [[SCALAR_PH]] ], [ [[PRE_NEXT:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[DIV_1:%.*]] = sdiv i32 [[SCALAR_RECUR]], [[X]]
; CHECK-NEXT:    [[IDX_1:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 [[IV]]
; CHECK-NEXT:    [[PRE_NEXT]] = load i32, i32* [[IDX_1]], align 4
; CHECK-NEXT:    [[ADD_2:%.*]] = add i32 [[DIV_1]], [[PRE_NEXT]]
; CHECK-NEXT:    [[IDX_2:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @q, i64 0, i64 [[IV]]
; CHECK-NEXT:    store i32 [[ADD_2]], i32* [[IDX_2]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_NEXT]], 2000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[EXIT]], label [[FOR]], [[LOOP5:!llvm.loop !.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;

entry:
  br label %preheader

preheader:
  %idx.phi.trans = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 1
  %.pre = load i32, i32* %idx.phi.trans, align 4
  br label %for

for:
  %pre.phi = phi i32 [ %.pre, %preheader ], [ %pre.next, %for ]
  %iv = phi i64 [ 1, %preheader ], [ %iv.next, %for ]
  %div.1 = sdiv i32 %pre.phi, %x
  %idx.1 = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 %iv
  %pre.next = load i32, i32* %idx.1, align 4
  %add.2 = add i32 %div.1, %pre.next
  %idx.2 = getelementptr inbounds [257 x i32], [257 x i32]* @q, i64 0, i64 %iv
  store i32 %add.2, i32* %idx.2, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 2000
  br i1 %exitcond, label %exit, label %for

exit:
  ret void
}

; FIXME: Currently we can only sink a single instruction. For the example below,
;        we also have to sink users.
define void @cannot_sink_with_additional_user(i32 %x, i32* %ptr, i64 %tc) {
; CHECK-LABEL: @cannot_sink_with_additional_user(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[PREHEADER:%.*]]
; CHECK:       preheader:
; CHECK-NEXT:    [[IDX_PHI_TRANS:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 1
; CHECK-NEXT:    [[DOTPRE:%.*]] = load i32, i32* [[IDX_PHI_TRANS]], align 4
; CHECK-NEXT:    br label [[FOR:%.*]]
; CHECK:       for:
; CHECK-NEXT:    [[PRE_PHI:%.*]] = phi i32 [ [[DOTPRE]], [[PREHEADER]] ], [ [[PRE_NEXT:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 1, [[PREHEADER]] ], [ [[IV_NEXT:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[ADD_1:%.*]] = add i32 [[PRE_PHI]], [[X:%.*]]
; CHECK-NEXT:    [[ADD_2:%.*]] = add i32 [[ADD_1]], [[X]]
; CHECK-NEXT:    [[IDX_1:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 [[IV]]
; CHECK-NEXT:    [[PRE_NEXT]] = load i32, i32* [[IDX_1]], align 4
; CHECK-NEXT:    [[ADD_3:%.*]] = add i32 [[ADD_1]], [[PRE_NEXT]]
; CHECK-NEXT:    [[ADD_4:%.*]] = add i32 [[ADD_2]], [[ADD_3]]
; CHECK-NEXT:    [[IDX_2:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @q, i64 0, i64 [[IV]]
; CHECK-NEXT:    store i32 [[ADD_4]], i32* [[IDX_2]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_NEXT]], 2000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[EXIT:%.*]], label [[FOR]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;




entry:
  br label %preheader

preheader:
  %idx.phi.trans = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 1
  %.pre = load i32, i32* %idx.phi.trans, align 4
  br label %for

for:
  %pre.phi = phi i32 [ %.pre, %preheader ], [ %pre.next, %for ]
  %iv = phi i64 [ 1, %preheader ], [ %iv.next, %for ]
  %add.1 = add i32 %pre.phi, %x
  %add.2 = add i32 %add.1, %x
  %idx.1 = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 %iv
  %pre.next = load i32, i32* %idx.1, align 4
  %add.3 = add i32 %add.1, %pre.next
  %add.4 = add i32 %add.2, %add.3
  %idx.2 = getelementptr inbounds [257 x i32], [257 x i32]* @q, i64 0, i64 %iv
  store i32 %add.4, i32* %idx.2, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 2000
  br i1 %exitcond, label %exit, label %for

exit:
  ret void
}

; FIXME: We can sink a store, if we can guarantee that it does not alias any
;        loads/stores in between.
define void @cannot_sink_store(i32 %x, i32* %ptr, i64 %tc) {
; CHECK-LABEL: @cannot_sink_store(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[PREHEADER:%.*]]
; CHECK:       preheader:
; CHECK-NEXT:    [[IDX_PHI_TRANS:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 1
; CHECK-NEXT:    [[DOTPRE:%.*]] = load i32, i32* [[IDX_PHI_TRANS]], align 4
; CHECK-NEXT:    br label [[FOR:%.*]]
; CHECK:       for:
; CHECK-NEXT:    [[PRE_PHI:%.*]] = phi i32 [ [[DOTPRE]], [[PREHEADER]] ], [ [[PRE_NEXT:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 1, [[PREHEADER]] ], [ [[IV_NEXT:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[ADD_1:%.*]] = add i32 [[PRE_PHI]], [[X:%.*]]
; CHECK-NEXT:    store i32 [[ADD_1]], i32* [[PTR:%.*]], align 4
; CHECK-NEXT:    [[IDX_1:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 [[IV]]
; CHECK-NEXT:    [[PRE_NEXT]] = load i32, i32* [[IDX_1]], align 4
; CHECK-NEXT:    [[ADD_2:%.*]] = add i32 [[ADD_1]], [[PRE_NEXT]]
; CHECK-NEXT:    [[IDX_2:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @q, i64 0, i64 [[IV]]
; CHECK-NEXT:    store i32 [[ADD_2]], i32* [[IDX_2]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_NEXT]], 2000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[EXIT:%.*]], label [[FOR]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;



entry:
  br label %preheader

preheader:
  %idx.phi.trans = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 1
  %.pre = load i32, i32* %idx.phi.trans, align 4
  br label %for

for:
  %pre.phi = phi i32 [ %.pre, %preheader ], [ %pre.next, %for ]
  %iv = phi i64 [ 1, %preheader ], [ %iv.next, %for ]
  %add.1 = add i32 %pre.phi, %x
  store i32 %add.1, i32* %ptr
  %idx.1 = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 %iv
  %pre.next = load i32, i32* %idx.1, align 4
  %add.2 = add i32 %add.1, %pre.next
  %idx.2 = getelementptr inbounds [257 x i32], [257 x i32]* @q, i64 0, i64 %iv
  store i32 %add.2, i32* %idx.2, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 2000
  br i1 %exitcond, label %exit, label %for

exit:
  ret void
}

; Some kinds of reductions are not detected by IVDescriptors. If we have a
; cycle, we cannot sink it.
define void @cannot_sink_reduction(i32 %x, i32* %ptr, i64 %tc) {
; CHECK-LABEL: @cannot_sink_reduction(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[PREHEADER:%.*]]
; CHECK:       preheader:
; CHECK-NEXT:    [[IDX_PHI_TRANS:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 1
; CHECK-NEXT:    [[DOTPRE:%.*]] = load i32, i32* [[IDX_PHI_TRANS]], align 4
; CHECK-NEXT:    br label [[FOR:%.*]]
; CHECK:       for:
; CHECK-NEXT:    [[PRE_PHI:%.*]] = phi i32 [ [[DOTPRE]], [[PREHEADER]] ], [ [[D:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 1, [[PREHEADER]] ], [ [[IV_NEXT:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[D]] = sdiv i32 [[PRE_PHI]], [[X:%.*]]
; CHECK-NEXT:    [[IDX_1:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 [[IV]]
; CHECK-NEXT:    [[PRE_NEXT:%.*]] = load i32, i32* [[IDX_1]], align 4
; CHECK-NEXT:    [[ADD_2:%.*]] = add i32 [[X]], [[PRE_NEXT]]
; CHECK-NEXT:    [[IDX_2:%.*]] = getelementptr inbounds [257 x i32], [257 x i32]* @q, i64 0, i64 [[IV]]
; CHECK-NEXT:    store i32 [[ADD_2]], i32* [[IDX_2]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_NEXT]], 2000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[EXIT:%.*]], label [[FOR]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;



; CHECK-NET:     ret void
entry:
  br label %preheader

preheader:
  %idx.phi.trans = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 1
  %.pre = load i32, i32* %idx.phi.trans, align 4
  br label %for

for:
  %pre.phi = phi i32 [ %.pre, %preheader ], [ %d, %for ]
  %iv = phi i64 [ 1, %preheader ], [ %iv.next, %for ]
  %d = sdiv i32 %pre.phi, %x
  %idx.1 = getelementptr inbounds [257 x i32], [257 x i32]* @p, i64 0, i64 %iv
  %pre.next = load i32, i32* %idx.1, align 4
  %add.2 = add i32 %x, %pre.next
  %idx.2 = getelementptr inbounds [257 x i32], [257 x i32]* @q, i64 0, i64 %iv
  store i32 %add.2, i32* %idx.2, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 2000
  br i1 %exitcond, label %exit, label %for

exit:
  ret void
}

; TODO: We should be able to sink %tmp38 after %tmp60.
define void @instruction_with_2_FOR_operands() {
; CHECK-LABEL: @instruction_with_2_FOR_operands(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB13:%.*]]
; CHECK:       bb13:
; CHECK-NEXT:    [[TMP37:%.*]] = phi float [ [[TMP60:%.*]], [[BB13]] ], [ undef, [[BB:%.*]] ]
; CHECK-NEXT:    [[TMP27:%.*]] = phi float [ [[TMP49:%.*]], [[BB13]] ], [ undef, [[BB]] ]
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[BB13]] ], [ 0, [[BB]] ]
; CHECK-NEXT:    [[TMP38:%.*]] = fmul fast float [[TMP37]], [[TMP27]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[TMP49]] = load float, float* undef, align 4
; CHECK-NEXT:    [[TMP60]] = load float, float* undef, align 4
; CHECK-NEXT:    [[TMP12:%.*]] = icmp slt i64 [[INDVARS_IV]], undef
; CHECK-NEXT:    br i1 [[TMP12]], label [[BB13]], label [[BB74:%.*]]
; CHECK:       bb74:
; CHECK-NEXT:    ret void
;


bb:
  br label %bb13

bb13:                                             ; preds = %bb13, %bb
  %tmp37 = phi float [ %tmp60, %bb13 ], [ undef, %bb ]
  %tmp27 = phi float [ %tmp49, %bb13 ], [ undef, %bb ]
  %indvars.iv = phi i64 [ %indvars.iv.next, %bb13 ], [ 0, %bb ]
  %tmp38 = fmul fast float %tmp37, %tmp27
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %tmp49 = load float, float* undef, align 4
  %tmp60 = load float, float* undef, align 4
  %tmp12 = icmp slt i64 %indvars.iv, undef
  br i1 %tmp12, label %bb13, label %bb74

bb74:                                             ; preds = %bb13
  ret void
}

; Users that are phi nodes cannot be sunk.
define void @cannot_sink_phi(i32* %ptr) {
; CHECK-LABEL: @cannot_sink_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 1, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[FOR:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[FOR_NEXT:%.*]], [[LOOP_LATCH]] ]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i64 [[IV]], 500
; CHECK-NEXT:    br i1 [[C_1]], label [[IF_TRUEBB:%.*]], label [[IF_FALSEBB:%.*]]
; CHECK:       if.truebb:
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       if.falsebb:
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[FIRST_TIME_1:%.*]] = phi i32 [ 20, [[IF_TRUEBB]] ], [ [[FOR]], [[IF_FALSEBB]] ]
; CHECK-NEXT:    [[C_2:%.*]] = icmp ult i64 [[IV]], 800
; CHECK-NEXT:    [[FOR_NEXT]] = select i1 [[C_2]], i32 30, i32 [[FIRST_TIME_1]]
; CHECK-NEXT:    [[PTR_IDX:%.*]] = getelementptr i32, i32* [[PTR:%.*]], i64 [[IV]]
; CHECK-NEXT:    store i32 [[FOR_NEXT]], i32* [[PTR_IDX]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[EXIT:%.*]], label [[LOOP_HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:                                      ; preds = %if.end128, %for.cond108.preheader
  %iv = phi i64 [ 1, %entry ], [ %iv.next, %loop.latch ]
  %for = phi i32 [ 0, %entry ], [ %for.next, %loop.latch ]
  %c.1 = icmp ult i64 %iv, 500
  br i1 %c.1, label %if.truebb, label %if.falsebb

if.truebb:                  ; preds = %for.body114
  br label %loop.latch

if.falsebb:                                       ; preds = %for.body114
  br label %loop.latch

loop.latch:                                        ; preds = %if.then122, %for.body114.if.end128_crit_edge
  %first_time.1 = phi i32 [ 20, %if.truebb ], [ %for, %if.falsebb ]
  %c.2 = icmp ult i64 %iv, 800
  %for.next = select i1 %c.2, i32 30, i32 %first_time.1
  %ptr.idx = getelementptr i32, i32* %ptr, i64 %iv
  store i32 %for.next, i32* %ptr.idx
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond.not = icmp eq i64 %iv.next, 1000
  br i1 %exitcond.not, label %exit, label %loop.header

exit:
  ret void
}

; A recurrence in a multiple exit loop.
define i16 @multiple_exit(i16* %p, i32 %n) {
; CHECK-LABEL: @multiple_exit(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SMAX:%.*]] = call i32 @llvm.smax.i32(i32 [[N:%.*]], i32 0)
; CHECK-NEXT:    [[UMIN:%.*]] = call i32 @llvm.umin.i32(i32 [[SMAX]], i32 2096)
; CHECK-NEXT:    [[TMP0:%.*]] = add nuw nsw i32 [[UMIN]], 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ule i32 [[TMP0]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[TMP0]], 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[N_MOD_VF]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 4, i32 [[N_MOD_VF]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[TMP0]], [[TMP2]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VECTOR_RECUR:%.*]] = phi <4 x i16> [ <i16 poison, i16 poison, i16 poison, i16 0>, [[VECTOR_PH]] ], [ [[WIDE_LOAD:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = add i32 [[INDEX]], 1
; CHECK-NEXT:    [[TMP5:%.*]] = add i32 [[INDEX]], 2
; CHECK-NEXT:    [[TMP6:%.*]] = add i32 [[INDEX]], 3
; CHECK-NEXT:    [[TMP7:%.*]] = sext i32 [[TMP3]] to i64
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i16, i16* [[P:%.*]], i64 [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i16, i16* [[TMP8]], i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast i16* [[TMP9]] to <4 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD]] = load <4 x i16>, <4 x i16>* [[TMP10]], align 2
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <4 x i16> [[VECTOR_RECUR]], <4 x i16> [[WIDE_LOAD]], <4 x i32> <i32 3, i32 4, i32 5, i32 6>
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast i16* [[TMP9]] to <4 x i16>*
; CHECK-NEXT:    store <4 x i16> [[TMP11]], <4 x i16>* [[TMP12]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i32> [[VEC_IND]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[TMP13:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP13]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP6:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[TMP0]], [[N_VEC]]
; CHECK-NEXT:    [[VECTOR_RECUR_EXTRACT:%.*]] = extractelement <4 x i16> [[WIDE_LOAD]], i32 3
; CHECK-NEXT:    [[VECTOR_RECUR_EXTRACT_FOR_PHI:%.*]] = extractelement <4 x i16> [[WIDE_LOAD]], i32 2
; CHECK-NEXT:    br i1 [[CMP_N]], label [[IF_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[SCALAR_RECUR_INIT:%.*]] = phi i16 [ 0, [[ENTRY:%.*]] ], [ [[VECTOR_RECUR_EXTRACT]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY]] ]
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INC:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[SCALAR_RECUR:%.*]] = phi i16 [ [[SCALAR_RECUR_INIT]], [[SCALAR_PH]] ], [ [[REC_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[IPROM:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[B:%.*]] = getelementptr inbounds i16, i16* [[P]], i64 [[IPROM]]
; CHECK-NEXT:    [[REC_NEXT]] = load i16, i16* [[B]], align 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I]], [[N]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[IF_END]]
; CHECK:       for.body:
; CHECK-NEXT:    store i16 [[SCALAR_RECUR]], i16* [[B]], align 4
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[I]], 2096
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_COND]], label [[IF_END]], [[LOOP7:!llvm.loop !.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[REC_LCSSA:%.*]] = phi i16 [ [[SCALAR_RECUR]], [[FOR_BODY]] ], [ [[SCALAR_RECUR]], [[FOR_COND]] ], [ [[VECTOR_RECUR_EXTRACT_FOR_PHI]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    ret i16 [[REC_LCSSA]]
;
entry:
  br label %for.cond

for.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %rec = phi i16 [0, %entry], [ %rec.next, %for.body ]
  %iprom = sext i32 %i to i64
  %b = getelementptr inbounds i16, i16* %p, i64 %iprom
  %rec.next = load i16, i16* %b
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %for.body, label %if.end

for.body:
  store i16 %rec , i16* %b, align 4
  %inc = add nsw i32 %i, 1
  %cmp2 = icmp slt i32 %i, 2096
  br i1 %cmp2, label %for.cond, label %if.end

if.end:
  ret i16 %rec
}


; A multiple exit case where one of the exiting edges involves a value
; from the recurrence and one does not.
define i16 @multiple_exit2(i16* %p, i32 %n) {
; CHECK-LABEL: @multiple_exit2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SMAX:%.*]] = call i32 @llvm.smax.i32(i32 [[N:%.*]], i32 0)
; CHECK-NEXT:    [[UMIN:%.*]] = call i32 @llvm.umin.i32(i32 [[SMAX]], i32 2096)
; CHECK-NEXT:    [[TMP0:%.*]] = add nuw nsw i32 [[UMIN]], 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ule i32 [[TMP0]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[TMP0]], 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[N_MOD_VF]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 4, i32 [[N_MOD_VF]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[TMP0]], [[TMP2]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VECTOR_RECUR:%.*]] = phi <4 x i16> [ <i16 poison, i16 poison, i16 poison, i16 0>, [[VECTOR_PH]] ], [ [[WIDE_LOAD:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = add i32 [[INDEX]], 1
; CHECK-NEXT:    [[TMP5:%.*]] = add i32 [[INDEX]], 2
; CHECK-NEXT:    [[TMP6:%.*]] = add i32 [[INDEX]], 3
; CHECK-NEXT:    [[TMP7:%.*]] = sext i32 [[TMP3]] to i64
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i16, i16* [[P:%.*]], i64 [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i16, i16* [[TMP8]], i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast i16* [[TMP9]] to <4 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD]] = load <4 x i16>, <4 x i16>* [[TMP10]], align 2
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <4 x i16> [[VECTOR_RECUR]], <4 x i16> [[WIDE_LOAD]], <4 x i32> <i32 3, i32 4, i32 5, i32 6>
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast i16* [[TMP9]] to <4 x i16>*
; CHECK-NEXT:    store <4 x i16> [[TMP11]], <4 x i16>* [[TMP12]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i32> [[VEC_IND]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[TMP13:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP13]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP8:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[TMP0]], [[N_VEC]]
; CHECK-NEXT:    [[VECTOR_RECUR_EXTRACT:%.*]] = extractelement <4 x i16> [[WIDE_LOAD]], i32 3
; CHECK-NEXT:    [[VECTOR_RECUR_EXTRACT_FOR_PHI:%.*]] = extractelement <4 x i16> [[WIDE_LOAD]], i32 2
; CHECK-NEXT:    br i1 [[CMP_N]], label [[IF_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[SCALAR_RECUR_INIT:%.*]] = phi i16 [ 0, [[ENTRY:%.*]] ], [ [[VECTOR_RECUR_EXTRACT]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY]] ]
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INC:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[SCALAR_RECUR:%.*]] = phi i16 [ [[SCALAR_RECUR_INIT]], [[SCALAR_PH]] ], [ [[REC_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[IPROM:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[B:%.*]] = getelementptr inbounds i16, i16* [[P]], i64 [[IPROM]]
; CHECK-NEXT:    [[REC_NEXT]] = load i16, i16* [[B]], align 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I]], [[N]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[IF_END]]
; CHECK:       for.body:
; CHECK-NEXT:    store i16 [[SCALAR_RECUR]], i16* [[B]], align 4
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[I]], 2096
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_COND]], label [[IF_END]], [[LOOP9:!llvm.loop !.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[REC_LCSSA:%.*]] = phi i16 [ [[SCALAR_RECUR]], [[FOR_COND]] ], [ 10, [[FOR_BODY]] ], [ [[VECTOR_RECUR_EXTRACT_FOR_PHI]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    ret i16 [[REC_LCSSA]]
;
entry:
  br label %for.cond

for.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %rec = phi i16 [0, %entry], [ %rec.next, %for.body ]
  %iprom = sext i32 %i to i64
  %b = getelementptr inbounds i16, i16* %p, i64 %iprom
  %rec.next = load i16, i16* %b
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %for.body, label %if.end

for.body:
  store i16 %rec , i16* %b, align 4
  %inc = add nsw i32 %i, 1
  %cmp2 = icmp slt i32 %i, 2096
  br i1 %cmp2, label %for.cond, label %if.end

if.end:
  %rec.lcssa = phi i16 [ %rec, %for.cond ], [ 10, %for.body ]
  ret i16 %rec.lcssa
}

; A test where the instructions to sink may not be visited in dominance order.
define void @sink_dominance(i32* %ptr, i32 %N) {
; CHECK-LABEL: @sink_dominance(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[FOR:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[FOR_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[FOR_TRUNC:%.*]] = trunc i64 [[FOR]] to i32
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[FOR_TRUNC]], 213
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], i32 [[FOR_TRUNC]], i32 22
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i32, i32* [[PTR:%.*]], i32 [[IV]]
; CHECK-NEXT:    [[LV:%.*]] = load i32, i32* [[GEP]], align 4
; CHECK-NEXT:    [[FOR_NEXT]] = zext i32 [[LV]] to i64
; CHECK-NEXT:    store i32 [[SELECT]], i32* [[GEP]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[CMP73:%.*]] = icmp ugt i32 [[N:%.*]], [[IV_NEXT]]
; CHECK-NEXT:    br i1 [[CMP73]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %for = phi i64 [ 0, %entry ], [ %for.next, %loop ]
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %loop ]

  %for.trunc = trunc i64 %for to i32
  %cmp = icmp slt i32 %for.trunc, 213
  %select = select i1 %cmp, i32 %for.trunc, i32 22

  %gep = getelementptr inbounds i32, i32* %ptr, i32 %iv
  %lv = load i32, i32* %gep, align 4
  %for.next = zext i32 %lv to i64
  store i32 %select, i32* %gep

  %iv.next = add i32 %iv, 1
  %cmp73 = icmp ugt i32 %N, %iv.next
  br i1 %cmp73, label %loop, label %exit

exit:
  ret void
}

define void @cannot_sink_load_past_store(i32* %ptr, i32 %N) {
; CHECK-LABEL: @cannot_sink_load_past_store(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[FOR:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[FOR_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[GEP_FOR:%.*]] = getelementptr inbounds i32, i32* [[PTR:%.*]], i64 [[FOR]]
; CHECK-NEXT:    [[LV_FOR:%.*]] = load i32, i32* [[GEP_FOR]], align 4
; CHECK-NEXT:    [[FOR_TRUNC:%.*]] = trunc i64 [[FOR]] to i32
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[LV_FOR]], [[FOR_TRUNC]]
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], i32 [[LV_FOR]], i32 22
; CHECK-NEXT:    [[GEP_IV:%.*]] = getelementptr inbounds i32, i32* [[PTR]], i32 [[IV]]
; CHECK-NEXT:    store i32 0, i32* [[GEP_IV]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[FOR_NEXT]] = zext i32 [[IV]] to i64
; CHECK-NEXT:    [[CMP73:%.*]] = icmp ugt i32 [[N:%.*]], [[IV_NEXT]]
; CHECK-NEXT:    br i1 [[CMP73]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %for = phi i64 [ 0, %entry ], [ %for.next, %loop ]
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %loop ]

  %gep.for = getelementptr inbounds i32, i32* %ptr, i64 %for
  %lv.for = load i32, i32* %gep.for, align 4
  %for.trunc = trunc i64 %for to i32
  %cmp = icmp slt i32 %lv.for, %for.trunc
  %select = select i1 %cmp, i32 %lv.for, i32 22

  %gep.iv = getelementptr inbounds i32, i32* %ptr, i32 %iv
  store i32 0, i32* %gep.iv
  %iv.next = add i32 %iv, 1
  %for.next = zext i32 %iv to i64

  %cmp73 = icmp ugt i32 %N, %iv.next
  br i1 %cmp73, label %loop, label %exit

exit:
  ret void
}
