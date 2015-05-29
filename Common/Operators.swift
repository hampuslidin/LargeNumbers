//
//  Operators.swift
//  LargeCs
//
//  Author: Hampus Lidin
//

/*-------- Comparators --------*/
// Equals
public func ==   <T: LNumberType>(lhs: T, rhs: T) -> Bool {
  return lhs.equals(rhs)
}

public func ==   <T: LNumberType, C: IntegerType>(lhs: T, rhs: C) -> Bool {
  return lhs == T(rhs)
}

public func ==   <T: LNumberType, C: FloatingPointType>(lhs: T, rhs: C) -> Bool {
  return lhs == T(rhs)
}

public func ==   <T: LNumberType, C: IntegerType>(lhs: C, rhs: T) -> Bool {
  return T(lhs) == rhs
}

public func ==   <T: LNumberType, C: FloatingPointType>(lhs: C, rhs: T) -> Bool {
  return T(lhs) == rhs
}

// Not equals
public func !=   <T: LNumberType>(lhs: T, rhs: T) -> Bool {
  return !(lhs == rhs)
}

public func !=   <T: LNumberType, C: IntegerType>(lhs: T, rhs: C) -> Bool {
  return lhs != T(rhs)
}

public func !=   <T: LNumberType, C: FloatingPointType>(lhs: T, rhs: C) -> Bool {
  return lhs != T(rhs)
}

public func !=   <T: LNumberType, C: IntegerType>(lhs: C, rhs: T) -> Bool {
  return T(lhs) != rhs
}

public func !=   <T: LNumberType, C: FloatingPointType>(lhs: C, rhs: T) -> Bool {
  return T(lhs) != rhs
}

// Greater than
public func >    <T: LNumberType>(lhs: T, rhs: T) -> Bool {
  return lhs.gt(rhs)
}

public func >    <T: LNumberType, C: IntegerType>(lhs: T, rhs: C) -> Bool {
  return lhs > T(rhs)
}

public func >    <T: LNumberType, C: FloatingPointType>(lhs: T, rhs: C) -> Bool {
  return lhs > T(rhs)
}

public func >    <T: LNumberType, C: IntegerType>(lhs: C, rhs: T) -> Bool {
  return T(lhs) > rhs
}

public func >    <T: LNumberType, C: FloatingPointType>(lhs: C, rhs: T) -> Bool {
  return T(lhs) > rhs
}

// Lesser than
public func <    <T: LNumberType>(lhs: T, rhs: T) -> Bool {
  return lhs.lt(rhs)
}

public func <    <T: LNumberType, C: IntegerType>(lhs: T, rhs: C) -> Bool {
  return lhs < T(rhs)
}

public func <    <T: LNumberType, C: FloatingPointType>(lhs: T, rhs: C) -> Bool {
  return lhs < T(rhs)
}

public func <    <T: LNumberType, C: IntegerType>(lhs: C, rhs: T) -> Bool {
  return T(lhs) < rhs
}

public func <   <T: LNumberType, C: FloatingPointType>(lhs: C, rhs: T) -> Bool {
  return T(lhs) < rhs
}

// Greater than or equals
public func >=   <T: LNumberType>(lhs: T, rhs: T) -> Bool {
  return (lhs == rhs) || (lhs > rhs)
}

public func >=   <T: LNumberType, C: IntegerType>(lhs: T, rhs: C) -> Bool {
  return lhs >= T(rhs)
}

public func >=   <T: LNumberType, C: FloatingPointType>(lhs: T, rhs: C) -> Bool {
  return lhs >= T(rhs)
}

public func >=   <T: LNumberType, C: IntegerType>(lhs: C, rhs: T) -> Bool {
  return T(lhs) >= rhs
}

public func >=   <T: LNumberType, C: FloatingPointType>(lhs: C, rhs: T) -> Bool {
  return T(lhs) >= rhs
}

