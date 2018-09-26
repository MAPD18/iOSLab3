//
//  Engine.swift
//  Calculator
//
//  Created by Rodrigo Silva on 2018-09-25.
//  Copyright © 2018 Rodrigo Silva. All rights reserved.
//

import Foundation

class Engine {
    
    private var calculus = 0.0
    private var pending: PendingBinaryOperation?
    
    func setFirstNumber(first: Double) {
        calculus = first
    }
    
    private var operations: Dictionary = [
        "∏" : Operation.Constant(.pi),
        "√" : Operation.Unary(sqrt),
        "±" : Operation.Unary({ -$0 }),
        "sin" : Operation.Unary(sin),
        "cos" : Operation.Unary(cos),
        "%" : Operation.Binary({ $0/100 * $1 }),
        "×" : Operation.Binary({$0 * $1}),
        "÷" : Operation.Binary({$0 / $1}),
        "+" : Operation.Binary({$0 + $1}),
        "−" : Operation.Binary({$0 - $1}),
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
    
    func clear() {
        calculus = 0
        pending = nil
    }
    
    private struct PendingBinaryOperation {
        var firstNumber : Double
        var binaryOperation : (Double, Double) -> Double
    }
    
    private enum Operation {
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
