//
//  LInt.swift
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
public struct LInt: LNumberType, SignedInteger {
  // MARK: - Initializers
  public init<T: FloatingPoint>(_ value: T) {
    negative = value.sign == .minus
    if let cast = value as? Float        { self.value[0] = UInt(negative ? -cast : cast) }
    else if let cast = value as? Double  { self.value[0] = UInt(negative ? -cast : cast) }
    else if let cast = value as? CGFloat { self.value[0] = UInt(negative ? -cast : cast) }
  }
  
  public init<T: Integer>(_ value: T) {
    negative = value < 0
    let x = negative ? 0-value : value
    if let cast = x as? Int         { self.value[0] = UInt(cast) }
    else if let cast = x as? Int8   { self.value[0] = UInt(cast) }
    else if let cast = x as? Int16  { self.value[0] = UInt(cast) }
    else if let cast = x as? Int32  { self.value[0] = UInt(cast) }
    else if let cast = x as? Int64  { self.value[0] = UInt(cast) }
    else if let cast = x as? UInt   { self.value[0] = cast       }
    else if let cast = x as? UInt8  { self.value[0] = UInt(cast) }
    else if let cast = x as? UInt16 { self.value[0] = UInt(cast) }
    else if let cast = x as? UInt32 { self.value[0] = UInt(cast) }
    else if let cast = x as? UInt64 { self.value[0] = UInt(cast) }
    else if let cast = x as? LInt   { self.value    = cast.value }
  }
  
  // MARK: - Class methods
  public static func multiply(_ lhs: LInt, _ rhs: LInt) -> LInt
  {
    func long_multiply_uint(_ lhs: UInt, rhs: UInt) -> (UInt, UInt)
    {
      func low(_ n: UInt) -> UInt { return 0xFFFFFFFF & n }
      func high(_ n: UInt) -> UInt { return n >> 32 }
      
      var x = low(lhs)*low(rhs)
      let res_low = low(x)
      x = high(lhs)*low(rhs) + high(x)
      var res_high = low(x)
      let carry_low = high(x)
      x = res_high + low(lhs)*high(rhs)
      res_high = low(x)
      x = carry_low + high(lhs)*high(rhs) + high(x)
      return ((res_high << 32) | res_low, x)
    }
    
    var res = LInt()
    for i in 0 ..< lhs.value.count
    {
      for j in 0 ..< rhs.value.count
      {
        let (part_res, carry) = long_multiply_uint(lhs.value[i], rhs: rhs.value[j])
        var r = LInt()
        var c = LInt()
        if carry != 0 { c.value.append(0) }
        for _ in 0 ..< i+j
        {
          r.value.append(0)
          if carry != 0 { c.value.append(0) }
        }
        r.value[i+j] = part_res
        if carry != 0 {
          c.value[i+j+1] = carry
        }
        res += r
        res += c
      }
    }
    if lhs.negative && !rhs.negative || !lhs.negative && rhs.negative {
      res.negative = true
    }
    while res.value.count > 1 && res.value.last! == 0 { res.value.removeLast() }
    return res
  }
  
  public static func divide(_ lhs: LInt, _ rhs: LInt) -> LInt {
    assert(rhs != LInt(0), "Division by 0")
    let oneNegative = (lhs.negative || rhs.negative) && !(lhs.negative && rhs.negative)
    if lhs.value == rhs.value { return oneNegative ? LInt(-1) : LInt(1) }
    if lhs.value.count < rhs.value.count  { return LInt(0) }
    if lhs.value.count == rhs.value.count {
      for i in 0 ..< lhs.value.count {
        if lhs.value[lhs.value.count-1-i] < rhs.value[lhs.value.count-1-i] {
          return LInt(0)
        }
        if lhs.value[lhs.value.count-1-i] > rhs.value[lhs.value.count-1-i] { break }
      }
    }
    
    var q: LInt = LInt(0)
    var rem: LInt = LInt(0)
    for offs in (0 ..< lhs.value.count).reversed()
    {
      var bits = 64
      if offs == lhs.value.count-1
      {
        bits = 0
        var n = lhs.value[offs]
        while n != 0
        {
          n >>= 1
          bits += 1
        }
      }
      var pow_i = UInt(Darwin.pow(2.0, Double(bits-1)))
      for _ in 0 ..< bits
      {
        rem = rem << 1
        if ((lhs.value[offs] & pow_i) != 0)
        {
          rem = rem + 1
        }
        if rem >= rhs
        {
          rem -= rhs
          while q.value.count < offs + 1 { q.value.append(0) }
          q.value[offs] += pow_i
        }
        pow_i >>= 1
      }
    }
    if lhs.negative && !rhs.negative || !lhs.negative && rhs.negative {
      q.negative = true
    }
    return q
  }
  