// Lesser than or equals
public func <=   <T: LNumberType>(lhs: T, rhs: T) -> Bool {
  return (lhs == rhs) || (lhs < rhs)
}

public func <=   <T: LNumberType, C: IntegerType>(lhs: T, rhs: C) -> Bool {
  return lhs <= T(rhs)
}

public func <=   <T: LNumberType, C: FloatingPointType>(lhs: T, rhs: C) -> Bool {
  return lhs <= T(rhs)
}

public func <=   <T: LNumberType, C: IntegerType>(lhs: C, rhs: T) -> Bool {
  return T(lhs) <= rhs
}

public func <=   <T: LNumberType, C: FloatingPointType>(lhs: C, rhs: T) -> Bool {
  return T(lhs) <= rhs
}

/*-------- Addition --------*/
// Add
public func +    <T: LNumberType>(lhs: T, rhs: T) -> T {
  return T.add(lhs, rhs)
}

public func +    <T: LNumberType, C: IntegerType>(lhs: T, rhs: C) -> T {
  return lhs + T(rhs)
}

public func +    <T: LNumberType, C: FloatingPointType>(lhs: T, rhs: C) -> T {
  return lhs + T(rhs)
}

public func +    <T: LNumberType, C: IntegerType>(lhs: C, rhs: T) -> T {
  return T(lhs) + rhs
}

public func +    <T: LNumberType, C: FloatingPointType>(lhs: C, rhs: T) -> T {
  return T(lhs) + rhs
}

// Increment
public prefix func ++  <T: LNumberType>(inout obj: T) -> T {
  obj += 1
  return obj
}

public postfix func ++ <T: LNumberType>(inout obj: T) -> T {
  let tmp = obj
  obj += 1
  return tmp
}

// Increment by
public func +=   <T: LNumberType>(inout lhs: T, rhs: T)                       { lhs = lhs + rhs }

public func +=   <T: LNumberType, C: IntegerType>(inout lhs: T, rhs: C)       { lhs = lhs + T(rhs) }

public func +=   <T: LNumberType, C: FloatingPointType>(inout lhs: T, rhs: C) { lhs = lhs + T(rhs) }

/*-------- Subtraction --------*/
// Subtract
public func -    <T: LNumberType>(lhs: T, rhs: T) -> T {
  return T.subtract(lhs, rhs)
}

public func -    <T: LNumberType, C: IntegerType>(lhs: T, rhs: C) -> T {
  return lhs - T(rhs)
}

public func -    <T: LNumberType, C: FloatingPointType>(lhs: T, rhs: C) -> T {
  return lhs - T(rhs)
}

public func -    <T: LNumberType, C: IntegerType>(lhs: C, rhs: T) -> T {
  return T(lhs) - rhs
}

public func -    <T: LNumberType, C: FloatingPointType>(lhs: C, rhs: T) -> T {
  return T(lhs) - rhs
}

// Decrement
public prefix func --  <T: LNumberType>(inout obj: T) -> T {
  obj -= 1
  return obj
}

public postfix func -- <T: LNumberType>(inout obj: T) -> T {
  let tmp = obj
  obj -= 1
  return tmp
}

// Decrement by
public func -=   <T: LNumberType>(inout lhs: T, rhs: T)                       { lhs = lhs - rhs }

public func -=   <T: LNumberType, C: IntegerType>(inout lhs: T, rhs: C)       { lhs = lhs - T(rhs) }

public func -=   <T: LNumberType, C: FloatingPointType>(inout lhs: T, rhs: C) { lhs = lhs - T(rhs) }


/*-------- Multiplication and shifting --------*/
// Multiply
public func *    <T: LNumberType>(lhs: T, rhs: T) -> T {
  return T.multiply(lhs, rhs)
}

public func *    <T: LNumberType, C: IntegerType>(lhs: T, rhs: C) -> T {
  return lhs * T(rhs)
}

