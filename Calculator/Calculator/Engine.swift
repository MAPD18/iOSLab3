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
    private var lastOperation: LastOperation?
    
    func setFirstNumber(first: Double) {
        calculus = first
    }
    
    private var operations: Dictionary = [
        "∏" : Operation.Constant(.pi),
        "√" : Operation.Unary(sqrt),
        "±" : Operation.Unary({ $0 == 0 ? 0 : -$0 }),
        "sin" : Operation.Unary(sin),
        "cos" : Operation.Unary(cos),
        "%" : Operation.Unary({$0/100}),
        "×" : Operation.Binary({$0 * $1}),
        "÷" : Operation.Binary({$0 / $1}),
        "+" : Operation.Binary({$0 + $1}),
        "−" : Operation.Binary({$0 - $1}),
        "=" : Operation.Equals
    ]
    
    // function only returns false when
    func doOperation(mathSymbol: String) -> ResponseStatus {
        if let operation = operations[mathSymbol] {
            switch operation {
            case .Constant(let value):
                calculus = value
            case .Unary(let unaryOperation):
                calculus = unaryOperation(calculus)
                if calculus.isNaN {
                    calculus = 0
                    return .CannotHandleImaginaryNumbers
                }
            case .Binary(let binaryOperation):
                let responseStatus = executePendingOperation()
                if responseStatus == .Valid {
                    pending = PendingBinaryOperation(firstNumber: calculus, binaryOperation: binaryOperation, operationIdentifier: mathSymbol)
                } else {
                    return responseStatus
                }
            case .Equals:
                return executePendingOperation()
            }
            return .Valid
        }
        return .InvalidOperation
    }
    
    // funcion only returns false when the operation is not valid
    func executePendingOperation() -> ResponseStatus {
        if pending != nil {
            if calculus == 0 && pending!.operationIdentifier == "÷" {
                clear()
                return .CannotDivideByZero
            } else {
                calculus = pending!.binaryOperation(pending!.firstNumber, calculus)
                pending = nil
                return .Valid
            }
        }
        return .Valid
    }
    
    func replacePendingOperation(newOperatorSymbol: String) {
        if pending != nil {
            if let operation = operations[newOperatorSymbol] {
                switch operation {
                case .Binary(let binaryOperation):
                    pending = PendingBinaryOperation(firstNumber: calculus, binaryOperation: binaryOperation, operationIdentifier: newOperatorSymbol)
                default:
                    return
                }
            }
        }
    }
    
    func clear() {
        calculus = 0
        pending = nil
    }
    
    func isBinaryOperator(mathSymbol: String) -> Bool {
        if let operation = operations[mathSymbol] {
            switch operation {
            case .Binary(_):
                return true
            default:
                return false
            }
        }
        return false
    }
    
    private struct PendingBinaryOperation {
        var firstNumber : Double
        var binaryOperation : (Double, Double) -> Double
        var operationIdentifier : String
    }
    
    private struct LastOperation {
        var firstNumber : Double
        var secondNumber : Double
        var operationIdentifier : String
    }
    
    private enum Operation {
        case Constant(Double)
        case Unary((Double) -> Double)
        case Binary((Double, Double) -> Double)
        case Equals
    }
    
    public enum ResponseStatus {
        case Valid
        case CannotDivideByZero
        case CannotHandleImaginaryNumbers
        case InvalidOperation
    }
    
    var result : Double {
        get {
            return calculus
        }
    }
}
