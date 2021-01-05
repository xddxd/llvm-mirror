; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -inline -S %s | FileCheck %s

; readnone but may not return according to attributes.
define void @readnone_may_not_return() nounwind readnone ssp {
; CHECK-LABEL: @readnone_may_not_return(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    br label [[WHILE_BODY]]
;
entry:
  br label %while.body

while.body:
  br label %while.body
}

; readnone and guaranteed to return according to attributes.
define void @readnone_willreturn() willreturn nounwind readnone ssp {
; CHECK-LABEL: @readnone_willreturn(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret void
;
entry:
  ret void
}

; Make sure the call to @readnone is not treated as dead, because it is not
; marked as willreturn.
define void @caller_may_not_return() ssp {
; CHECK-LABEL: @caller_may_not_return(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret void
;
entry:
  call void @readnone_may_not_return()
  call void @readnone_willreturn()
  ret void
}

; @caller_willreturn is marked as willreturn, so all called functions also must
; return. All calls are dead.
define void @caller_willreturn() ssp willreturn {
; CHECK-LABEL: @caller_willreturn(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret void
;
entry:
  call void @readnone_may_not_return()
  call void @readnone_willreturn()
  ret void
}
