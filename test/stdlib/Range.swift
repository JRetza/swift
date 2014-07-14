// RUN: %target-run-simple-swift | FileCheck %s

import StdlibUnittest

var RangeTestCase = TestCase("Range")

RangeTestCase.test("ReverseRange") {
  // We no longer have a ReverseRange, but we can still make sure that
  // lazy reversal works correctly.
  expectTrue(equal(lazy(0..<10).reverse(), [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]))
}

func isEquatable<E : Equatable>(e: E) {}

RangeTestCase.test("Range/Equatable") {
  let r1 = Range(start: 0, end: 0)
  let r2 = Range(start: 0, end: 1)
  isEquatable(r1)
  expectTrue(r1 == r1)
  expectFalse(r1 != r1)
  expectFalse(r1 == r2)
  expectTrue(r1 != r2)
}

// Something to test with that distinguishes debugDescription from description
struct X<T: ForwardIndexType> : ForwardIndexType, Printable, DebugPrintable {
  init(_ a: T) {
    self.a = a
  }

  func successor() -> X {
    return X(a.successor())
  }

  var description: String {
    return toString(a)
  }

  var debugDescription: String {
    return "X(\(toDebugString(a)))"
  }
  
  var a: T
}

func == <T: ForwardIndexType>(lhs: X<T>, rhs: X<T>) -> Bool {
  return lhs.a == rhs.a
}

RangeTestCase.test("Printing") {
  expectEqual("0..<10", toString(X(0)..<X(10)))
  expectEqual("Range(X(0)..<X(10))", toDebugString(Range(X(0)..<X(10))))
  
  // No separate representation for closed Ranges yet
  expectEqual("10..<42", toString(X(10)...X(41))) 
  expectEqual("Range(X(10)..<X(42))", toDebugString(Range(X(10)...X(41))))
}

RangeTestCase.test("Pattern matching") {
  let x = 0..<20
  // FIXME: These don't work yet: <rdar://problem/17668465> 
  // expectTrue(x ~= 10)
  // expectFalse(x ~= 20)
  // expectFalse(x ~= -1)
}

RangeTestCase.run()
// CHECK: {{^}}Range: All tests passed

//===---
// Misc tests.
//===---

// CHECK: testing...
println("testing...")

for i in stride(from: 1.4, through: 3.4, by: 1) { println(i) }
// CHECK-NEXT: 1.4
// CHECK-NEXT: 2.4
// CHECK-NEXT: 3.4


// <rdar://problem/17054014> map method should exist on ranges
for i in ((1...3).map {$0*2}) {
  println(i)
}
// CHECK-NEXT: 2
// CHECK-NEXT: 4
// CHECK-NEXT: 6

// CHECK-NEXT: done.
println("done.")
