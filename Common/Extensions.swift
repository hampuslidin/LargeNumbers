//
//  Extensions.swift
//  LargeNumbers
//
//  Author: Hampus Lidin
//

public extension Float {
  init(_ value: URat) {
    self = Float(value.num)/Float(value.den)
  }
}

public extension Double {
  init(_ value: URat) {
    self = Double(value.num)/Double(value.den)
  }
}
