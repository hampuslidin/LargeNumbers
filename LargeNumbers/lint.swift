//
//  lint.swift
//  LargeNumbers
//
//  Author: Hampus Lidin
//

import Darwin
import Foundation

/*-------- Protocols and extensions --------*/
public protocol Number {}
extension Int:    Number {}
extension Int8:   Number {}
extension Int16:  Number {}
extension Int32:  Number {}
extension Int64:  Number {}
extension UInt:   Number {}
extension UInt8:  Number {}
extension UInt16: Number {}
extension UInt32: Number {}
extension UInt64: Number {}
extension Float:  Number {}
extension Double: Number {}

/*-------- Classes --------*/

/**
    Used for very large integer arithmetic operations. Implemented as a struct,
    it dynamically allocates space depending on the size of the number, using
    Swift's native array implementation.
*/
public struct lint: Comparable, Printable
{
  // Properties
  public var description: String
  {
    get { return self.toString() }
  }
  private(set) var value: [UInt64] = [0]
  
  // Initializers
  public init() {}
  
  public init(_ value: Number)
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
  
  // Functions
  public func toString() -> String
  {
    if self == 0 { return "0" } 
    var n = self, rem = lint(), str = ""
    while n != 0
    {
      rem = n % 10
      n /= 10
      str = "\(rem.value[0])" + str
    }
    return str
  }
  
  // Static functions
  static func add(lhs: lint, rhs: lint) -> lint
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
  
  static func subtract(lhs: lint, rhs: lint) -> lint
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
  
  static func multiply(lhs: lint, rhs: lint) -> lint
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
    
    var res = lint()
    for i in 0 ..< lhs.value.count
    {
      for j in 0 ..< rhs.value.count
      {
        let (part_res, carry) = long_multiply_uint64(lhs.value[i], rhs.value[j])
        var r = lint()
        var c = lint()
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
  
  static func divide(lhs: lint, rhs: lint) -> lint
  {
    assert(rhs != 0, "Division by 0")
    if lhs < rhs { return lint(0) }
    if lhs == rhs { return lint(1) }
    var q = lint()
    var rem = lint()
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
      var pow_i = UInt64(pow(2, Double(bits-1)))
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
  
  static func lls(lhs: lint, rhs: lint) -> lint
  {
    if rhs == 0 { return lhs }
    var res = lint()
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
      return lls(res, rhs: shift_mod)
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
  
  static func lrs(lhs: lint, rhs: lint) -> lint
  {
    if rhs > lhs.value.count*64 { return lint() }
    if rhs == 0 { return lhs }
    var res = lint()
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
      return lrs(res, rhs: shift_mod)
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
  
  public static func bitop(lhs: lint, rhs: lint, op: (UInt64, UInt64) -> UInt64,
      default_value: UInt64) -> lint
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
  
  /*-------- Tests --------*/
  static func checkValidity(# rounds: Int)
  {
    for i in 1 ... rounds
    {
      var a = lint(UInt64(rand())*UInt64(rand()))
      var b = lint(UInt64(rand())*UInt64(rand()))
      var c = lint(UInt64(rand())*UInt64(rand()))
      
      var limit = rand()%3
      for j in 0 ..< limit { a.value.append(UInt64(rand())*UInt64(rand())) }
      
      limit = rand()%3
      for j in 0 ..< limit { b.value.append(UInt64(rand())*UInt64(rand())) }
      
      limit = rand()%3
      for j in 0 ..< limit { c.value.append(UInt64(rand())*UInt64(rand())) }
      
      let x = lint(1) << 64 + UInt64.max
      let y = x + x
      assert(a+b == b+a,
        "Assertion failure: additive commutativity, a+b != b+a." +
        "\(a)+\(b) = \(a+b)\n" +
        "\(b)+\(a) = \(b+a)\n" )
      assert(a*b == b*a,
        "Assertion failure: multiplicative commutativity, a*b != b*a." +
        "\(a)*\(b) = \(a*b)\n" +
        "\(b)*\(a) = \(b*a)\n" )
      assert((a+b)+c == a+(b+c),
        "Assertion failure: additive associativity, (a+b)+c != a+(b+c)." +
        "(\(a)+\(b))+\(c) = \((a+b)+c)\n" +
        "\(a)+(\(b)+\(c)) = \(a+(b+c))\n" )
      assert((a*b)*c == a*(b*c),
        "Assertion failure: additive associativity, (a*b)*c != a*(b*c)." +
        "(\(a)*\(b))*\(c) = \((a*b)*c)\n" +
        "\(a)*(\(b)*\(c)) = \(a*(b*c))\n" )
      assert(a*(b+c) == a*b+a*c,
        "Assertion failure: distibrution, a*(b+c) != a*b+a*c.\n" +
        "\(a)*(\(b)+\(c)) = \(a*(b+c))\n" +
        "\(a)*\(b)+\(a)*\(c) = \(a*b+a*c)\n" )
      assert(a-b+b == a)
      
      if i%100 == 0 { println("\(i) tests completed.") }
    }
    println("\nCompleted all tests successfully.")
  }
}