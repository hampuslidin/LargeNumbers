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
public struct LInt: LIntegerType
{
  typealias ValueType = [UInt64]

  // Properties
  public var description: String
  {
    get { return self.toString() }
  }
  public private(set) var value: [UInt64] = [0]
  
  // Initializers
  public init() {}
  
  public init<T: IntegerType>(_ value: T)
  {
    if let cast = value as? Int         { self.value[0] = UInt64(cast) }
    else if let cast = value as? Int8   { self.value[0] = UInt64(cast) }
    else if let cast = value as? Int16  { self.value[0] = UInt64(cast) }
    else if let cast = value as? Int32  { self.value[0] = UInt64(cast) }
    else if let cast = value as? Int64  { self.value[0] = UInt64(cast) }
    else if let cast = value as? UInt   { self.value[0] = UInt64(cast) }
    else if let cast = value as? UInt8  { self.value[0] = UInt64(cast) }
    else if let cast = value as? UInt16 { self.value[0] = UInt64(cast) }
    else if let cast = value as? UInt32 { self.value[0] = UInt64(cast) }
    else if let cast = value as? UInt64 { self.value[0] = cast }
    else if let cast = value as? Float  { self.value[0] = UInt64(cast) }
    else if let cast = value as? Double { self.value[0] = UInt64(cast) }
  }
  
  public init<T: FloatingPointType>(_ value: T)
  {
    if let cast = value as? Float       { self.value[0] = UInt64(cast) }
    else if let cast = value as? Double { self.value[0] = UInt64(cast) }
  }
  
  // Comparison functions
  public func equals(obj: LInt) -> Bool {
    return (value.count == obj.value.count) && (value.last! == obj.value.last!)
  }
  
  public func gt(obj: LInt) -> Bool {
    return (value.count > obj.value.count) ||
      ((value.count == obj.value.count) && value.last! > obj.value.last!)
  }
  
  public func lt(obj: LInt) -> Bool {
    return !(self >= obj)
  }
  
  // Functions
  public func toString() -> String
  {
    if self == 0 { return "0" } 
    var n = self, rem = LInt(), str = ""
    while n != 0
    {
      rem = n % 10
      n /= 10
      str = "\(rem.value[0])" + str
    }
    return str
  }
  
  // Static functions
  public static func add(lhs: LInt, _ rhs: LInt) -> LInt
  {
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
  
  public static func subtract(lhs: LInt, _ rhs: LInt) -> LInt
  {
    assert(lhs >= rhs, "Overflow")
    var res = lhs
    for i in 0 ..< rhs.value.count
    {
      res.value[i] = lhs.value[i] &- rhs.value[i]
      if res.value[i] > lhs.value[i] && i < lhs.value.count-1
      {
        var k = i+1
        while k < lhs.value.count-1 && res.value[k] == 0
        {
          res.value[k++] = UInt64.max
        }
        if res.value[k] != 0 { res.value[k] -= 1 }
      }
    }
    var m = res.value.count-1
    while m > 0 && res.value[m--] == 0 { res.value.removeLast() }
    return res
  }
  
  public static func multiply(lhs: LInt, _ rhs: LInt) -> LInt
  {
    func long_multiply_uint64(lhs: UInt64, rhs: UInt64) -> (UInt64, UInt64)
    {
      func low(n: UInt64) -> UInt64 { return 0xFFFFFFFF & n }
      func high(n: UInt64) -> UInt64 { return n >> 32 }
      
      var x = low(lhs)*low(rhs)
      let res_low = low(x)
      x = high(lhs)*low(rhs) + high(x)
      var res_high = low(x)
      var carry_low = high(x)
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
        let (part_res, carry) = long_multiply_uint64(lhs.value[i], rhs.value[j])
        var r = LInt()
        var c = LInt()
        if carry != 0 { c.value.append(0) }
        for _ in 0 ..< i+j
        {
          r.value.append(0)
          if carry != 0 { c.value.append(0) }
        }
        r.value[i+j] = part_res
        if carry != 0 { c.value[i+j+1] = carry }
        res += r
        res += c
      }
    }
    return res
  }
  
