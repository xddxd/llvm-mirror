; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -bonus-inst-threshold=10 | FileCheck %s

declare void @sideeffect0()
declare void @sideeffect1()
declare void @sideeffect2()
declare void @use8(i8)
declare i1 @gen1()
declare i32 @speculate_call(i32 *) #0

; Basic cases, blocks have nothing other than the comparison itself.

define void @one_pred(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C0]], i1 [[C1]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
pred:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %dispatch, label %final_right
dispatch:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @two_preds(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; CHECK-LABEL: @two_preds(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    [[C3_OLD:%.*]] = icmp eq i8 [[V3:%.*]], 0
; CHECK-NEXT:    [[OR_COND1:%.*]] = select i1 [[C1]], i1 true, i1 [[C3_OLD]]
; CHECK-NEXT:    br i1 [[OR_COND1]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C2]], i1 [[C3]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %c3 = icmp eq i8 %v3, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

; More complex case, there's an extra op that is safe to execute unconditionally.

define void @one_pred_with_extra_op(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred_with_extra_op(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    [[V1_ADJ:%.*]] = add i8 [[V0]], [[V1:%.*]]
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C0]], i1 [[C1]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
pred:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %dispatch, label %final_right
dispatch:
  %v1_adj = add i8 %v0, %v1
  %c1 = icmp eq i8 %v1_adj, 0
  br i1 %c1, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

; When we fold the dispatch block into pred, the call is moved to pred
; and the attribute nonnull propagates poison paramater. However, since the
; function is speculatable, it can never cause UB. So, we need not technically drop it.
define void @one_pred_with_spec_call(i8 %v0, i8 %v1, i32* %p) {
; CHECK-LABEL: @one_pred_with_spec_call(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp ne i32* [[P:%.*]], null
; CHECK-NEXT:    [[X:%.*]] = call i32 @speculate_call(i32* nonnull [[P]])
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C0]], i1 [[C1]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[COMMON_RET:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[COMMON_RET]]
pred:
  %c0 = icmp ne i32* %p, null
  br i1 %c0, label %dispatch, label %final_right

dispatch:
  %x = call i32 @speculate_call(i32* nonnull %p)
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %final_right

final_left:
  ret void

final_right:
  call void @sideeffect0()
  ret void
}

; Drop dereferenceable on the parameter
define void @one_pred_with_spec_call_deref(i8 %v0, i8 %v1, i32* %p) {
; CHECK-LABEL: one_pred_with_spec_call_deref
; CHECK-LABEL: pred:
; CHECK:         %c0 = icmp ne i32* %p, null
; CHECK:         %x = call i32 @speculate_call(i32* %p)
pred:
  %c0 = icmp ne i32* %p, null
  br i1 %c0, label %dispatch, label %final_right

dispatch:
  %x = call i32 @speculate_call(i32* dereferenceable(12) %p)
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %final_right

final_left:
  ret void

final_right:
  call void @sideeffect0()
  ret void
}

define void @two_preds_with_extra_op(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; CHECK-LABEL: @two_preds_with_extra_op(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    [[V3_ADJ_OLD:%.*]] = add i8 [[V1]], [[V2:%.*]]
; CHECK-NEXT:    [[C3_OLD:%.*]] = icmp eq i8 [[V3_ADJ_OLD]], 0
; CHECK-NEXT:    [[OR_COND1:%.*]] = select i1 [[C1]], i1 true, i1 [[C3_OLD]]
; CHECK-NEXT:    br i1 [[OR_COND1]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2]], 0
; CHECK-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C2]], i1 [[C3]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %v3_adj = add i8 %v1, %v2
  %c3 = icmp eq i8 %v3_adj, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

; More complex case, there's an extra op that is safe to execute unconditionally, and it has multiple uses.

define void @one_pred_with_extra_op_multiuse(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred_with_extra_op_multiuse(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    [[V1_ADJ:%.*]] = add i8 [[V0]], [[V1:%.*]]
; CHECK-NEXT:    [[V1_ADJ_ADJ:%.*]] = add i8 [[V1_ADJ]], [[V1_ADJ]]
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1_ADJ_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C0]], i1 [[C1]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
pred:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %dispatch, label %final_right
dispatch:
  %v1_adj = add i8 %v0, %v1
  %v1_adj_adj = add i8 %v1_adj, %v1_adj
  %c1 = icmp eq i8 %v1_adj_adj, 0
  br i1 %c1, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @two_preds_with_extra_op_multiuse(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; CHECK-LABEL: @two_preds_with_extra_op_multiuse(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    [[V3_ADJ_OLD:%.*]] = add i8 [[V1]], [[V2:%.*]]
; CHECK-NEXT:    [[V3_ADJ_ADJ_OLD:%.*]] = add i8 [[V3_ADJ_OLD]], [[V3_ADJ_OLD]]
; CHECK-NEXT:    [[C3_OLD:%.*]] = icmp eq i8 [[V3_ADJ_ADJ_OLD]], 0
; CHECK-NEXT:    [[OR_COND1:%.*]] = select i1 [[C1]], i1 true, i1 [[C3_OLD]]
; CHECK-NEXT:    br i1 [[OR_COND1]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2]], 0
; CHECK-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[V3_ADJ_ADJ:%.*]] = add i8 [[V3_ADJ]], [[V3_ADJ]]
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3_ADJ_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C2]], i1 [[C3]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %v3_adj = add i8 %v1, %v2
  %v3_adj_adj = add i8 %v3_adj, %v3_adj
  %c3 = icmp eq i8 %v3_adj_adj, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

; More complex case, there's an op that is safe to execute unconditionally,
; and said op is live-out.

define void @one_pred_with_extra_op_liveout(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred_with_extra_op_liveout(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    [[V1_ADJ:%.*]] = add i8 [[V0]], [[V1:%.*]]
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C0]], i1 [[C1]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    call void @use8(i8 [[V1_ADJ]])
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
pred:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %dispatch, label %final_right
dispatch:
  %v1_adj = add i8 %v0, %v1
  %c1 = icmp eq i8 %v1_adj, 0
  br i1 %c1, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  call void @use8(i8 %v1_adj)
  ret void
final_right:
  call void @sideeffect1()
  ret void
}
define void @one_pred_with_extra_op_liveout_multiuse(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred_with_extra_op_liveout_multiuse(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    [[V1_ADJ:%.*]] = add i8 [[V0]], [[V1:%.*]]
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C0]], i1 [[C1]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    call void @use8(i8 [[V1_ADJ]])
; CHECK-NEXT:    call void @use8(i8 [[V1_ADJ]])
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
pred:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %dispatch, label %final_right
dispatch:
  %v1_adj = add i8 %v0, %v1
  %c1 = icmp eq i8 %v1_adj, 0
  br i1 %c1, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  call void @use8(i8 %v1_adj)
  call void @use8(i8 %v1_adj)
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @one_pred_with_extra_op_liveout_distant_phi(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred_with_extra_op_liveout_distant_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED:%.*]], label [[LEFT_END:%.*]]
; CHECK:       pred:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    [[V2_ADJ:%.*]] = add i8 [[V0]], [[V1]]
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C1]], i1 [[C2]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    call void @use8(i8 [[V2_ADJ]])
; CHECK-NEXT:    br label [[LEFT_END]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       left_end:
; CHECK-NEXT:    [[MERGE_LEFT:%.*]] = phi i8 [ [[V2_ADJ]], [[FINAL_LEFT]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT]])
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect2()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred, label %left_end
pred:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %dispatch, label %final_right
dispatch:
  %v2_adj = add i8 %v0, %v1
  %c2 = icmp eq i8 %v2_adj, 0
  br i1 %c2, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  call void @use8(i8 %v2_adj)
  br label %left_end
left_end:
  %merge_left = phi i8 [ %v2_adj, %final_left ], [ 0, %entry ]
  call void @sideeffect1()
  call void @use8(i8 %merge_left)
  ret void
final_right:
  call void @sideeffect2()
  ret void
}

define void @two_preds_with_extra_op_liveout(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; CHECK-LABEL: @two_preds_with_extra_op_liveout(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[DISPATCH:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; CHECK-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C2]], i1 [[C3]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[V3_ADJ_OLD:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[C3_OLD:%.*]] = icmp eq i8 [[V3_ADJ_OLD]], 0
; CHECK-NEXT:    br i1 [[C3_OLD]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    [[MERGE_LEFT:%.*]] = phi i8 [ [[V3_ADJ_OLD]], [[DISPATCH]] ], [ 0, [[PRED0]] ], [ [[V3_ADJ]], [[PRED1]] ]
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT]])
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %v3_adj = add i8 %v1, %v2
  %c3 = icmp eq i8 %v3_adj, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  %merge_left = phi i8 [ %v3_adj, %dispatch ], [ 0, %pred0 ]
  call void @use8(i8 %merge_left)
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @two_preds_with_extra_op_liveout_multiuse(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; CHECK-LABEL: @two_preds_with_extra_op_liveout_multiuse(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[DISPATCH:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; CHECK-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C2]], i1 [[C3]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[V3_ADJ_OLD:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[C3_OLD:%.*]] = icmp eq i8 [[V3_ADJ_OLD]], 0
; CHECK-NEXT:    br i1 [[C3_OLD]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    [[MERGE_LEFT:%.*]] = phi i8 [ [[V3_ADJ_OLD]], [[DISPATCH]] ], [ 0, [[PRED0]] ], [ [[V3_ADJ]], [[PRED1]] ]
; CHECK-NEXT:    [[MERGE_LEFT_2:%.*]] = phi i8 [ [[V3_ADJ_OLD]], [[DISPATCH]] ], [ 42, [[PRED0]] ], [ [[V3_ADJ]], [[PRED1]] ]
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT]])
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT_2]])
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %v3_adj = add i8 %v1, %v2
  %c3 = icmp eq i8 %v3_adj, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  %merge_left = phi i8 [ %v3_adj, %dispatch ], [ 0, %pred0 ]
  %merge_left_2 = phi i8 [ %v3_adj, %dispatch ], [ 42, %pred0 ]
  call void @use8(i8 %merge_left)
  call void @use8(i8 %merge_left_2)
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

