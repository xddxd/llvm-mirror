; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=19 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=19 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

define dso_local i32 @visible(i32* noalias %A, i32* noalias %B) #0 {
; IS__TUNIT____: Function Attrs: argmemonly nofree noinline nosync nounwind readonly uwtable willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@visible
; IS__TUNIT____-SAME: (i32* noalias nocapture nofree readonly [[A:%.*]], i32* noalias nocapture nofree readonly [[B:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[CALL1:%.*]] = call i32 @noalias_args(i32* noalias nocapture nofree readonly align 4 [[A]], i32* noalias nocapture nofree readonly align 4 [[B]]) #[[ATTR3:[0-9]+]]
; IS__TUNIT____-NEXT:    [[CALL2:%.*]] = call i32 @noalias_args_argmem(i32* noalias nocapture nofree readonly align 4 [[A]], i32* noalias nocapture nofree readonly align 4 [[B]]) #[[ATTR3]]
; IS__TUNIT____-NEXT:    [[ADD:%.*]] = add nsw i32 [[CALL1]], [[CALL2]]
; IS__TUNIT____-NEXT:    ret i32 [[ADD]]
;
; IS__CGSCC_OPM: Function Attrs: argmemonly nofree noinline norecurse nosync nounwind readonly uwtable willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@visible
; IS__CGSCC_OPM-SAME: (i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    [[CALL1:%.*]] = call i32 @noalias_args(i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR3:[0-9]+]]
; IS__CGSCC_OPM-NEXT:    [[CALL2:%.*]] = call i32 @noalias_args_argmem(i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR3]]
; IS__CGSCC_OPM-NEXT:    [[ADD:%.*]] = add nsw i32 [[CALL1]], [[CALL2]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[ADD]]
;
; IS__CGSCC_NPM: Function Attrs: argmemonly nofree noinline norecurse nosync nounwind readonly uwtable willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@visible
; IS__CGSCC_NPM-SAME: (i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    [[CALL1:%.*]] = call i32 @noalias_args(i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR4:[0-9]+]]
; IS__CGSCC_NPM-NEXT:    [[CALL2:%.*]] = call i32 @noalias_args_argmem(i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR4]]
; IS__CGSCC_NPM-NEXT:    [[ADD:%.*]] = add nsw i32 [[CALL1]], [[CALL2]]
; IS__CGSCC_NPM-NEXT:    ret i32 [[ADD]]
;
entry:
  %call1 = call i32 @noalias_args(i32* %A, i32* %B)
  %call2 = call i32 @noalias_args_argmem(i32* %A, i32* %B)
  %add = add nsw i32 %call1, %call2
  ret i32 %add
}

define private i32 @noalias_args(i32* %A, i32* %B) #0 {
; IS__TUNIT____: Function Attrs: argmemonly nofree noinline nosync nounwind readonly uwtable willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@noalias_args
; IS__TUNIT____-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B:%.*]]) #[[ATTR0]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[TMP0:%.*]] = load i32, i32* [[A]], align 4
; IS__TUNIT____-NEXT:    [[TMP1:%.*]] = load i32, i32* [[B]], align 4
; IS__TUNIT____-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP0]], [[TMP1]]
; IS__TUNIT____-NEXT:    [[CALL:%.*]] = call i32 @noalias_args_argmem(i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR3]]
; IS__TUNIT____-NEXT:    [[ADD2:%.*]] = add nsw i32 [[ADD]], [[CALL]]
; IS__TUNIT____-NEXT:    ret i32 [[ADD2]]
;
; IS__CGSCC_OPM: Function Attrs: argmemonly nofree noinline norecurse nosync nounwind readonly uwtable willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@noalias_args
; IS__CGSCC_OPM-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B:%.*]]) #[[ATTR0]] {
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    [[TMP0:%.*]] = load i32, i32* [[A]], align 4
; IS__CGSCC_OPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[B]], align 4
; IS__CGSCC_OPM-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP0]], [[TMP1]]
; IS__CGSCC_OPM-NEXT:    [[CALL:%.*]] = call i32 @noalias_args_argmem(i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR4:[0-9]+]]
; IS__CGSCC_OPM-NEXT:    [[ADD2:%.*]] = add nsw i32 [[ADD]], [[CALL]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[ADD2]]
;
; IS__CGSCC_NPM: Function Attrs: argmemonly nofree noinline norecurse nosync nounwind readonly uwtable willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@noalias_args
; IS__CGSCC_NPM-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B:%.*]]) #[[ATTR0]] {
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    [[TMP0:%.*]] = load i32, i32* [[A]], align 4
; IS__CGSCC_NPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[B]], align 4
; IS__CGSCC_NPM-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP0]], [[TMP1]]
; IS__CGSCC_NPM-NEXT:    [[CALL:%.*]] = call i32 @noalias_args_argmem(i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR5:[0-9]+]]
; IS__CGSCC_NPM-NEXT:    [[ADD2:%.*]] = add nsw i32 [[ADD]], [[CALL]]
; IS__CGSCC_NPM-NEXT:    ret i32 [[ADD2]]
;
entry:
  %0 = load i32, i32* %A, align 4
  %1 = load i32, i32* %B, align 4
  %add = add nsw i32 %0, %1
  %call = call i32 @noalias_args_argmem(i32* %A, i32* %B)
  %add2 = add nsw i32 %add, %call
  ret i32 %add2
}