  public static func lls(_ lhs: LInt, _ rhs: LInt) -> LInt
  {
    if rhs == 0 { return lhs }
    if rhs < 0 {
      var r = rhs
      r.negative = false
      return lrs(lhs,r)
    }
    var res = LInt()
    if LInt(rhs) >= LInt(64) {
      res = lhs
      var shift_mod = rhs
      var index = res.value.count-1
      while shift_mod >= LInt(64) {
        shift_mod -= 64
        res.value.append(res.value[res.value.count-1])
        for i in index ..< res.value.count-2 {
          res.value[i+1] = res.value[i]
        }
        res.value[index] = 0
        index += 1
      }
      return lls(res, shift_mod)
    } else {
      let mask = 0xFFFFFFFFFFFFFFFF << (64 - rhs.value[0])
      var (c_low, c_high): (UInt, UInt) =
        ((lhs.value[0] & mask) >> (64 - rhs.value[0]),0)
      res.value[0] = lhs.value[0] << rhs.value[0]
      for i in 1 ..< lhs.value.count {
        c_high = (lhs.value[i] & mask) >> (64 - rhs.value[0])
        res.value.append(lhs.value[i] << rhs.value[0])
        res.value[i] += c_low
        c_low = c_high
      }
      if c_low > 0 { res.value.append(c_low) }
    }
    return res
  }
  
  public static func lrs(_ lhs: LInt, _ rhs: LInt) -> LInt
  {
    if rhs > LInt(lhs.value.count*64) { return LInt() }
    if rhs == 0 { return lhs }
    if rhs < 0 {
      var r = rhs
      r.negative = false
      return lrs(lhs,r)
    }
    var res = LInt()
    if LInt(rhs) >= LInt(64)
    {
      res = lhs
      var shift_mod = rhs
      while shift_mod >= LInt(64)
      {
        shift_mod -= 64
        for i in 0 ..< res.value.count-1
        {
          res.value[i] = res.value[i+1]
        }
        res.value.removeLast()
      }
      return lrs(res, shift_mod)
    } else
    {
      let mask = 0xFFFFFFFFFFFFFFFF >> (64 - rhs.value[0])
      res.value[0] = lhs.value[0] >> rhs.value[0]
      for i in 1 ..< lhs.value.count
      {
        let carry_down = (lhs.value[i] & mask) << (64 - rhs.value[0])
        res.value[i-1] += carry_down
        let x = lhs.value[i] >> rhs.value[0]
        if x > 0 || i != lhs.value.count-1 { res.value.append(x) }
      }
    }
    return res
  }
  
  public static func mod(_ lhs: LInt, _ rhs: LInt) -> LInt {
    if rhs < 0 { return LInt(0) }
    return lhs-(lhs/rhs*rhs)
  }
  
  public static func and(_ lhs: LInt, _ rhs: LInt) -> LInt {
    return bitop(lhs, rhs: rhs, op: &, default_value: UInt.max)
  }
  
  public static func or(_ lhs: LInt, _ rhs: LInt) -> LInt {
    return bitop(lhs, rhs: rhs, op: |, default_value: 0)
  }
  
  public static func xor(_ lhs: LInt, _ rhs: LInt) -> LInt {
    return bitop(lhs, rhs: rhs, op: ^, default_value: 0)
  }
  
  public static func not(_ obj: LInt) -> LInt {
    var res = obj
    for i in 0 ..< res.value.count {
      res.value[i] = ~res.value[i]
    }
    return res
  }
  
  fileprivate static func bitop(_ lhs: LInt, rhs: LInt, op: (UInt, UInt) -> UInt,
      default_value: UInt) -> LInt
  {
    let largest = lhs > rhs ? lhs : rhs
    let smallest = lhs < rhs ? lhs : rhs
    var res = largest
    for i in 0 ..< largest.value.count
    {
      if i < smallest.value.count
      {
        res.value[i] = op(lhs.value[i], rhs.value[i])
      } else
      {
        res.value[i] = op(largest.value[i], default_value)
      }
    }
    return res
  }
  
  // MARK: - Instance methods
  public func toString() -> String
  {
    if self == 0 { return "0" }
    var n = self, rem = LInt(), str = ""
    while n != LInt(0)
    {
      rem = n % LInt(10)
      n /= LInt(10)
      str = "\(rem.value[0])" + str
    }
    return negative ? "-" + str : str
  }
  
  // MARK: LNumberType
  public typealias ValueType = [UInt]
  
  fileprivate var negative: Bool = false
  public fileprivate(set) var value: [UInt] = [0]
  
  public init() {}
  
  public init(_ n: LInt) { self.value = n.value }
  
  public func equals(_ obj: LInt) -> Bool {
    return negative == obj.negative && (value.count == obj.value.count) &&
      (value.last! == obj.value.last!)
  }
  
  public func lt(_ obj: LInt) -> Bool {
    if !negative && obj.negative { return false }
    if negative && !obj.negative { return true  }
    
    if value.count < obj.value.count { return !negative }
    if value.count > obj.value.count { return negative  }
    for i in 0 ..< value.count {
      if value[value.count-1-i] < obj.value[value.count-1-i] { return !negative }
      if value[value.count-1-i] > obj.value[value.count-1-i] { return negative }
    }
    
    return false
  }
  
