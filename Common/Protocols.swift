//
//  Protocols.swift
//  LargeNumbers
//
//  Author: Hampus Lidin
//

public protocol LNumberType: Comparable, Printable, Hashable {
  typealias ValueType
  
  // Properties
  var value: ValueType { get }
  
  // Initializers
  init()
  init(_ value: Self)
  
  // Comparation functions
  func equals(obj: Self) -> Bool
  func lt    (obj: Self) -> Bool
  
  // Static functions
  static func add     (lhs: Self, _ rhs: Self)    -> Self
  static func subtract(lhs: Self, _ rhs: Self)    -> Self
  static func sqrt    (n: Self)                   -> Self
  static func pow     (n: Self, p: Double)        -> Self
}