; More complex case, there's an op that is safe to execute unconditionally,
; and said op is live-out, and it is only used externally.

define void @one_pred_with_extra_op_eexternally_used_only(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred_with_extra_op_eexternally_used_only(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    [[V1_ADJ:%.*]] = add i8 [[V0]], [[V1:%.*]]
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C0]], i1 [[C1]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    call void @use8(i8 [[V1_ADJ]])
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
pred:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %dispatch, label %final_right
dispatch:
  %v1_adj = add i8 %v0, %v1
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  call void @use8(i8 %v1_adj)
  ret void
final_right:
  call void @sideeffect1()
  ret void
}
define void @one_pred_with_extra_op_externally_used_only_multiuse(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred_with_extra_op_externally_used_only_multiuse(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    [[V1_ADJ:%.*]] = add i8 [[V0]], [[V1:%.*]]
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C0]], i1 [[C1]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    call void @use8(i8 [[V1_ADJ]])
; CHECK-NEXT:    call void @use8(i8 [[V1_ADJ]])
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
pred:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %dispatch, label %final_right
dispatch:
  %v1_adj = add i8 %v0, %v1
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  call void @use8(i8 %v1_adj)
  call void @use8(i8 %v1_adj)
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @two_preds_with_extra_op_externally_used_only(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; CHECK-LABEL: @two_preds_with_extra_op_externally_used_only(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[DISPATCH:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; CHECK-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3:%.*]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C2]], i1 [[C3]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[V3_ADJ_OLD:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[C3_OLD:%.*]] = icmp eq i8 [[V3]], 0
; CHECK-NEXT:    br i1 [[C3_OLD]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    [[MERGE_LEFT:%.*]] = phi i8 [ [[V3_ADJ_OLD]], [[DISPATCH]] ], [ 0, [[PRED0]] ], [ [[V3_ADJ]], [[PRED1]] ]
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT]])
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %v3_adj = add i8 %v1, %v2
  %c3 = icmp eq i8 %v3, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  %merge_left = phi i8 [ %v3_adj, %dispatch ], [ 0, %pred0 ]
  call void @use8(i8 %merge_left)
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @two_preds_with_extra_op_externally_used_only_multiuse(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; CHECK-LABEL: @two_preds_with_extra_op_externally_used_only_multiuse(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[DISPATCH:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; CHECK-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3:%.*]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C2]], i1 [[C3]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[V3_ADJ_OLD:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[C3_OLD:%.*]] = icmp eq i8 [[V3]], 0
; CHECK-NEXT:    br i1 [[C3_OLD]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    [[MERGE_LEFT:%.*]] = phi i8 [ [[V3_ADJ_OLD]], [[DISPATCH]] ], [ 0, [[PRED0]] ], [ [[V3_ADJ]], [[PRED1]] ]
; CHECK-NEXT:    [[MERGE_LEFT_2:%.*]] = phi i8 [ [[V3_ADJ_OLD]], [[DISPATCH]] ], [ 42, [[PRED0]] ], [ [[V3_ADJ]], [[PRED1]] ]
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT]])
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT_2]])
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %v3_adj = add i8 %v1, %v2
  %c3 = icmp eq i8 %v3, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  %merge_left = phi i8 [ %v3_adj, %dispatch ], [ 0, %pred0 ]
  %merge_left_2 = phi i8 [ %v3_adj, %dispatch ], [ 42, %pred0 ]
  call void @use8(i8 %merge_left)
  call void @use8(i8 %merge_left_2)
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

