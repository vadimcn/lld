; Verify that multually dependant object files in an archive is handled
; correctly.
;
; RUN: llc -filetype=obj -mtriple=wasm32-unknown-uknown-wasm %s -o %t.o
; RUN: llc -filetype=obj -mtriple=wasm32-unknown-uknown-wasm %S/Inputs/archive1.ll -o %t2.o
; RUN: llc -filetype=obj -mtriple=wasm32-unknown-uknown-wasm %S/Inputs/archive2.ll -o %t3.o
; RUN: llvm-ar rcs %t.a %t2.o %t3.o
; RUN: lld -flavor wasm %t.a %t.o -o %t.wasm
; RUN: llvm-nm -a %t.wasm | FileCheck %s

declare i32 @foo() local_unnamed_addr #1

define i32 @_start() local_unnamed_addr #0 {
entry:
  %call = tail call i32 @foo() #2
  ret i32 %call
}

; CHECK: t _start
; CHECK: t bar
; CHECK: t foo
; CHECK: T main