define internal i32 @noalias_args_argmem(i32* %A, i32* %B) #1 {
; IS__TUNIT____: Function Attrs: argmemonly nofree noinline nosync nounwind readonly uwtable willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@noalias_args_argmem
; IS__TUNIT____-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B:%.*]]) #[[ATTR0]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[TMP0:%.*]] = load i32, i32* [[A]], align 4
; IS__TUNIT____-NEXT:    [[TMP1:%.*]] = load i32, i32* [[B]], align 4
; IS__TUNIT____-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP0]], [[TMP1]]
; IS__TUNIT____-NEXT:    ret i32 [[ADD]]
;
; IS__CGSCC____: Function Attrs: argmemonly nofree noinline norecurse nosync nounwind readonly uwtable willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@noalias_args_argmem
; IS__CGSCC____-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[TMP0:%.*]] = load i32, i32* [[A]], align 4
; IS__CGSCC____-NEXT:    [[TMP1:%.*]] = load i32, i32* [[B]], align 4
; IS__CGSCC____-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP0]], [[TMP1]]
; IS__CGSCC____-NEXT:    ret i32 [[ADD]]
;
entry:
  %0 = load i32, i32* %A, align 4
  %1 = load i32, i32* %B, align 4
  %add = add nsw i32 %0, %1
  ret i32 %add
}

define dso_local i32 @visible_local(i32* %A) #0 {
; IS__TUNIT____: Function Attrs: argmemonly nofree noinline nosync nounwind uwtable willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@visible_local
; IS__TUNIT____-SAME: (i32* nocapture nofree readonly [[A:%.*]]) #[[ATTR1:[0-9]+]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__TUNIT____-NEXT:    store i32 5, i32* [[B]], align 4
; IS__TUNIT____-NEXT:    [[CALL1:%.*]] = call i32 @noalias_args(i32* nocapture nofree readonly align 4 [[A]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR3]]
; IS__TUNIT____-NEXT:    [[CALL2:%.*]] = call i32 @noalias_args_argmem(i32* nocapture nofree readonly align 4 [[A]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR3]]
; IS__TUNIT____-NEXT:    [[ADD:%.*]] = add nsw i32 [[CALL1]], [[CALL2]]
; IS__TUNIT____-NEXT:    ret i32 [[ADD]]
;
; IS__CGSCC_OPM: Function Attrs: argmemonly nofree noinline norecurse nosync nounwind uwtable willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@visible_local
; IS__CGSCC_OPM-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]]) #[[ATTR1:[0-9]+]] {
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__CGSCC_OPM-NEXT:    store i32 5, i32* [[B]], align 4
; IS__CGSCC_OPM-NEXT:    [[CALL1:%.*]] = call i32 @noalias_args(i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR4]]
; IS__CGSCC_OPM-NEXT:    [[CALL2:%.*]] = call i32 @noalias_args_argmem(i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR4]]
; IS__CGSCC_OPM-NEXT:    [[ADD:%.*]] = add nsw i32 [[CALL1]], [[CALL2]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[ADD]]
;
; IS__CGSCC_NPM: Function Attrs: argmemonly nofree noinline norecurse nosync nounwind uwtable willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@visible_local
; IS__CGSCC_NPM-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]]) #[[ATTR1:[0-9]+]] {
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__CGSCC_NPM-NEXT:    store i32 5, i32* [[B]], align 4
; IS__CGSCC_NPM-NEXT:    [[CALL1:%.*]] = call i32 @noalias_args(i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR5]]
; IS__CGSCC_NPM-NEXT:    [[CALL2:%.*]] = call i32 @noalias_args_argmem(i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR5]]
; IS__CGSCC_NPM-NEXT:    [[ADD:%.*]] = add nsw i32 [[CALL1]], [[CALL2]]
; IS__CGSCC_NPM-NEXT:    ret i32 [[ADD]]
;
entry:
  %B = alloca i32, align 4
  store i32 5, i32* %B, align 4
  %call1 = call i32 @noalias_args(i32* %A, i32* nonnull %B)
  %call2 = call i32 @noalias_args_argmem(i32* %A, i32* nonnull %B)
  %add = add nsw i32 %call1, %call2
  ret i32 %add
}