; The liveout instruction can be located after the branch condition.
define void @one_pred_with_extra_op_externally_used_only_after_cond_distant_phi(i8 %v0, i8 %v1, i8 %v3, i8 %v4, i8 %v5) {
; CHECK-LABEL: @one_pred_with_extra_op_externally_used_only_after_cond_distant_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED:%.*]], label [[LEFT_END:%.*]]
; CHECK:       pred:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3:%.*]], 0
; CHECK-NEXT:    [[V2_ADJ:%.*]] = add i8 [[V4:%.*]], [[V5:%.*]]
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C1]], i1 [[C3]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    call void @use8(i8 [[V2_ADJ]])
; CHECK-NEXT:    br label [[LEFT_END]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       left_end:
; CHECK-NEXT:    [[MERGE_LEFT:%.*]] = phi i8 [ [[V2_ADJ]], [[FINAL_LEFT]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT]])
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect2()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred, label %left_end
pred:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %dispatch, label %final_right
dispatch:
  %c3 = icmp eq i8 %v3, 0
  %v2_adj = add i8 %v4, %v5
  br i1 %c3, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  call void @use8(i8 %v2_adj)
  br label %left_end
left_end:
  %merge_left = phi i8 [ %v2_adj, %final_left ], [ 0, %entry ]
  call void @sideeffect1()
  call void @use8(i8 %merge_left)
  ret void
final_right:
  call void @sideeffect2()
  ret void
}
define void @two_preds_with_extra_op_externally_used_only_after_cond(i8 %v0, i8 %v1, i8 %v2, i8 %v3, i8 %v4, i8 %v5) {
; CHECK-LABEL: @two_preds_with_extra_op_externally_used_only_after_cond(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[DISPATCH:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3:%.*]], 0
; CHECK-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V4:%.*]], [[V5:%.*]]
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C2]], i1 [[C3]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[C3_OLD:%.*]] = icmp eq i8 [[V3]], 0
; CHECK-NEXT:    [[V3_ADJ_OLD:%.*]] = add i8 [[V4]], [[V5]]
; CHECK-NEXT:    br i1 [[C3_OLD]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       final_left:
; CHECK-NEXT:    [[MERGE_LEFT:%.*]] = phi i8 [ [[V3_ADJ_OLD]], [[DISPATCH]] ], [ 0, [[PRED0]] ], [ [[V3_ADJ]], [[PRED1]] ]
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT]])
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[COMMON_RET:%.*]]
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %c3 = icmp eq i8 %v3, 0
  %v3_adj = add i8 %v4, %v5
  br i1 %c3, label %final_left, label %final_right
