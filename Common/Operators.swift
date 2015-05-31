//
//  Operators.swift
//  LargeNumbers
//
//  Author: Hampus Lidin
//

/*-------- Comparators --------*/

// Equals
public func ==   (lhs: LInt, rhs: LInt) -> Bool {
  return lhs.equals(rhs)
}

public func ==   <C: IntegerType>(lhs: LInt, rhs: C) -> Bool {
  return lhs == LInt(rhs)
}

public func ==   <C: FloatingPointType>(lhs: LInt, rhs: C) -> Bool {
  return lhs == LInt(rhs)
}

public func ==   <C: IntegerType>(lhs: C, rhs: LInt) -> Bool {
  return rhs == lhs
}

public func ==   <C: FloatingPointType>(lhs: C, rhs: LInt) -> Bool {
  return rhs == lhs
}

// Lesser than
public func <    (lhs: LInt, rhs: LInt) -> Bool {
  return lhs.lt(rhs)
}

public func <    <C: IntegerType>(lhs: LInt, rhs: C) -> Bool {
  return lhs < LInt(rhs)
}

public func <    <C: FloatingPointType>(lhs: LInt, rhs: C) -> Bool {
  return lhs < LInt(rhs)
}

public func <    <C: IntegerType>(lhs: C, rhs: LInt) -> Bool {
  return rhs < lhs
}

public func <    <C: FloatingPointType>(lhs: C, rhs: LInt) -> Bool {
  return rhs < lhs
}

/*-------- Addition --------*/
// Add
public func +    (lhs: LInt, rhs: LInt) -> LInt {
  return LInt.add(lhs, rhs)
}

public func +    <C: IntegerType>(lhs: LInt, rhs: C) -> LInt {
  return lhs + LInt(rhs)
}

public func +    <C: FloatingPointType>(lhs: LInt, rhs: C) -> LInt {
  return lhs + LInt(rhs)
}

public func +    <C: IntegerType>(lhs: C, rhs: LInt) -> LInt {
  return rhs + lhs
}

public func +    <C: FloatingPointType>(lhs: C, rhs: LInt) -> LInt {
  return rhs + lhs
}

/*-------- Subtraction --------*/
// Subtract
public func -    (lhs: LInt, rhs: LInt) -> LInt {
  return LInt.subtract(lhs, rhs)
}

public func -    <C: IntegerType>(lhs: LInt, rhs: C) -> LInt {
  return lhs - LInt(rhs)
}

public func -    <C: FloatingPointType>(lhs: LInt, rhs: C) -> LInt {
  return lhs - LInt(rhs)
}

public func -    <C: IntegerType>(lhs: C, rhs: LInt) -> LInt {
  return LInt(lhs) - rhs
}

public func -    <C: FloatingPointType>(lhs: C, rhs: LInt) -> LInt {
  return LInt(lhs) - rhs
}

/*-------- Binary operations --------*/
// And
public func &    (lhs: LInt, rhs: LInt) -> LInt {
  return LInt.and(lhs, rhs)
}

public func &    <C: IntegerType>(lhs: LInt, rhs: C) -> LInt {
  return lhs & LInt(rhs)
}

public func &    <C: FloatingPointType>(lhs: LInt, rhs: C) -> LInt {
  return lhs & LInt(rhs)
}

public func &    <C: IntegerType>(lhs: C, rhs: LInt) -> LInt {
  return rhs & lhs
}

public func &    <C: FloatingPointType>(lhs: C, rhs: LInt) -> LInt {
  return rhs & lhs
}

// Or
public func |    (lhs: LInt, rhs: LInt) -> LInt {
  return LInt.or(lhs, rhs)
}

public func |    <C: IntegerType>(lhs: LInt, rhs: C) -> LInt {
  return lhs | LInt(rhs)
}

public func |    <C: FloatingPointType>(lhs: LInt, rhs: C) -> LInt {
  return lhs | LInt(rhs)
}

public func |    <C: IntegerType>(lhs: C, rhs: LInt) -> LInt {
  return rhs | lhs
}

public func |    <C: FloatingPointType>(lhs: C, rhs: LInt) -> LInt {
  return rhs | lhs
}

// Xor
public func ^    (lhs: LInt, rhs: LInt) -> LInt {
  return LInt.xor(lhs, rhs)
}

public func ^    <C: IntegerType>(lhs: LInt, rhs: C) -> LInt {
  return lhs ^ LInt(rhs)
}

public func ^    <C: FloatingPointType>(lhs: LInt, rhs: C) -> LInt {
  return lhs ^ LInt(rhs)
}

public func ^    <C: IntegerType>(lhs: C, rhs: LInt) -> LInt {
  return rhs ^ lhs
}

public func ^    <C: FloatingPointType>(lhs: C, rhs: LInt) -> LInt {
  return rhs ^ lhs
}

// Not
public prefix func ~    (obj: LInt) -> LInt {
  return LInt.not(obj)
}

// Logical left shift
public func <<   (lhs: LInt, rhs: LInt) -> LInt {
  return LInt.lls(lhs, rhs)
}

public func <<   <C: IntegerType>(lhs: LInt, rhs: C) -> LInt {
  return lhs << LInt(rhs)
}

public func <<   <C: FloatingPointType>(lhs: LInt, rhs: C) -> LInt {
  return lhs << LInt(rhs)
}

public func <<   <C: IntegerType>(lhs: C, rhs: LInt) -> LInt {
  return LInt(lhs) << rhs
}

public func <<   <C: FloatingPointType>(lhs: C, rhs: LInt) -> LInt {
  return LInt(lhs) << rhs
}

// Logical right shift
public func >>   (lhs: LInt, rhs: LInt) -> LInt {
  return LInt.lrs(lhs, rhs)
}

public func >>   <C: IntegerType>(lhs: LInt, rhs: C) -> LInt {
  return lhs >> LInt(rhs)
}

public func >>   <C: FloatingPointType>(lhs: LInt, rhs: C) -> LInt {
  return lhs >> LInt(rhs)
}

public func >>   <C: IntegerType>(lhs: C, rhs: LInt) -> LInt {
  return LInt(lhs) >> rhs
}

public func >>   <C: FloatingPointType>(lhs: C, rhs: LInt) -> LInt {
  return LInt(lhs) >> rhs
}

// Shift by
public func <<=  (inout lhs: LInt, rhs: LInt)                     { lhs = lhs << rhs }

public func <<=  <C: IntegerType>(inout lhs: LInt, rhs: C)        { lhs = lhs << rhs }

public func <<=  <C: FloatingPointType>(inout lhs: LInt, rhs: C)  { lhs = lhs << rhs }

public func >>=  (inout lhs: LInt, rhs: LInt)                     { lhs = lhs >> rhs }

public func >>=  <C: IntegerType>(inout lhs: LInt, rhs: C)        { lhs = lhs >> rhs }

public func >>=  <C: FloatingPointType>(inout lhs: LInt, rhs: C)  { lhs = lhs << rhs }

/*-------- Square root --------*/
public func sqrt (n: LInt) -> LInt { return LInt.sqrt(n) }