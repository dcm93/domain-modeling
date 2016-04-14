//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

public class TestMe {
  public func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
    
    init(amount: Int, currency: String){
        self.currency = currency
        self.amount = amount
    }
  
  public func convert(to: String) -> Money {
    if(to == "GBP"){
        if(self.currency == "USD"){
            return Money(amount: Int(Double(self.amount) / 2), currency: "GBP")
        } else if (self.currency == "CAN"){
            return Money(amount: Int(Double(self.amount) / (1.25 * 2.0)), currency:"GBP")
        } else { //if(self.currency == "EUR"){
            return Money(amount: Int(Double(self.amount) / (1.5 * 2.0)), currency :"GBP")
        }
    } else if (to == "CAN"){
        if(self.currency == "USD"){
            return Money(amount:Int(Double(self.amount) * 1.25), currency: "CAN")
        } else if (self.currency == "GBP"){
            return Money(amount:Int(Double(self.amount) / (1.25 * 2)), currency: "CAN")
        } else { //if (self.currency == "EUR"){
            return Money(amount: Int(Double(self.amount) / (1.5 * 2)), currency: "CAN")
        }
    } else if (to == "EUR"){
        if(self.currency == "CAN"){
            return Money(amount: Int(Double(self.amount) * (1.5 * 1.25)), currency: "EUR")
        } else if(self.currency == "GBP"){
            return Money(amount:Int(Double(self.amount) * 2.0 / 1.5), currency: "EUR")
        } else { //if (self.currency == "USD"){
            return Money(amount: Int(Double(self.amount) * 1.5), currency: "EUR")
        }
    } else { //to == "USD"
        if(self.currency == "GBP"){
            return Money(amount: self.amount * 2, currency: "USD")
        } else if(self.currency == "CAN"){
            return Money(amount: Int(Double(self.amount) / 1.25), currency: "USD")
        } else { // if self.currency == "EUR"
            return Money(amount:Int(Double(self.amount) / 1.5), currency: "USD")
        }
    }
}
    
public func add(to: Money) -> Money {
    if(self.currency != to.currency){
        return Money(amount: (self.convert(to.currency).amount + to.amount), currency: to.currency)
    } else {
        return Money(amount: self.amount + to.amount, currency: to.currency)
    }
}
  public func subtract(from: Money) -> Money {
    if(self.currency != from.currency){
        return Money(amount: (from.amount - self.convert(from.currency).amount), currency: from.currency)
    } else {
        return Money(amount: from.amount - self.amount, currency: from.currency)
    }
    
  }
}

////////////////////////////////////
// Job
//
public class Job {
    public var title:String
    public var type: JobType
  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  public func calculateIncome(hours: Int) -> Int {
    switch self.type {
    case.Hourly(let value):
        return Int(value * Double(hours))
    case.Salary(let value):
        return value
    }
}
  
 public func raise(amt : Double) {
    switch self.type{
    case.Hourly(let value):
        self.type = JobType.Hourly((value + amt))
    case.Salary(let value):
        self.type = JobType.Salary(Int(Double(value) + amt))
    }
  }
}
//
//////////////////////////////////////
//// Person
//
public class Person {
  public var firstName : String = ""
  public var lastName : String = ""
  public var age : Int = 0
    private var _job: Job?
  public var job : Job? {
    get {
        return _job
    }
    set(value) {
        if(self.age >= 16){
            _job = value
        }
    }
  }
    private var _spouse: Person?
  public var spouse : Person? {
    get {
        return _spouse
    }
    set(value) {
        if(self.age >= 18){
            _spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  public func toString() -> String {
    //    XCTAssert(ted.toString() == "[Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]")
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job) spouse:\(self.spouse)]"
  }
}
//
//////////////////////////////////////
//// Family
////
public class Family {
  private var members : [Person] = []
  
  init(spouse1: Person, spouse2: Person) {
    if(spouse1.spouse == nil && spouse2.spouse == nil){
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }
  
  public func haveChild(child: Person) -> Bool {
    var isLegal = true
    for member in members {
        if(member.age < 21){
            isLegal = false
        }
    }
    return isLegal
  }
  
  public func householdIncome() -> Int {
    var result: Int = 0
    for member in members{
        result = result + member.job!.calculateIncome()
    }
    return result
  }
}
//
//
//
//
//