final_left:
  %merge_left = phi i8 [ %v3_adj, %dispatch ], [ 0, %pred0 ]
  call void @use8(i8 %merge_left)
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @pr48450() {
; CHECK-LABEL: @pr48450(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[COUNTDOWN:%.*]] = phi i8 [ 8, [[ENTRY:%.*]] ], [ [[DEC_MERGE:%.*]], [[FOR_BODYTHREAD_PRE_SPLIT:%.*]] ]
; CHECK-NEXT:    [[C:%.*]] = call i1 @gen1()
; CHECK-NEXT:    br i1 [[C]], label [[FOR_INC:%.*]], label [[IF_THEN:%.*]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[DEC_OLD:%.*]] = add i8 [[COUNTDOWN]], -1
; CHECK-NEXT:    [[CMP_NOT_OLD:%.*]] = icmp eq i8 [[COUNTDOWN]], 0
; CHECK-NEXT:    br i1 [[CMP_NOT_OLD]], label [[IF_END_LOOPEXIT:%.*]], label [[FOR_BODYTHREAD_PRE_SPLIT]]
; CHECK:       if.then:
; CHECK-NEXT:    [[C2:%.*]] = call i1 @gen1()
; CHECK-NEXT:    [[C2_NOT:%.*]] = xor i1 [[C2]], true
; CHECK-NEXT:    [[DEC:%.*]] = add i8 [[COUNTDOWN]], -1
; CHECK-NEXT:    [[CMP_NOT:%.*]] = icmp eq i8 [[COUNTDOWN]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C2_NOT]], i1 true, i1 [[CMP_NOT]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[IF_END_LOOPEXIT]], label [[FOR_BODYTHREAD_PRE_SPLIT]]
; CHECK:       for.bodythread-pre-split:
; CHECK-NEXT:    [[DEC_MERGE]] = phi i8 [ [[DEC]], [[IF_THEN]] ], [ [[DEC_OLD]], [[FOR_INC]] ]
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[FOR_BODY]]
; CHECK:       if.end.loopexit:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %countdown = phi i8 [ 8, %entry ], [ %dec, %for.bodythread-pre-split ]
  %c = call i1 @gen1()
  br i1 %c, label %for.inc, label %if.then

