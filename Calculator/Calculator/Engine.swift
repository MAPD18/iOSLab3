//
//  Engine.swift
//  Calculator
//
//  Created by Rodrigo Silva on 2018-09-25.
//  Copyright © 2018 Rodrigo Silva. All rights reserved.
//

import Foundation

func multiply(first: Double, second: Double) -> Double {
        return first * second
}

class Engine {
    
    private var calculus = 0.0
    
    func setFirstNumber(first: Double) {
        calculus = first
    }
    
    private var operations: Dictionary = [
        "∏" : Operation.Constant(.pi),
        "√" : Operation.Unary(sqrt),
        "cos" : Operation.Unary(cos),
        "×" : Operation.Binary(multiply)
    ]
    
    func doOperation(mathSymbol: String) {
        if let operation = operations[mathSymbol] {
            switch operation {
            case .Constant(let value) : calculus = value
            case .Unary(let unaryOperation) : calculus = unaryOperation(calculus)
            case .Binary(let binaryOperation) : break
            case .Equals : break
            }
        }
    }
    
    struct PendingBinaryOperation {
        var firstNumber : Double
        var bynaryOperation : (Double, Double) -> Double
    }
    
    enum Operation {
        case Constant(Double)
        case Unary((Double) -> Double)
        case Binary((Double, Double) -> Double)
        case Equals
    }
    
    var result : Double {
        get {
            return calculus
        }
    }
}
