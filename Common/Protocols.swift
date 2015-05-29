//
//  Protocols.swift
//  LargeNumbers
//
//  Author: Hampus Lidin
//

public protocol LNumberType: Comparable, Printable {
  typealias ValueType
  
  // Properties
  var value: ValueType { get }
  
  // Initializers
  init<T: IntegerType>(_ value: T)
  init<T: FloatingPointType>(_ value: T)
  
  // Comparation functions
  func equals(obj: Self) -> Bool
  func gt    (obj: Self) -> Bool
  func lt    (obj: Self) -> Bool
  
  // Static functions
  static func add     (lhs: Self, _ rhs: Self)    -> Self
  static func subtract(lhs: Self, _ rhs: Self)    -> Self
  static func multiply(lhs: Self, _ rhs: Self)    -> Self
  static func divide  (lhs: Self, _ rhs: Self)    -> Self
  static func mod     (lhs: Self, _ rhs: Self)    -> Self
  static func sqrt    (n: Self)                   -> Self
  static func pow     (n: Self, p: Double)        -> Self
}

public protocol LIntegerType: LNumberType {
  // Static functions
  static func lls(lhs: Self, _ rhs: Self) -> Self
  static func lrs(lhs: Self, _ rhs: Self) -> Self
  static func and(lhs: Self, _ rhs: Self) -> Self
  static func or (lhs: Self, _ rhs: Self) -> Self
}

public protocol RationalType: LNumberType {
  // Properties
  var num: UInt64 { get }
  var den: UInt64 { get }
  var gcd: UInt64 { get }

  // Initializers
  init<T: IntegerType>(_ num: T, _ den: T)
  init<T: FloatingPointType>(_ num: T, _ den: T)
  
  // Functions
  mutating func invert()
}