for.inc:
  %dec = add i8 %countdown, -1
  %cmp.not = icmp eq i8 %countdown, 0
  br i1 %cmp.not, label %if.end.loopexit, label %for.bodythread-pre-split

if.then:
  %c2 = call i1 @gen1()
  br i1 %c2, label %for.inc, label %if.end.loopexit

for.bodythread-pre-split:
  call void @sideeffect0()
  br label %for.body

if.end.loopexit:
  ret void
}

define void @pr48450_2(i1 %enable_loopback) {
; CHECK-LABEL: @pr48450_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[COUNTDOWN:%.*]] = phi i8 [ 8, [[ENTRY:%.*]] ], [ [[DEC_MERGE:%.*]], [[FOR_BODYTHREAD_PRE_SPLIT:%.*]] ]
; CHECK-NEXT:    [[C:%.*]] = call i1 @gen1()
; CHECK-NEXT:    br i1 [[C]], label [[FOR_INC:%.*]], label [[IF_THEN:%.*]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[DEC_OLD:%.*]] = add i8 [[COUNTDOWN]], -1
; CHECK-NEXT:    [[CMP_NOT_OLD:%.*]] = icmp eq i8 [[COUNTDOWN]], 0
; CHECK-NEXT:    br i1 [[CMP_NOT_OLD]], label [[IF_END_LOOPEXIT:%.*]], label [[FOR_BODYTHREAD_PRE_SPLIT]]
; CHECK:       if.then:
; CHECK-NEXT:    [[C2:%.*]] = call i1 @gen1()
; CHECK-NEXT:    [[C2_NOT:%.*]] = xor i1 [[C2]], true
; CHECK-NEXT:    [[DEC:%.*]] = add i8 [[COUNTDOWN]], -1
; CHECK-NEXT:    [[CMP_NOT:%.*]] = icmp eq i8 [[COUNTDOWN]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[C2_NOT]], i1 true, i1 [[CMP_NOT]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[IF_END_LOOPEXIT]], label [[FOR_BODYTHREAD_PRE_SPLIT]]
; CHECK:       for.bodythread-pre-split:
; CHECK-NEXT:    [[DEC_MERGE]] = phi i8 [ [[DEC_OLD]], [[FOR_INC]] ], [ [[DEC_MERGE]], [[FOR_BODYTHREAD_PRE_SPLIT_LOOPBACK:%.*]] ], [ [[DEC]], [[IF_THEN]] ]
; CHECK-NEXT:    [[SHOULD_LOOPBACK:%.*]] = phi i1 [ true, [[FOR_INC]] ], [ false, [[FOR_BODYTHREAD_PRE_SPLIT_LOOPBACK]] ], [ true, [[IF_THEN]] ]
; CHECK-NEXT:    [[DO_LOOPBACK:%.*]] = and i1 [[SHOULD_LOOPBACK]], [[ENABLE_LOOPBACK:%.*]]
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br i1 [[DO_LOOPBACK]], label [[FOR_BODYTHREAD_PRE_SPLIT_LOOPBACK]], label [[FOR_BODY]]
; CHECK:       for.bodythread-pre-split.loopback:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[FOR_BODYTHREAD_PRE_SPLIT]]
; CHECK:       if.end.loopexit:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %countdown = phi i8 [ 8, %entry ], [ %dec, %for.bodythread-pre-split ]
  %c = call i1 @gen1()
  br i1 %c, label %for.inc, label %if.then

