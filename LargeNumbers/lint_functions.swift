//
//  lint_functions.swift
//  LargeNumbers
//
//  Author: Hampus Lidin
//

import Darwin
import Foundation

/*-------- Comparators --------*/
public func ==(lhs: lint, rhs: lint) -> Bool
{
  return (lhs.value.count == rhs.value.count) &&
     (lhs.value[lhs.value.count-1] == rhs.value[rhs.value.count-1])
}

public func ==(lhs: lint, rhs: Number) -> Bool
{
  return lhs == lint(rhs)
}

public func ==(lhs: Number, rhs: lint) -> Bool
{
  return lint(lhs) == rhs
}

public func !=(lhs: lint, rhs: lint) -> Bool
{
  return !(lhs == rhs)
}

public func !=(lhs: lint, rhs: Number) -> Bool
{
  return lhs != lint(rhs)
}

public func !=(lhs: Number, rhs: lint) -> Bool
{
  return lint(lhs) != rhs
}

public func >(lhs: lint, rhs: lint) -> Bool
{
  return (lhs.value.count > rhs.value.count) ||
     ((lhs.value.count == rhs.value.count) &&
      lhs.value[lhs.value.count-1] > rhs.value[rhs.value.count-1])
}

public func >(lhs: lint, rhs: Number) -> Bool
{
  return lhs > lint(rhs)
}

public func >(lhs: Number, rhs: lint) -> Bool
{
  return lint(lhs) > rhs
}

public func <(lhs: lint, rhs: lint) -> Bool
{
  return (lhs.value.count < rhs.value.count) ||
     ((lhs.value.count == rhs.value.count) &&
      lhs.value[lhs.value.count-1] < rhs.value[rhs.value.count-1])
}

public func <(lhs: lint, rhs: Number) -> Bool
{
  return lhs < lint(rhs)
}

public func <(lhs: Number, rhs: lint) -> Bool
{
  return lint(lhs) < rhs
}

public func <=(lhs: lint, rhs: lint) -> Bool
{
  return (lhs == rhs) || (lhs < rhs)
}

public func <=(lhs: lint, rhs: Number) -> Bool
{
  return lhs <= lint(rhs)
}

public func <=(lhs: Number, rhs: lint) -> Bool
{
  return lint(lhs) <= rhs
}

public func >=(lhs: lint, rhs: lint) -> Bool
{
  return (lhs == rhs) || (lhs > rhs)
}

public func >=(lhs: lint, rhs: Number) -> Bool
{
  return lhs >= lint(rhs)
}

public func >=(lhs: Number, rhs: lint) -> Bool
{
  return lint(lhs) >= rhs
}

/*-------- Addition --------*/
public func +(lhs: lint, rhs: lint) -> lint
{
  return lint.add(lhs, rhs: rhs)
}

public func +(lhs: lint, rhs: Number) -> lint
{
  return lint.add(lhs, rhs: lint(rhs))
}

public func +(lhs: Number, rhs: lint) -> lint
{
  return lint.add(lint(lhs), rhs: rhs)
}

public func +=(inout lhs: lint, rhs: lint) { lhs = lhs + rhs }

public func +=(inout lhs: lint, rhs: Number) { lhs = lhs + rhs }

public prefix func ++(inout obj: lint) -> lint
{
  obj += 1
  return obj
}

public postfix func ++(inout obj: lint) -> lint
{
  let tmp = obj
  obj += 1
  return tmp
}

/*-------- Subtraction --------*/
public func -(lhs: lint, rhs: lint) -> lint
{
  return lint.subtract(lhs, rhs: rhs)
}

public func -(lhs: lint, rhs: Number) -> lint
{
  return lint.subtract(lhs, rhs: lint(rhs))
}

public func -(lhs: Number, rhs: lint) -> lint
{
  return lint.subtract(lint(lhs), rhs: rhs)
}

public func -=(inout lhs: lint, rhs: lint)   { lhs = lhs - rhs }

public func -=(inout lhs: lint, rhs: Number) { lhs = lhs - rhs }

public prefix func --(inout obj: lint) -> lint
{
  obj -= 1
  return obj
}

public postfix func --(inout obj: lint) -> lint
{
  let tmp = obj
  obj -= 1
  return tmp
}