public func *    <T: LNumberType, C: FloatingPointType>(lhs: T, rhs: C) -> T {
  return lhs * T(rhs)
}

public func *    <T: LNumberType, C: IntegerType>(lhs: C, rhs: T) -> T {
  return T(lhs) * rhs
}

public func *    <T: LNumberType, C: FloatingPointType>(lhs: C, rhs: T) -> T {
  return T(lhs) * rhs
}

// Logical left shift
public func <<   <T: LIntegerType>(lhs: T, rhs: T) -> T {
  return T.lls(lhs, rhs)
}

public func <<   <T: LIntegerType, C: IntegerType>(lhs: T, rhs: C) -> T {
  return lhs << T(rhs)
}

public func <<   <T: LIntegerType, C: FloatingPointType>(lhs: T, rhs: C) -> T {
  return lhs << T(rhs)
}

public func <<   <T: LIntegerType, C: IntegerType>(lhs: C, rhs: T) -> T {
  return T(lhs) << rhs
}

public func <<   <T: LIntegerType, C: FloatingPointType>(lhs: C, rhs: T) -> T {
  return T(lhs) << rhs
}

// Logical right shift
public func >>   <T: LIntegerType>(lhs: T, rhs: T) -> T {
  return T.lrs(lhs, rhs)
}

public func >>   <T: LIntegerType, C: IntegerType>(lhs: T, rhs: C) -> T {
  return lhs >> T(rhs)
}

public func >>   <T: LIntegerType, C: FloatingPointType>(lhs: T, rhs: C) -> T {
  return lhs >> T(rhs)
}

public func >>   <T: LIntegerType, C: IntegerType>(lhs: C, rhs: T) -> T {
  return T(lhs) >> rhs
}

public func >>   <T: LIntegerType, C: FloatingPointType>(lhs: C, rhs: T) -> T {
  return T(lhs) >> rhs
}

// Multiply by
public func *=   <T: LNumberType>(inout lhs: T, rhs: T)                       { lhs = lhs * rhs }

public func *=   <T: LNumberType, C: IntegerType>(inout lhs: T, rhs: C)       { lhs = lhs * T(rhs) }

public func *=   <T: LNumberType, C: FloatingPointType>(inout lhs: T, rhs: C) { lhs = lhs * T(rhs) }

// Shift by
public func <<=  <T: LIntegerType>(inout lhs: T, rhs: T)                       { lhs = lhs << rhs }

public func <<=  <T: LIntegerType, C: IntegerType>(inout lhs: T, rhs: C)       { lhs = lhs << T(rhs) }

public func <<=  <T: LIntegerType, C: FloatingPointType>(inout lhs: T, rhs: C) { lhs = lhs << T(rhs) }

public func >>=  <T: LIntegerType>(inout lhs: T, rhs: T)                       { lhs = lhs >> rhs }

public func >>=  <T: LIntegerType, C: IntegerType>(inout lhs: T, rhs: C)       { lhs = lhs >> T(rhs) }

public func >>=  <T: LIntegerType, C: FloatingPointType>(inout lhs: T, rhs: C) { lhs = lhs << T(rhs) }

/*-------- Division and modulus --------*/
// Divide
public func /    <T: LNumberType>(lhs: T, rhs: T) -> T {
  return T.divide(lhs, rhs)
}

public func /    <T: LNumberType, C: IntegerType>(lhs: T, rhs: C) -> T {
  return lhs / T(rhs)
}

public func /    <T: LNumberType, C: FloatingPointType>(lhs: T, rhs: C) -> T {
  return lhs / T(rhs)
}

public func /    <T: LNumberType, C: IntegerType>(lhs: C, rhs: T) -> T {
  return T(lhs) / rhs
}

public func /    <T: LNumberType, C: FloatingPointType>(lhs: C, rhs: T) -> T {
  return T(lhs) / rhs
}