for.inc:
  %dec = add i8 %countdown, -1
  %cmp.not = icmp eq i8 %countdown, 0
  br i1 %cmp.not, label %if.end.loopexit, label %for.bodythread-pre-split

if.then:
  %c2 = call i1 @gen1()
  br i1 %c2, label %for.inc, label %if.end.loopexit

for.bodythread-pre-split:
  %should_loopback = phi i1 [ 1, %for.inc ], [ 0, %for.bodythread-pre-split.loopback ]
  %do_loopback = and i1 %should_loopback, %enable_loopback
  call void @sideeffect0()
  br i1 %do_loopback, label %for.bodythread-pre-split.loopback, label %for.body

for.bodythread-pre-split.loopback:
  call void @sideeffect0()
  br label %for.bodythread-pre-split

if.end.loopexit:
  ret void
}

@f.b = external global i8, align 1
define void @pr48450_3() {
; CHECK-LABEL: @pr48450_3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND1:%.*]]
; CHECK:       for.cond1:
; CHECK-NEXT:    [[V:%.*]] = load i8, i8* @f.b, align 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[V]], 1
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    br label [[FOR_COND1]]
;
entry:
  br label %for.cond1

for.cond1:
  %v = load i8, i8* @f.b, align 1
  %cmp = icmp slt i8 %v, 1
  br i1 %cmp, label %for.body, label %for.end