define internal i32 @noalias_args_argmem_ro(i32* %A, i32* %B) #1 {
; IS__TUNIT_OPM: Function Attrs: argmemonly nofree noinline nosync nounwind readonly uwtable willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@noalias_args_argmem_ro
; IS__TUNIT_OPM-SAME: (i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B:%.*]]) #[[ATTR0]] {
; IS__TUNIT_OPM-NEXT:    [[T0:%.*]] = load i32, i32* [[A]], align 4
; IS__TUNIT_OPM-NEXT:    [[T1:%.*]] = load i32, i32* [[B]], align 4
; IS__TUNIT_OPM-NEXT:    [[ADD:%.*]] = add nsw i32 [[T0]], [[T1]]
; IS__TUNIT_OPM-NEXT:    ret i32 [[ADD]]
;
; IS__TUNIT_NPM: Function Attrs: argmemonly nofree noinline nosync nounwind readonly uwtable willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@noalias_args_argmem_ro
; IS__TUNIT_NPM-SAME: (i32 [[TMP0:%.*]], i32 [[TMP1:%.*]]) #[[ATTR0]] {
; IS__TUNIT_NPM-NEXT:    [[B_PRIV:%.*]] = alloca i32, align 4
; IS__TUNIT_NPM-NEXT:    store i32 [[TMP1]], i32* [[B_PRIV]], align 4
; IS__TUNIT_NPM-NEXT:    [[A_PRIV:%.*]] = alloca i32, align 4
; IS__TUNIT_NPM-NEXT:    store i32 [[TMP0]], i32* [[A_PRIV]], align 4
; IS__TUNIT_NPM-NEXT:    [[T0:%.*]] = load i32, i32* [[A_PRIV]], align 4
; IS__TUNIT_NPM-NEXT:    [[T1:%.*]] = load i32, i32* [[B_PRIV]], align 4
; IS__TUNIT_NPM-NEXT:    [[ADD:%.*]] = add nsw i32 [[T0]], [[T1]]
; IS__TUNIT_NPM-NEXT:    ret i32 [[ADD]]
;
; IS__CGSCC_OPM: Function Attrs: argmemonly nofree noinline norecurse nosync nounwind readonly uwtable willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@noalias_args_argmem_ro
; IS__CGSCC_OPM-SAME: (i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B:%.*]]) #[[ATTR0]] {
; IS__CGSCC_OPM-NEXT:    [[T0:%.*]] = load i32, i32* [[A]], align 4
; IS__CGSCC_OPM-NEXT:    [[T1:%.*]] = load i32, i32* [[B]], align 4
; IS__CGSCC_OPM-NEXT:    [[ADD:%.*]] = add nsw i32 [[T0]], [[T1]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[ADD]]
;
; IS__CGSCC_NPM: Function Attrs: nofree noinline norecurse nosync nounwind readnone uwtable willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@noalias_args_argmem_ro
; IS__CGSCC_NPM-SAME: (i32 [[TMP0:%.*]], i32 [[TMP1:%.*]]) #[[ATTR2:[0-9]+]] {
; IS__CGSCC_NPM-NEXT:    [[B_PRIV:%.*]] = alloca i32, align 4
; IS__CGSCC_NPM-NEXT:    store i32 5, i32* [[B_PRIV]], align 4
; IS__CGSCC_NPM-NEXT:    [[A_PRIV:%.*]] = alloca i32, align 4
; IS__CGSCC_NPM-NEXT:    store i32 5, i32* [[A_PRIV]], align 4
; IS__CGSCC_NPM-NEXT:    [[T0:%.*]] = load i32, i32* [[A_PRIV]], align 4
; IS__CGSCC_NPM-NEXT:    [[T1:%.*]] = load i32, i32* [[B_PRIV]], align 4
; IS__CGSCC_NPM-NEXT:    [[ADD:%.*]] = add nsw i32 [[T0]], [[T1]]
; IS__CGSCC_NPM-NEXT:    ret i32 [[ADD]]
;
  %t0 = load i32, i32* %A, align 4
  %t1 = load i32, i32* %B, align 4
  %add = add nsw i32 %t0, %t1
  ret i32 %add
}