// Modulus
public func %    <T: LIntegerType>(lhs: T, rhs: T) -> T {
  return T.mod(lhs, rhs)
}

public func %    <T: LIntegerType, C: IntegerType>(lhs: T, rhs: C) -> T {
  return lhs % T(rhs)
}

public func %    <T: LIntegerType, C: FloatingPointType>(lhs: T, rhs: C) -> T {
  return lhs % T(rhs)
}

public func %    <T: LIntegerType, C: IntegerType>(lhs: C, rhs: T) -> T {
  return T(lhs) % rhs
}

public func %    <T: LIntegerType, C: FloatingPointType>(lhs: C, rhs: T) -> T {
  return T(lhs) % rhs
}

// Divide by
public func /=   <T: LNumberType>(inout lhs: T, rhs: T)                       { lhs = lhs / rhs }

public func /=   <T: LNumberType, C: IntegerType>(inout lhs: T, rhs: C)       { lhs = lhs / T(rhs) }

public func /=   <T: LNumberType, C: FloatingPointType>(inout lhs: T, rhs: C) { lhs = lhs / T(rhs) }

// Modulus by
public func %=   <T: LIntegerType>(inout lhs: T, rhs: T)                       { lhs = lhs % rhs }

public func %=   <T: LIntegerType, C: IntegerType>(inout lhs: T, rhs: C)       { lhs = lhs % T(rhs) }

public func %=   <T: LIntegerType, C: FloatingPointType>(inout lhs: T, rhs: C) { lhs = lhs % T(rhs) }

/*-------- Binary operations --------*/
// And
public func &    <T: LIntegerType>(lhs: T, rhs: T) -> T {
  return T.and(lhs, rhs)
}

public func &    <T: LIntegerType, C: IntegerType>(lhs: T, rhs: C) -> T {
  return lhs & T(rhs)
}

public func &    <T: LIntegerType, C: FloatingPointType>(lhs: T, rhs: C) -> T {
  return lhs & T(rhs)
}

public func &    <T: LIntegerType, C: IntegerType>(lhs: C, rhs: T) -> T {
  return T(lhs) & rhs
}

public func &    <T: LIntegerType, C: FloatingPointType>(lhs: C, rhs: T) -> T {
  return T(lhs) & rhs
}

// Or
public func |    <T: LIntegerType>(lhs: T, rhs: T) -> T {
  return T.mod(lhs, rhs)
}

public func |    <T: LIntegerType, C: IntegerType>(lhs: T, rhs: C) -> T {
  return lhs | T(rhs)
}

public func |    <T: LIntegerType, C: FloatingPointType>(lhs: T, rhs: C) -> T {
  return lhs | T(rhs)
}

public func |    <T: LIntegerType, C: IntegerType>(lhs: C, rhs: T) -> T {
  return T(lhs) | rhs
}

public func |    <T: LIntegerType, C: FloatingPointType>(lhs: C, rhs: T) -> T {
  return T(lhs) | rhs
}

// And by
public func &=   <T: LIntegerType>(inout lhs: T, rhs: T)                       { lhs = lhs & rhs }

public func &=   <T: LIntegerType, C: IntegerType>(inout lhs: T, rhs: C)       { lhs = lhs & T(rhs) }

public func &=   <T: LIntegerType, C: FloatingPointType>(inout lhs: T, rhs: C) { lhs = lhs & T(rhs) }

// Or by
public func |=   <T: LIntegerType>(inout lhs: T, rhs: T)                       { lhs = lhs | rhs }

public func |=   <T: LIntegerType, C: IntegerType>(inout lhs: T, rhs: C)       { lhs = lhs | T(rhs) }

public func |=   <T: LIntegerType, C: FloatingPointType>(inout lhs: T, rhs: C) { lhs = lhs | T(rhs) }

/*-------- Square root --------*/
public func sqrt <T: LNumberType>(n: T) -> T { return T.sqrt(n) }