; RUN: llvm-as < %s | llc -mtriple=powerpc64-apple-darwin9 -o - | grep memcpy

@C.0.1173 = external constant [33 x i8]         ; <[33 x i8]*> [#uses=1]

define void @Bork() {
entry:
        %Qux = alloca [33 x i8]         ; <[33 x i8]*> [#uses=1]
        %Qux1 = bitcast [33 x i8]* %Qux to i8*          ; <i8*> [#uses=1]
        call void @llvm.memcpy.i64( i8* %Qux1, i8* getelementptr ([33 x i8]* @C.0.1173, i32 0, i32 0), i64 33, i32 8 )
        ret void
}

declare void @llvm.memcpy.i64(i8*, i8*, i64, i32)