define i32 @visible_local_2() {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@visible_local_2
; IS__TUNIT_OPM-SAME: () #[[ATTR2:[0-9]+]] {
; IS__TUNIT_OPM-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__TUNIT_OPM-NEXT:    store i32 5, i32* [[B]], align 4
; IS__TUNIT_OPM-NEXT:    [[CALL:%.*]] = call i32 @noalias_args_argmem_ro(i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR4:[0-9]+]]
; IS__TUNIT_OPM-NEXT:    ret i32 [[CALL]]
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@visible_local_2
; IS__TUNIT_NPM-SAME: () #[[ATTR2:[0-9]+]] {
; IS__TUNIT_NPM-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__TUNIT_NPM-NEXT:    store i32 5, i32* [[B]], align 4
; IS__TUNIT_NPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[B]], align 4
; IS__TUNIT_NPM-NEXT:    [[TMP2:%.*]] = load i32, i32* [[B]], align 4
; IS__TUNIT_NPM-NEXT:    [[CALL:%.*]] = call i32 @noalias_args_argmem_ro(i32 [[TMP1]], i32 [[TMP2]]) #[[ATTR4:[0-9]+]]
; IS__TUNIT_NPM-NEXT:    ret i32 [[CALL]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@visible_local_2
; IS__CGSCC_OPM-SAME: () #[[ATTR2:[0-9]+]] {
; IS__CGSCC_OPM-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__CGSCC_OPM-NEXT:    store i32 5, i32* [[B]], align 4
; IS__CGSCC_OPM-NEXT:    [[CALL:%.*]] = call i32 @noalias_args_argmem_ro(i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR5:[0-9]+]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[CALL]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@visible_local_2
; IS__CGSCC_NPM-SAME: () #[[ATTR3:[0-9]+]] {
; IS__CGSCC_NPM-NEXT:    [[CALL:%.*]] = call i32 @noalias_args_argmem_ro(i32 undef, i32 undef) #[[ATTR6:[0-9]+]]
; IS__CGSCC_NPM-NEXT:    ret i32 [[CALL]]
;
  %B = alloca i32, align 4
  store i32 5, i32* %B, align 4
  %call = call i32 @noalias_args_argmem_ro(i32* %B, i32* %B)
  ret i32 %call
}

define internal i32 @noalias_args_argmem_rn(i32* %A, i32* %B) #1 {
; IS__TUNIT____: Function Attrs: argmemonly nofree noinline nosync nounwind uwtable willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@noalias_args_argmem_rn
; IS__TUNIT____-SAME: (i32* noalias nocapture nofree noundef nonnull align 4 dereferenceable(4) [[B:%.*]]) #[[ATTR1]] {
; IS__TUNIT____-NEXT:    [[T0:%.*]] = load i32, i32* [[B]], align 4
; IS__TUNIT____-NEXT:    store i32 0, i32* [[B]], align 4
; IS__TUNIT____-NEXT:    ret i32 [[T0]]
;
; IS__CGSCC____: Function Attrs: argmemonly nofree noinline norecurse nosync nounwind uwtable willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@noalias_args_argmem_rn
; IS__CGSCC____-SAME: (i32* noalias nocapture nofree noundef nonnull align 4 dereferenceable(4) [[B:%.*]]) #[[ATTR1:[0-9]+]] {
; IS__CGSCC____-NEXT:    [[T0:%.*]] = load i32, i32* [[B]], align 4
; IS__CGSCC____-NEXT:    store i32 0, i32* [[B]], align 4
; IS__CGSCC____-NEXT:    ret i32 [[T0]]
;
  %t0 = load i32, i32* %B, align 4
  store i32 0, i32* %B
  ret i32 %t0
}

