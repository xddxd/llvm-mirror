; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -iroutliner < %s | FileCheck %s

; These functions are constructed slightly differently so that they require
; different output blocks for the values used outside of the region. We are
; checking that two output blocks are created with different values.

define void @outline_outputs1() #0 {
; CHECK-LABEL: @outline_outputs1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTLOC:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[ADD_LOC:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[OUTPUT:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[RESULT:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[LT_CAST:%.*]] = bitcast i32* [[ADD_LOC]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    [[LT_CAST1:%.*]] = bitcast i32* [[DOTLOC]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST1]])
; CHECK-NEXT:    call void @outlined_ir_func_0(i32* [[A]], i32* [[B]], i32* [[OUTPUT]], i32* [[ADD_LOC]], i32* [[DOTLOC]], i32 0)
; CHECK-NEXT:    [[ADD_RELOAD:%.*]] = load i32, i32* [[ADD_LOC]], align 4
; CHECK-NEXT:    [[DOTRELOAD:%.*]] = load i32, i32* [[DOTLOC]], align 4
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST1]])
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[OUTPUT]], align 4
; CHECK-NEXT:    call void @outlined_ir_func_1(i32 [[DOTRELOAD]], i32 [[ADD_RELOAD]], i32* [[RESULT]])
; CHECK-NEXT:    ret void
;
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %output = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 2, i32* %a, align 4
  store i32 3, i32* %b, align 4
  %0 = load i32, i32* %a, align 4
  %1 = load i32, i32* %b, align 4
  %add = add i32 %0, %1
  %sub = sub i32 %0, %1
  store i32 %add, i32* %output, align 4
  %2 = load i32, i32* %output, align 4
  %3 = load i32, i32* %output, align 4
  %mul = mul i32 %2, %add
  store i32 %mul, i32* %result, align 4
  ret void
}

define void @outline_outputs2() #0 {
; CHECK-LABEL: @outline_outputs2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTLOC:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[SUB_LOC:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[OUTPUT:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[RESULT:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[LT_CAST:%.*]] = bitcast i32* [[SUB_LOC]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    [[LT_CAST1:%.*]] = bitcast i32* [[DOTLOC]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST1]])
; CHECK-NEXT:    call void @outlined_ir_func_0(i32* [[A]], i32* [[B]], i32* [[OUTPUT]], i32* [[SUB_LOC]], i32* [[DOTLOC]], i32 1)
; CHECK-NEXT:    [[SUB_RELOAD:%.*]] = load i32, i32* [[SUB_LOC]], align 4
; CHECK-NEXT:    [[DOTRELOAD:%.*]] = load i32, i32* [[DOTLOC]], align 4
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST1]])
; CHECK-NEXT:    call void @outlined_ir_func_1(i32 [[DOTRELOAD]], i32 [[SUB_RELOAD]], i32* [[RESULT]])
; CHECK-NEXT:    ret void
;
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %output = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 2, i32* %a, align 4
  store i32 3, i32* %b, align 4
  %0 = load i32, i32* %a, align 4
  %1 = load i32, i32* %b, align 4
  %add = add i32 %0, %1
  %sub = sub i32 %0, %1
  store i32 %add, i32* %output, align 4
  %2 = load i32, i32* %output, align 4
  %mul = mul i32 %2, %sub
  store i32 %mul, i32* %result, align 4
  ret void
}

; CHECK: define internal void @outlined_ir_func_0(i32* [[ARG0:%.*]], i32* [[ARG1:%.*]], i32* [[ARG2:%.*]], i32* [[ARG3:%.*]], i32* [[ARG4:%.*]], i32 [[ARG5:%.*]]) #1 {
; CHECK: _after_outline.exitStub:
; CHECK-NEXT:    switch i32 [[ARG5]], label [[BLOCK:%.*]] [
; CHECK-NEXT:      i32 0, label %[[BLOCK_0:.*]]
; CHECK-NEXT:      i32 1, label %[[BLOCK_1:.*]]

; CHECK: entry_to_outline:
; CHECK-NEXT:    store i32 2, i32* [[ARG0]], align 4
; CHECK-NEXT:    store i32 3, i32* [[ARG1]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[ARG0]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[ARG1]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[TMP0]], [[TMP1]]
; CHECK-NEXT:    store i32 [[ADD]], i32* [[ARG2]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[ARG2]], align 4

; CHECK: [[BLOCK_0]]:
; CHECK-NEXT:    store i32 [[ADD]], i32* [[ARG3]], align 4
; CHECK-NEXT:    store i32 [[TMP2]], i32* [[ARG4]], align 4

; CHECK: [[BLOCK_1]]:
; CHECK-NEXT:    store i32 [[SUB]], i32* [[ARG3]], align 4
; CHECK-NEXT:    store i32 [[TMP2]], i32* [[ARG4]], align 4
