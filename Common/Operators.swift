//
//  Operators.swift
//  LargeNumbers
//
//  Author: Hampus Lidin
//

// MARK: Equals
public func ==   (lhs: LInt, rhs: LInt) -> Bool {
  return lhs.equals(rhs)
}

// MARK: Lesser than
public func <    (lhs: LInt, rhs: LInt) -> Bool {
  return lhs.lt(rhs)
}

// MARK: Addition
public func +    (lhs: LInt, rhs: LInt) -> LInt {
  return LInt.add(lhs, rhs)
}

// MARK: Subtraction
public func -    (lhs: LInt, rhs: LInt) -> LInt {
  return LInt.subtract(lhs, rhs)
}

// MARK: AND
public func &    (lhs: LInt, rhs: LInt) -> LInt {
  return LInt.and(lhs, rhs)
}

// MARK: OR
public func |    (lhs: LInt, rhs: LInt) -> LInt {
  return LInt.or(lhs, rhs)
}

// MARK: XOR
public func ^    (lhs: LInt, rhs: LInt) -> LInt {
  return LInt.xor(lhs, rhs)
}

// MARK: NOT
public prefix func ~    (obj: LInt) -> LInt {
  return LInt.not(obj)
}

// MARK: Logical left shift
public func <<   (lhs: LInt, rhs: LInt) -> LInt {
  return LInt.lls(lhs, rhs)
}

// MARK: Logical right shift
public func >>   (lhs: LInt, rhs: LInt) -> LInt {
  return LInt.lrs(lhs, rhs)
}

// MARK: Shift by
public func <<=  (lhs: inout LInt, rhs: LInt)                     { lhs = lhs << rhs }

public func >>=  (lhs: inout LInt, rhs: LInt)                     { lhs = lhs >> rhs }

// MARK: Square root
public func sqrt (_ n: LInt) -> LInt { return LInt.sqrt(n) }