/*-------- Multiplication and shifting --------*/
public func *(lhs: lint, rhs: lint) -> lint
{
  return lint.multiply(lhs, rhs: rhs)
}

public func *(lhs: lint, rhs: Number) -> lint
{
  return lint.multiply(lhs, rhs: lint(rhs))
}

public func *(lhs: Number, rhs: lint) -> lint
{
  return lint.multiply(lint(lhs), rhs: rhs)
}

public func <<(lhs: lint, rhs: lint) -> lint
{
  return lint.lls(lhs, rhs: rhs)
}

public func <<(lhs: lint, rhs: Number) -> lint
{
  return lint.lls(lhs, rhs: lint(rhs))
}

public func <<(lhs: Number, rhs: lint) -> lint
{
  return lint.lls(lint(lhs), rhs: rhs)
}

public func >>(lhs: lint, rhs: lint) -> lint
{
  return lint.lrs(lhs, rhs: rhs)
}

public func >>(lhs: lint, rhs: Number) -> lint
{
  return lint.lrs(lhs, rhs: lint(rhs))
}

public func >>(lhs: Number, rhs: lint) -> lint
{
  return lint.lrs(lint(lhs), rhs: rhs)
}

public func *=(inout lhs: lint, rhs: lint)     { lhs = lhs * rhs }

public func *=(inout lhs: lint, rhs: Number)   { lhs = lhs * rhs }

public func <<=(inout lhs: lint, rhs: lint)    { lhs = lhs << rhs }

public func <<=(inout lhs: lint, rhs: Number)  { lhs = lhs << rhs }

public func >>=(inout lhs: lint, rhs: lint)    { lhs = lhs >> rhs }

public func >>=(inout lhs: lint, rhs: Number)  { lhs = lhs >> rhs }

/*-------- Division and modulo --------*/
public func /(lhs: lint, rhs: lint) -> lint
{
  return lint.divide(lhs, rhs: rhs)
}

public func /(lhs: lint, rhs: Number) -> lint
{
  return lint.divide(lhs, rhs: lint(rhs))
}

public func /(lhs: Number, rhs: lint) -> lint
{
  return lint.divide(lint(lhs), rhs: rhs)
}


public func %(lhs: lint, rhs: lint) -> lint
{
  return lhs-(lhs/rhs*rhs)
}

public func %(lhs: lint, rhs: Number) -> lint
{
  let r = lint(rhs)
  return lhs-(lhs/r*r)
}

public func %(lhs: Number, rhs: lint) -> lint
{
let l = lint(lhs)
  return l-(l/rhs*rhs)
}

public func /=(inout lhs: lint, rhs: lint)         { lhs = lhs / rhs }

public func /=(inout lhs: lint, rhs: Number)       { lhs = lhs / rhs }

public func %=(inout lhs: lint, rhs: lint)         { lhs = lhs % rhs }

public func %=(inout lhs: lint, rhs: Number)       { lhs = lhs % rhs }

/*-------- Binary operations --------*/
public func &(lhs: lint, rhs: lint) -> lint
{
  return lint.bitop(lhs, rhs: rhs, op: &, default_value: 0)
}

public func &(lhs: lint, rhs: Number) -> lint
{
  return lhs & lint(rhs)
}

public func &(lhs: Number, rhs: lint) -> lint
{
  return lint(lhs) & rhs
}

public func |(lhs: lint, rhs: lint) -> lint
{
  return lint.bitop(lhs, rhs: rhs, op: |, default_value: 0xFFFFFFFFFFFFFFFF)
}

public func |(lhs: lint, rhs: Number) -> lint
{
  return lhs | lint(rhs)
}

public func |(lhs: Number, rhs: lint) -> lint
{
  return lint(lhs) | rhs
}

public func &=(inout lhs: lint, rhs: lint)         { lhs = lhs & rhs }

public func &=(inout lhs: lint, rhs: Number)       { lhs = lhs & rhs }

public func |=(inout lhs: lint, rhs: lint)         { lhs = lhs | rhs }

public func |=(inout lhs: lint, rhs: Number)       { lhs = lhs | rhs }

/*-------- Square root --------*/
public func sqrt(n: lint) -> lint
{
  var num = n
  var res = lint()
  var bit = lint(1) << (62 + 64*(num.value.count-1))
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