  public static func add(_ lhs: LInt, _ rhs: LInt) -> LInt {
    if lhs.negative && !rhs.negative {
      var l = lhs
      l.negative = false
      return subtract(rhs, l)
    }
    if !lhs.negative && rhs.negative {
      var r = rhs
      r.negative = false
      return subtract(lhs, r)
    }
    let largest = lhs > rhs ? lhs : rhs
    let smallest = lhs < rhs ? lhs : rhs
    var res = largest
    for i in 0 ..< smallest.value.count
    {
      res.value[i] = res.value[i] &+ smallest.value[i]
      if res.value[i] < largest.value[i] && i < largest.value.count-1
      {
        res.value[i+1] += 1
      } else if res.value[i] < largest.value[i]
      {
        res.value.append(1)
      }
    }
    return res
  }
  
  public static func subtract(_ lhs: LInt, _ rhs: LInt) -> LInt {
    if rhs > lhs {
      var res = subtract(rhs, lhs)
      res.negative = true
      return res
    }
    if !lhs.negative && rhs.negative {
      var r = rhs
      r.negative = false
      return add(lhs, r)
    }
    if lhs.negative && !rhs.negative {
      return add(lhs, rhs)
    }
    if lhs.negative && rhs.negative {
      var r = rhs, l = lhs
      r.negative = false
      l.negative = false
      return subtract(r, l)
    }
    var res = lhs
    for i in 0 ..< rhs.value.count
    {
      res.value[i] = lhs.value[i] &- rhs.value[i]
      if res.value[i] > lhs.value[i] && i < lhs.value.count-1
      {
        var k = i+1
        while k < lhs.value.count-1 && res.value[k] == 0
        {
          res.value[k] = UInt.max
          k += 1
        }
        if res.value[k] != 0 { res.value[k] -= 1 }
      }
    }
    var m = res.value.count-1
    while m > 0 && res.value[m] == 0 {
      res.value.removeLast()
      m -= 1
    }
    
    return res
  }
  
  public static func sqrt(_ n: LInt) -> LInt {
    var num = n
    var res: LInt = LInt(0)
    var bit: LInt = 1 << LInt(62 + 64*(n.value.count-1))
    while bit > n { bit >>= 2 }
    while bit != LInt(0)
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
  
  public static func pow(_ n: LInt, p: Double) -> LInt {
    if p == 0 { return LInt(1) }
    if n == 0 { return LInt() }
    var res = n
    let op: (LInt, LInt) -> LInt = p >= 0 ? multiply : divide
    for _ in 0 ..< Int(abs(p)) {
      res = op(res, n)
    }
    return res
  }
  
  // MARK: SignedIntegerType
  typealias Distance = Int
  public typealias Stride = Int
  
  public var description: String { get { return self.toString() } }
  public var hashValue: Int {
    get {
      var res = 0
      for elem in value {
        res = res &+ elem.hashValue
      }
      return res
    }
  }
  public static let allZeros = LInt(0)
  
  public init(_builtinIntegerLiteral value: _MaxBuiltinIntegerType) {
    self.init(Int(_builtinIntegerLiteral: value))
  }
  
  public init(integerLiteral value: IntegerLiteralType) {
    self.init(value)
  }
  
  public static func addWithOverflow(_ lhs: LInt, _ rhs: LInt)
      -> (LInt, overflow: Bool) {
    return (add(lhs,rhs), false)
  }
  
  public static func subtractWithOverflow(_ lhs: LInt, _ rhs: LInt)
      -> (LInt, overflow: Bool) {
    return (subtract(lhs,rhs), false)
  }
  
  public static func multiplyWithOverflow(_ lhs: LInt, _ rhs: LInt)
      -> (LInt, overflow: Bool) {
    return (multiply(lhs,rhs), false)
  }
  
  public static func divideWithOverflow(_ lhs: LInt, _ rhs: LInt)
      -> (LInt, overflow: Bool) {
    return (divide(lhs,rhs), false)
  }
  
  public static func remainderWithOverflow(_ lhs: LInt, _ rhs: LInt)
      -> (LInt, overflow: Bool) {
    return (mod(lhs,rhs), false)
  }
  
  func toUIntMax() -> UIntMax {
    return UIntMax.max
  }
  
  public func toIntMax() -> IntMax {
    return IntMax.max
  }
  
  public func successor() -> LInt {
    return self+LInt(1)
  }
  
  public func predecessor() -> LInt {
    return self-LInt(1)
  }
  
  public func distanceTo(_ other: LInt) -> Int {
    let a = other-self
    return Int(a > LInt(UInt.max) ? UInt.max : a.value[0])
  }
  
  public func advancedBy(_ other: Int) -> LInt {
    return self+LInt(other)
  }
}
