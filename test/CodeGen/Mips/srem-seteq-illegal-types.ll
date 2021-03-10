; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=mips-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=MIPSEL
; RUN: llc -mtriple=mips64el-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=MIPS64EL

define i1 @test_srem_odd(i29 %X) nounwind {
; MIPSEL-LABEL: test_srem_odd:
; MIPSEL:       # %bb.0:
; MIPSEL-NEXT:    lui $1, 48986
; MIPSEL-NEXT:    ori $1, $1, 33099
; MIPSEL-NEXT:    sll $2, $4, 3
; MIPSEL-NEXT:    sra $2, $2, 3
; MIPSEL-NEXT:    mul $1, $2, $1
; MIPSEL-NEXT:    lui $2, 330
; MIPSEL-NEXT:    ori $2, $2, 64874
; MIPSEL-NEXT:    addu $1, $1, $2
; MIPSEL-NEXT:    lui $2, 661
; MIPSEL-NEXT:    ori $2, $2, 64213
; MIPSEL-NEXT:    jr $ra
; MIPSEL-NEXT:    sltu $2, $1, $2
;
; MIPS64EL-LABEL: test_srem_odd:
; MIPS64EL:       # %bb.0:
; MIPS64EL-NEXT:    lui $1, 48986
; MIPS64EL-NEXT:    ori $1, $1, 33099
; MIPS64EL-NEXT:    sll $2, $4, 0
; MIPS64EL-NEXT:    sll $2, $2, 3
; MIPS64EL-NEXT:    sra $2, $2, 3
; MIPS64EL-NEXT:    mul $1, $2, $1
; MIPS64EL-NEXT:    lui $2, 330
; MIPS64EL-NEXT:    ori $2, $2, 64874
; MIPS64EL-NEXT:    addu $1, $1, $2
; MIPS64EL-NEXT:    lui $2, 661
; MIPS64EL-NEXT:    ori $2, $2, 64213
; MIPS64EL-NEXT:    jr $ra
; MIPS64EL-NEXT:    sltu $2, $1, $2
  %srem = srem i29 %X, 99
  %cmp = icmp eq i29 %srem, 0
  ret i1 %cmp
}

define i1 @test_srem_even(i4 %X) nounwind {
; MIPSEL-LABEL: test_srem_even:
; MIPSEL:       # %bb.0:
; MIPSEL-NEXT:    lui $1, 10922
; MIPSEL-NEXT:    ori $1, $1, 43691
; MIPSEL-NEXT:    sll $2, $4, 28
; MIPSEL-NEXT:    sra $2, $2, 28
; MIPSEL-NEXT:    mult $2, $1
; MIPSEL-NEXT:    mfhi $1
; MIPSEL-NEXT:    srl $3, $1, 31
; MIPSEL-NEXT:    addu $1, $1, $3
; MIPSEL-NEXT:    addiu $3, $zero, 1
; MIPSEL-NEXT:    sll $4, $1, 1
; MIPSEL-NEXT:    sll $1, $1, 2
; MIPSEL-NEXT:    addu $1, $1, $4
; MIPSEL-NEXT:    subu $1, $2, $1
; MIPSEL-NEXT:    xor $1, $1, $3
; MIPSEL-NEXT:    jr $ra
; MIPSEL-NEXT:    sltiu $2, $1, 1
;
; MIPS64EL-LABEL: test_srem_even:
; MIPS64EL:       # %bb.0:
; MIPS64EL-NEXT:    lui $1, 10922
; MIPS64EL-NEXT:    ori $1, $1, 43691
; MIPS64EL-NEXT:    sll $2, $4, 0
; MIPS64EL-NEXT:    sll $2, $2, 28
; MIPS64EL-NEXT:    sra $2, $2, 28
; MIPS64EL-NEXT:    mult $2, $1
; MIPS64EL-NEXT:    mfhi $1
; MIPS64EL-NEXT:    addiu $3, $zero, 1
; MIPS64EL-NEXT:    srl $4, $1, 31
; MIPS64EL-NEXT:    addu $1, $1, $4
; MIPS64EL-NEXT:    sll $4, $1, 1
; MIPS64EL-NEXT:    sll $1, $1, 2
; MIPS64EL-NEXT:    addu $1, $1, $4
; MIPS64EL-NEXT:    subu $1, $2, $1
; MIPS64EL-NEXT:    xor $1, $1, $3
; MIPS64EL-NEXT:    jr $ra
; MIPS64EL-NEXT:    sltiu $2, $1, 1
  %srem = srem i4 %X, 6
  %cmp = icmp eq i4 %srem, 1
  ret i1 %cmp
}

define i1 @test_srem_pow2_setne(i6 %X) nounwind {
; MIPSEL-LABEL: test_srem_pow2_setne:
; MIPSEL:       # %bb.0:
; MIPSEL-NEXT:    sll $1, $4, 26
; MIPSEL-NEXT:    sra $1, $1, 26
; MIPSEL-NEXT:    srl $1, $1, 9
; MIPSEL-NEXT:    andi $1, $1, 3
; MIPSEL-NEXT:    addu $1, $4, $1
; MIPSEL-NEXT:    andi $1, $1, 60
; MIPSEL-NEXT:    subu $1, $4, $1
; MIPSEL-NEXT:    andi $1, $1, 63
; MIPSEL-NEXT:    jr $ra
; MIPSEL-NEXT:    sltu $2, $zero, $1
;
; MIPS64EL-LABEL: test_srem_pow2_setne:
; MIPS64EL:       # %bb.0:
; MIPS64EL-NEXT:    sll $1, $4, 0
; MIPS64EL-NEXT:    sll $2, $1, 26
; MIPS64EL-NEXT:    sra $2, $2, 26
; MIPS64EL-NEXT:    srl $2, $2, 9
; MIPS64EL-NEXT:    andi $2, $2, 3
; MIPS64EL-NEXT:    addu $2, $1, $2
; MIPS64EL-NEXT:    andi $2, $2, 60
; MIPS64EL-NEXT:    subu $1, $1, $2
; MIPS64EL-NEXT:    andi $1, $1, 63
; MIPS64EL-NEXT:    jr $ra
; MIPS64EL-NEXT:    sltu $2, $zero, $1
  %srem = srem i6 %X, 4
  %cmp = icmp ne i6 %srem, 0
  ret i1 %cmp
}

; Asserts today
; See https://bugs.llvm.org/show_bug.cgi?id=49551
; and https://bugs.llvm.org/show_bug.cgi?id=49550
; define <4 x i1> @test_srem_vec(<4 x i31> %X) nounwind {
;   %srem = srem <4 x i31> %X, <i31 9, i31 9, i31 -9, i31 -9>
;   %cmp = icmp ne <4 x i31> %srem, <i31 4, i31 -4, i31 4, i31 -4>
;   ret <4 x i1> %cmp
; }
