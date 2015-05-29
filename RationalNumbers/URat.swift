//
//  URat.swift
//  LargeNumbers
//
//  Author: Hampus Lidin
//

import Darwin
import Foundation

/*-------- Classes --------*/

/**
    Used for very large integer arithmetic operations. Implemented as a struct,
    it dynamically allocates space depending on the size of the number, using
    Swift's native array implementation.
*/
public struct URat: RationalType {
  typealias ValueType = (UInt64, UInt64)

  // Properties
  public var description: String { get { return self.toString() } }
  public private(set) var num: UInt64 = 0
  public private(set) var den: UInt64 = 1
  public var value: (UInt64, UInt64) { get { return (num, den) } }
  public var gcd: UInt64 {
    get {
      var n = num, m = den
      while m != 0 {
        let tmp = m
        m = n%m
        n = tmp
      }
      return n
    }
  }
  
  // Initializers
  public init() { }
  
  public init<T: IntegerType>(_ value: T) { self.init(value, 1) }
  
  public init<T: FloatingPointType>(_ value: T) { self.init(value, T(1)) }
  
  public init<T: IntegerType>(_ num: T, _ den: T) {
    if let cast = num as? Int         { self.num = UInt64(cast) }
    else if let cast = num as? Int8   { self.num = UInt64(cast) }
    else if let cast = num as? Int16  { self.num = UInt64(cast) }
    else if let cast = num as? Int32  { self.num = UInt64(cast) }
    else if let cast = num as? Int64  { self.num = UInt64(cast) }
    else if let cast = num as? UInt   { self.num = UInt64(cast) }
    else if let cast = num as? UInt8  { self.num = UInt64(cast) }
    else if let cast = num as? UInt16 { self.num = UInt64(cast) }
    else if let cast = num as? UInt32 { self.num = UInt64(cast) }
    else if let cast = num as? UInt64 { self.num = cast }
    else if let cast = num as? Float  { self.num = UInt64(cast) }
    else if let cast = num as? Double { self.num = UInt64(cast) }
    
    if let cast = den as? Int         { self.den = UInt64(cast) }
    else if let cast = den as? Int8   { self.den = UInt64(cast) }
    else if let cast = den as? Int16  { self.den = UInt64(cast) }
    else if let cast = den as? Int32  { self.den = UInt64(cast) }
    else if let cast = den as? Int64  { self.den = UInt64(cast) }
    else if let cast = den as? UInt   { self.den = UInt64(cast) }
    else if let cast = den as? UInt8  { self.den = UInt64(cast) }
    else if let cast = den as? UInt16 { self.den = UInt64(cast) }
    else if let cast = den as? UInt32 { self.den = UInt64(cast) }
    else if let cast = den as? UInt64 { self.den = cast }
    else if let cast = den as? Float  { self.den = UInt64(cast) }
    else if let cast = den as? Double { self.den = UInt64(cast) }
    reduce()
  }
  
  public init<T: FloatingPointType>(_ num: T, _ den: T)
  {
    if let cast = num as? Float       { self.num = UInt64(cast) }
    else if let cast = num as? Double { self.num = UInt64(cast) }
    
    if let cast = den as? Float       { self.den = UInt64(cast) }
    else if let cast = den as? Double { self.den = UInt64(cast) }
    reduce()
  }
  
  // Comparison functions
  public func equals(obj: URat) -> Bool {
    return num == obj.num && den == obj.den
  }
  
  public func gt(obj: URat) -> Bool {
    return num * obj.den > obj.num * den
  }
  
  public func lt(obj: URat) -> Bool {
    return !(self >= obj)
  }
  
  // Functions
  public func toString() -> String {
    if num == 0 { return "0" }
    if den == 1 { return "\(num)" }
    return "\(self.num)/\(self.den)"
  }
  
  public mutating func invert() {
    let tmp = num
    num = den
    den = tmp
  }
  
  private mutating func reduce() {
    let a = gcd
    num /= a
    den /= a
  }
  
  // Static functions
  public static func add(lhs: URat, _ rhs: URat) -> URat {
    var res = URat(lhs.num*rhs.den+rhs.num*lhs.den, lhs.den*rhs.den)
    res.reduce()
    return res
  }
  
  public static func subtract(lhs: URat, _ rhs: URat) -> URat {
    var res = URat(lhs.num*rhs.den-rhs.num*lhs.den, lhs.den*rhs.den)
    res.reduce()
    return res
  }
  
  public static func multiply(lhs: URat, _ rhs: URat) -> URat {
    var res = URat(lhs.num*rhs.num, lhs.den*rhs.den)
    res.reduce()
    return res
  }
  
  public static func divide(lhs: URat, _ rhs: URat) -> URat {
    return lhs*URat(rhs.den, rhs.num)
  }
  
  /*
      a/b % c/d = a/b - (Int(a*d)/Int(b*c)*c/d)
  */
  public static func mod(lhs: URat, _ rhs: URat) -> URat {
    let a = lhs.num*rhs.den
    let b = lhs.den*rhs.num
    return lhs - (a/b*rhs)
  }
  
  public static func sqrt(n: URat) -> URat {
    func _sqrt(n: UInt64) -> UInt64 {
      var num = n
      var res: UInt64 = 0
      var bit: UInt64 = 1 << 62
      while bit > n { bit >>= 2 }
      while bit != 0
      {
        if num >= res + bit
        {
          num -= res + bit
          res = (res >> 1) + bit
        } else
        {
          res >>= 1
        }
        bit >>= 2
      }
      return res
    }
    return URat(_sqrt(n.num), _sqrt(n.den))
  }
  
  public static func pow(n: URat, p: Double) -> URat {
    return URat(Darwin.pow(Double(n.num), p), Darwin.pow(Double(n.den), p))
  }
  
  /*-------- Tests --------*/
  internal static func checkValidity(# rounds: Int) {}
}