  public static func divide(lhs: LInt, _ rhs: LInt) -> LInt
  {
    assert(rhs != 0, "Division by 0")
    if lhs < rhs { return LInt(0) }
    if lhs == rhs { return LInt(1) }
    var q = LInt()
    var rem = LInt()
    for var offs = lhs.value.count-1; offs >= 0; offs--
    {
      var bits = 64
      if offs == lhs.value.count-1
      {
        bits = 0
        var n = lhs.value[offs]
        while n != 0
        {
          n >>= 1
          bits++
        }
      }
      var pow_i = UInt64(Darwin.pow(2.0, Double(bits-1)))
      for var i = bits-1; i >= 0; i--
      {
        rem <<= 1
        let bit_set = (lhs.value[offs] & pow_i) != 0
        rem += bit_set ? 1 : 0
        if rem >= rhs
        {
          rem -= rhs
          while q.value.count < offs + 1 { q.value.append(0)}
          q.value[offs] += pow_i
        }
        pow_i >>= 1
      }
    }
    return q
  }
  
  public static func lls(lhs: LInt, _ rhs: LInt) -> LInt
  {
    if rhs == 0 { return lhs }
    var res = LInt()
    if rhs >= 64
    {
      res = lhs
      var shift_mod = rhs
      var index = res.value.count-1
      while shift_mod >= 64
      {
        shift_mod -= 64
        res.value.append(res.value[res.value.count-1])
        for i in index ..< res.value.count-2
        {
          res.value[i+1] = res.value[i]
        }
        res.value[index++] = 0
      }
      return lls(res, shift_mod)
    } else
    {
      let mask = 0xFFFFFFFFFFFFFFFF << (64 - rhs.value[0])
      var (c_low, c_high): (UInt64, UInt64) =
        ((lhs.value[0] & mask) >> (64 - rhs.value[0]),0)
      res.value[0] = lhs.value[0] << rhs.value[0]
      for i in 1 ..< lhs.value.count
      {
        c_high = (lhs.value[i] & mask) >> (64 - rhs.value[0])
        res.value.append(lhs.value[i] << rhs.value[0])
        res.value[i] += c_low
        c_low = c_high
      }
      if c_low > 0 { res.value.append(c_low) }
    }
    return res
  }
  
  public static func lrs(lhs: LInt, _ rhs: LInt) -> LInt
  {
    if rhs > lhs.value.count*64 { return LInt() }
    if rhs == 0 { return lhs }
    var res = LInt()
    if rhs >= 64
    {
      res = lhs
      var shift_mod = rhs
      while shift_mod >= 64
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
  
  public static func mod(lhs: LInt, _ rhs: LInt) -> LInt {
    return lhs-(lhs/rhs*rhs)
  }
  
  public static func and(lhs: LInt, _ rhs: LInt) -> LInt {
    return bitop(lhs, rhs: rhs, op: &, default_value: 0)
  }
  
  public static func or(lhs: LInt, _ rhs: LInt) -> LInt {
    return bitop(lhs, rhs: rhs, op: |, default_value: UInt64.max)
  }
  
  private static func bitop(lhs: LInt, rhs: LInt, op: (UInt64, UInt64) -> UInt64,
      default_value: UInt64) -> LInt
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
  
  public static func sqrt(n: LInt) -> LInt {
    var num = n
    var res = LInt(0)
    var bit = LInt(1) << (62 + 64*(n.value.count-1))
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
  
  public static func pow(n: LInt, p: Double) -> LInt {
    if p == 0 { return LInt(1) }
    if n == 0 { return LInt() }
    var res = n
    let op: (LInt, LInt) -> LInt = p >= 0 ? multiply : divide
    for _ in 0 ..< Int(abs(p)) {
      res = op(res, n)
    }
    return res
  }
  
  /*-------- Tests --------*/
  internal static func checkValidity(# rounds: Int)
  {
    for i in 1 ... rounds
    {
      var a = LInt(UInt64(rand())*UInt64(rand()))
      var b = LInt(UInt64(rand())*UInt64(rand()))
      var c = LInt(UInt64(rand())*UInt64(rand()))
      
      var limit = rand()%3
      for j in 0 ..< limit { a.value.append(UInt64(rand())*UInt64(rand())) }
      
      limit = rand()%3
      for j in 0 ..< limit { b.value.append(UInt64(rand())*UInt64(rand())) }
      
      limit = rand()%3
      for j in 0 ..< limit { c.value.append(UInt64(rand())*UInt64(rand())) }
      
      /* Insert tests here */
      
      if i%100 == 0 { println("\(i) tests completed.") }
    }
    println("\nCompleted all tests successfully.")
  }
}