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

func sum(first: Double, second: Double) -> Double {
    return first + second
}

func subtract(first: Double, second: Double) -> Double {
    return first - second
}

func divide(first: Double, second: Double) -> Double {
    return first / second
}

class Engine {
    
    private var calculus = 0.0
    private var pending: PendingBinaryOperation?
    
    func setFirstNumber(first: Double) {
        calculus = first
    }
    
    private var operations: Dictionary = [
        "∏" : Operation.Constant(.pi),
        "√" : Operation.Unary(sqrt),
        "cos" : Operation.Unary(cos),
        "×" : Operation.Binary(multiply),
        "÷" : Operation.Binary(divide),
        "+" : Operation.Binary(sum),
        "−" : Operation.Binary(subtract),
        "=" : Operation.Equals
    ]
    
    func doOperation(mathSymbol: String) {
        if let operation = operations[mathSymbol] {
            switch operation {
            case .Constant(let value):
                calculus = value
            case .Unary(let unaryOperation):
                calculus = unaryOperation(calculus)
            case .Binary(let binaryOperation):
                executePendingOperation()
                pending = PendingBinaryOperation(firstNumber: calculus, binaryOperation: binaryOperation)
            case .Equals:
                executePendingOperation()
            }
        }
    }
    
    func executePendingOperation() {
        if pending != nil {
            calculus = pending!.binaryOperation(pending!.firstNumber, calculus)
            pending = nil
        }
    }
    
    struct PendingBinaryOperation {
        var firstNumber : Double
        var binaryOperation : (Double, Double) -> Double
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