for.body:
  br label %for.cond1

for.end:
  %tobool = icmp ne i8 %v, 0
  br i1 %tobool, label %if.then, label %if.end

if.then:
  unreachable

if.end:
  br label %for.cond2

for.cond2:
  %c.0 = phi i8 [ undef, %if.end ], [ %inc, %if.end7 ]
  %cmp3 = icmp slt i8 %c.0, 1
  br i1 %cmp3, label %for.body4, label %for.cond.cleanup

for.cond.cleanup:
  br label %cleanup

for.body4:
  br i1 undef, label %if.then6, label %if.end7

if.then6:
  br label %cleanup

if.end7:
  %inc = add nsw i8 %c.0, 1
  br label %for.cond2

cleanup:
  unreachable
}

@global_pr49510 = external global i16, align 1

define void @pr49510() {
; CHECK-LABEL: @pr49510(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTOLD:%.*]] = load i16, i16* @global_pr49510, align 1
; CHECK-NEXT:    [[TOBOOL_OLD:%.*]] = icmp ne i16 [[DOTOLD]], 0
; CHECK-NEXT:    br i1 [[TOBOOL_OLD]], label [[LAND_RHS:%.*]], label [[FOR_END:%.*]]
; CHECK:       land.rhs:
; CHECK-NEXT:    [[DOTMERGE:%.*]] = phi i16 [ [[TMP0:%.*]], [[LAND_RHS]] ], [ [[DOTOLD]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[DOTMERGE]], 0
; CHECK-NEXT:    [[TMP0]] = load i16, i16* @global_pr49510, align 1
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne i16 [[TMP0]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[CMP]], i1 [[TOBOOL]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[LAND_RHS]], label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:
  %0 = load i16, i16* @global_pr49510, align 1
  %tobool = icmp ne i16 %0, 0
  br i1 %tobool, label %land.rhs, label %for.end

land.rhs:
  %cmp = icmp slt i16 %0, 0
  br i1 %cmp, label %for.cond, label %for.end

for.end:
  ret void
}

; FIXME:
; This is a miscompile if we replace a phi incoming value
; with an updated loaded value *after* it was stored.

@global_pr51125 = global i32 1, align 4

define i32 @pr51125() {
; CHECK-LABEL: @pr51125(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LD_OLD:%.*]] = load i32, i32* @global_pr51125, align 4
; CHECK-NEXT:    [[ISZERO_OLD:%.*]] = icmp eq i32 [[LD_OLD]], 0
; CHECK-NEXT:    br i1 [[ISZERO_OLD]], label [[EXIT:%.*]], label [[L2:%.*]]
; CHECK:       L2:
; CHECK-NEXT:    [[LD_MERGE:%.*]] = phi i32 [ [[LD:%.*]], [[L2]] ], [ [[LD_OLD]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i32 -1, i32* @global_pr51125, align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i32 [[LD_MERGE]], -1
; CHECK-NEXT:    [[LD]] = load i32, i32* @global_pr51125, align 4
; CHECK-NEXT:    [[ISZERO:%.*]] = icmp eq i32 [[LD]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[CMP]], i1 true, i1 [[ISZERO]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[EXIT]], label [[L2]]
; CHECK:       exit:
; CHECK-NEXT:    [[R:%.*]] = phi i32 [ [[LD]], [[L2]] ], [ [[LD_OLD]], [[ENTRY]] ]
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  br label %L

L:
  %ld = load i32, i32* @global_pr51125, align 4
  %iszero = icmp eq i32 %ld, 0
  br i1 %iszero, label %exit, label %L2

L2:
  store i32 -1, i32* @global_pr51125, align 4
  %cmp = icmp eq i32 %ld, -1
  br i1 %cmp, label %L, label %exit

exit:
  %r = phi i32 [ %ld, %L2 ], [ %ld, %L ]
  ret i32 %r
}

attributes #0 = { nounwind argmemonly speculatable }
