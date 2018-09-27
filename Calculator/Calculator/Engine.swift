//
//  Engine.swift
//  Calculator 1.0
//
//  Created by Rodrigo Silva on 2018-09-25.
//  Student ID 300993648
//
//  Class responsible for the business rules of the Calculator
//

import Foundation

class Engine {
    
    private var currentValue = 0.0
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    // public computable variable for comunication with the ViewController
    var result : Double {
        get {
            return currentValue
        }
    }
    
    // Updates current value
    func setCurrentValue(newValue: Double) {
        currentValue = newValue
    }
    
    // Executes the given operation and returns a Response
    func doOperation(mathSymbol: String) -> Response {
        if let operation = operations[mathSymbol] {
            switch operation {
            case .Constant(let value):
                currentValue = value
            case .Unary(let unaryOperation):
                currentValue = unaryOperation(currentValue)
                if currentValue.isNaN {
                    currentValue = 0
                    return .CannotHandleImaginaryNumbers
                }
            case .Binary(let binaryOperation):
                let responseStatus = executePendingBinaryOperation()
                if responseStatus == .Valid {
                    pendingBinaryOperation = PendingBinaryOperation(firstNumber: currentValue, binaryOperation: binaryOperation, operationIdentifier: mathSymbol)
                } else {
                    return responseStatus
                }
            case .Equals:
                return executePendingBinaryOperation()
            }
            return .Valid
        }
        return .InvalidOperation
    }
    
    // Executes binary pending operation
    private func executePendingBinaryOperation() -> Response {
        if pendingBinaryOperation != nil {
            if currentValue == 0 && pendingBinaryOperation!.operationIdentifier == "÷" {
                clear()
                return .CannotDivideByZero
            } else {
                currentValue = pendingBinaryOperation!.binaryOperation(pendingBinaryOperation!.firstNumber, currentValue)
                pendingBinaryOperation = nil
                return .Valid
            }
        }
        return .Valid
    }
    
    // Replaces binary pending operation by another binary operation
    func replacePendingBinaryOperation(newOperatorSymbol: String) {
        if pendingBinaryOperation != nil {
            if let operation = operations[newOperatorSymbol] {
                switch operation {
                case .Binary(let binaryOperation):
                    pendingBinaryOperation = PendingBinaryOperation(firstNumber: currentValue, binaryOperation: binaryOperation, operationIdentifier: newOperatorSymbol)
                default:
                    return
                }
            }
        }
    }
    
    // Clears value and pending operation
    func clear() {
        currentValue = 0
        pendingBinaryOperation = nil
    }
    
    // Checks if the math symbol is a binary operation
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
    
    // Dictionary linking the characters to it's relative Operations
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
    
    // Enum describing the possible operations
    private enum Operation {
        case Constant(Double)
        case Unary((Double) -> Double)
        case Binary((Double, Double) -> Double)
        case Equals
    }
    
    // Struct to cache the first part of a binary operation
    private struct PendingBinaryOperation {
        var firstNumber : Double
        var binaryOperation : (Double, Double) -> Double
        var operationIdentifier : String
    }
    
    // Enum describing the possible operation responses
    public enum Response {
        case Valid
        case CannotDivideByZero
        case CannotHandleImaginaryNumbers
        case InvalidOperation
    }
    
    
}
