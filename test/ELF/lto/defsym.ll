; REQUIRES: x86
; RUN: llvm-as %s -o %t.o
; RUN: llvm-as %S/Inputs/defsym-bar.ll -o %t1.o
; RUN: ld.lld %t.o %t1.o -shared -o %t.so -defsym=bar2=bar3
; RUN: llvm-objdump -d %t.so | FileCheck %s

; Call to bar2() should not be inlined and should be routed to bar3()
; Symbol bar3 should not be eliminated

; CHECK:      foo:
; CHECK-NEXT: pushq	%rax
; CHECK-NEXT: callq
; CHECK-NEXT: callq{{.*}}<bar3>
; CHECK-NEXT: callq

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

declare void @bar1()
declare void @bar2()
declare void @bar3()

define void @foo() {
  call void @bar1()
  call void @bar2()
  call void @bar3()
  ret void
}