define i32 @visible_local_3() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@visible_local_3
; IS__TUNIT____-SAME: () #[[ATTR2:[0-9]+]] {
; IS__TUNIT____-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__TUNIT____-NEXT:    store i32 5, i32* [[B]], align 4
; IS__TUNIT____-NEXT:    [[CALL:%.*]] = call i32 @noalias_args_argmem_rn(i32* noalias nocapture nofree noundef nonnull align 4 dereferenceable(4) [[B]]) #[[ATTR5:[0-9]+]]
; IS__TUNIT____-NEXT:    ret i32 [[CALL]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@visible_local_3
; IS__CGSCC_OPM-SAME: () #[[ATTR2]] {
; IS__CGSCC_OPM-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__CGSCC_OPM-NEXT:    store i32 5, i32* [[B]], align 4
; IS__CGSCC_OPM-NEXT:    [[CALL:%.*]] = call i32 @noalias_args_argmem_rn(i32* noalias nocapture nofree noundef nonnull align 4 dereferenceable(4) [[B]]) #[[ATTR6:[0-9]+]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[CALL]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@visible_local_3
; IS__CGSCC_NPM-SAME: () #[[ATTR3]] {
; IS__CGSCC_NPM-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__CGSCC_NPM-NEXT:    store i32 5, i32* [[B]], align 4
; IS__CGSCC_NPM-NEXT:    [[CALL:%.*]] = call i32 @noalias_args_argmem_rn(i32* noalias nocapture nofree noundef nonnull align 4 dereferenceable(4) [[B]]) #[[ATTR7:[0-9]+]]
; IS__CGSCC_NPM-NEXT:    ret i32 [[CALL]]
;
  %B = alloca i32, align 4
  store i32 5, i32* %B, align 4
  %call = call i32 @noalias_args_argmem_rn(i32* %B, i32* %B)
  ret i32 %call
}

attributes #0 = { noinline nounwind uwtable willreturn }
attributes #1 = { argmemonly noinline nounwind uwtable willreturn}
;.
; IS__TUNIT____: attributes #[[ATTR0]] = { argmemonly nofree noinline nosync nounwind readonly uwtable willreturn }
; IS__TUNIT____: attributes #[[ATTR1]] = { argmemonly nofree noinline nosync nounwind uwtable willreturn }
; IS__TUNIT____: attributes #[[ATTR2]] = { nofree nosync nounwind readnone willreturn }
; IS__TUNIT____: attributes #[[ATTR3]] = { nofree nosync nounwind readonly }
; IS__TUNIT____: attributes #[[ATTR4:[0-9]+]] = { nofree nosync nounwind readonly willreturn }
; IS__TUNIT____: attributes #[[ATTR5]] = { nofree nosync nounwind willreturn }
;.
; IS__CGSCC_OPM: attributes #[[ATTR0]] = { argmemonly nofree noinline norecurse nosync nounwind readonly uwtable willreturn }
; IS__CGSCC_OPM: attributes #[[ATTR1]] = { argmemonly nofree noinline norecurse nosync nounwind uwtable willreturn }
; IS__CGSCC_OPM: attributes #[[ATTR2]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC_OPM: attributes #[[ATTR3]] = { nounwind readonly }
; IS__CGSCC_OPM: attributes #[[ATTR4]] = { nosync nounwind readonly }
; IS__CGSCC_OPM: attributes #[[ATTR5]] = { nounwind readonly willreturn }
; IS__CGSCC_OPM: attributes #[[ATTR6]] = { nounwind willreturn }
;.
; IS__CGSCC_NPM: attributes #[[ATTR0]] = { argmemonly nofree noinline norecurse nosync nounwind readonly uwtable willreturn }
; IS__CGSCC_NPM: attributes #[[ATTR1]] = { argmemonly nofree noinline norecurse nosync nounwind uwtable willreturn }
; IS__CGSCC_NPM: attributes #[[ATTR2]] = { nofree noinline norecurse nosync nounwind readnone uwtable willreturn }
; IS__CGSCC_NPM: attributes #[[ATTR3]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC_NPM: attributes #[[ATTR4]] = { nounwind readonly }
; IS__CGSCC_NPM: attributes #[[ATTR5]] = { nosync nounwind readonly }
; IS__CGSCC_NPM: attributes #[[ATTR6]] = { nounwind readnone willreturn }
; IS__CGSCC_NPM: attributes #[[ATTR7]] = { nounwind willreturn }
;.
