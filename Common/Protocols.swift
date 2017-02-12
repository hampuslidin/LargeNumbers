//
//  Protocols.swift
//  LargeNumbers
//
//  Author: Hampus Lidin
//

public protocol LNumberType: Comparable, CustomStringConvertible, Hashable {
  associatedtype ValueType
  
  // Properties
  var value: ValueType { get }
  
  // Initializers
  init()
  init(_ value: Self)
  
  // Comparation functions
  func equals(_ obj: Self) -> Bool
  func lt    (_ obj: Self) -> Bool
  
  // Static functions
  static func add     (_ lhs: Self, _ rhs: Self)    -> Self
  static func subtract(_ lhs: Self, _ rhs: Self)    -> Self
  static func sqrt    (_ n: Self)                   -> Self
  static func pow     (_ n: Self, p: Double)        -> Self
}
