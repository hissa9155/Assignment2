//
//  Date.swift
//  Assignment2
//
//  Created by Derrick Park on 2023-03-03.
//

import Foundation

struct Date: Comparable, Equatable, CustomStringConvertible {
  //------------------------------------------
  // Properties
  //------------------------------------------
  private let DEF_MONTH = 1
  private let DEF_DAY = 1
  private let DEF_YEAR = 2000
  
  private let monthsWith30days = [4, 6, 9, 11]
  private let monthsWith31days = [1, 3, 5, 7, 8, 10, 12]
  private let monthWith28days = 2
  
  private let monthNameDic = [
    1: "Jan", 2: "Feb", 3: "Mar",
    4: "Apr", 5: "May", 6: "Jun",
    7: "Jul", 8: "Aug", 9: "Sep",
    10: "Oct", 11: "Nov", 12: "Dec"
  ]
  
  private(set) var month:Int = 1
  private(set) var day:Int = 1
  private(set) var year:Int = 2000
  
  private var format = DateFormat.standard
  
  var description: String {
    return "\(month)/\(day)/\(year)"
  }
  
  //----------------------------------------
  // Methods
  //----------------------------------------
  init(){
    setDefProperty()
  }
  
  init(month:Int, day:Int, year:Int){
    if isValidMonth(month) && isValidDay(month, day) && isValidYear(year) {
      self.month = month
      self.day = day
      self.year = year
    } else {
      setDefProperty()
    }
  }
  
  mutating func input() {
    
    let errMsg = "Invalid date. Try again."
    
    while true {
      print("Enter a date (month/day/year): ", terminator: "")
      let input = readLine() ?? ""
      let dateInfo = input.split(separator: "/")
      
      // Input error check
      if (dateInfo.count != 3){
        print(errMsg)
        continue
      }
      // Input error check
      guard let month = Int(dateInfo[0]),
            let day = Int(dateInfo[1]),
            let year = Int(dateInfo[2]) else {
        
        print(errMsg)
        continue
      }
      // month, day and year format check
      if !(isValidMonth(month) && isValidDay(month, day) && isValidYear(year)){
        print(errMsg)
        continue
      }
      
      self.month = month
      self.day = day
      self.year = year
      break
    }
  }
  
  func show() {
    
    switch format {
    case .standard:
      print("\(month)/\(day)/\(year)")
    case .two:
      print("\(getTwoFormat(month))/\(getTwoFormat(day))/\(getTwoFormat(year))")
    case .long:
      print(getLongFormat(month: month, day: day, year: year))
    }
  }
  
  mutating func set(month:Int, day:Int, year:Int) -> Bool {
    if !(isValidMonth(month) && isValidDay(month, day) && isValidYear(year)){
      return false
    }
    
    self.month = month
    self.day = day
    self.year = year
    
    return true
  }
  
  mutating func setFormat(_ format:DateFormat) {
    self.format = format
  }
  
  mutating func increment(_ numDays:Int = 1){
    var _numDays = numDays
    
    if numDays >= 0 {
      while true {
        let lastDay = getLastDay(month: month)
        let restOfDate = lastDay - day
        
        if restOfDate >= _numDays {
          day += _numDays
          break
        }
        
        if isValidMonth(month + 1){
          month += 1
        } else {
          year += 1
          month = 1
        }
        day = 1
        _numDays = _numDays - restOfDate - 1
      }
    } else {
      while true {
        let restOfDate = day - 1
        
        if restOfDate >= abs(_numDays) {
          day += _numDays
          break
        }
        
        if isValidMonth(month - 1){
          month -= 1
        } else {
          year -= 1
          month = 12
        }
        day = getLastDay(month: month)
        _numDays += (restOfDate + 1)
      }
    }
  }
  
  private func isLastDay(month:Int, day:Int) -> Bool{
    var isLastDay = false
    if day == 30 && monthsWith30days.contains(month){
      isLastDay = true
    } else if day == 31 && monthsWith31days.contains(month){
      isLastDay = true
    } else if day == 28 && monthWith28days == month {
      isLastDay = true
    }
    
    return isLastDay
  }
  
  private func getLastDay(month:Int) -> Int {
    var lastDay = 0
    if monthsWith30days.contains(month){
      lastDay = 30
    } else if monthsWith31days.contains(month){
      lastDay = 31
    } else {
      lastDay = 28
    }
    
    return lastDay
  }
  
  
  //----------------------------------------------
  // Static Methods
  //----------------------------------------------
  static func <(lhs: Date, rhs:Date) -> Bool {
    
    if lhs.year < rhs.year {
      return true
    }
    
    if lhs.year == rhs.year {
      if lhs.month < rhs.month {
        return true
      }
      
      if lhs.month == rhs.month {
        if lhs.day < rhs.day {
          return true
        }
      }
    }
    
    return false
  }
  
  static func ==(lhs: Date, rhs:Date) -> Bool {
    
    return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
  }
  
  
  //-------------------------------------------------------
  // Private methods
  //-------------------------------------------------------
  private mutating func setDefProperty() {
    self.month = DEF_MONTH
    self.day = DEF_DAY
    self.year = DEF_YEAR
  }
  
  private func isValidMonth(_ month: Int) -> Bool {
    return 1 <= month && month <= 12
  }
  
  private func isValidDay(_ month:Int, _ day: Int) -> Bool {
    var isValid = false
    
    if monthsWith30days.contains(month) {
      if 1 <= day && day <= 30 {
        isValid = true
      }
    } else if monthsWith31days.contains(month) {
      if 1 <= day && day <= 31 {
        isValid = true
      }
    } else if monthWith28days == day {
      if 1 <= day && day <= 28 {
        isValid = true
      }
    }
    return isValid
  }
  
  private func isValidYear(_ year: Int) -> Bool {
    return year > 0
  }
  
  private func getTwoFormat(_ tgt:Int) -> String{
    
    let _tgt = String(tgt)
    
    var result = ""
    if _tgt.count == 1 {
      result = "0" + _tgt
    } else if _tgt.count == 4 {
      result = String(_tgt.suffix(2))
    } else {
      result = _tgt
    }
    
    return result
  }
  
  private func getLongFormat(month:Int, day:Int, year:Int) -> String {
    guard let monthName = monthNameDic[month] else {
      return ""
    }
    
    return "\(monthName) \(day), \(year)"
  }
}

enum DateFormat {
  case standard, long, two
}

