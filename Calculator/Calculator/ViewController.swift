//
//  ViewController.swift
//  Calculator
//
//  Created by Rodrigo Silva on 2018-09-25.
//  Copyright © 2018 Rodrigo Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak private var resultLabel: UILabel!
    
    private var engine = Engine()
    private var userIsTyping = false
    private var errorIsShownInResultLabel = false
    private var userJustPressedAnOperationButton = false
    private var lastOperationSymbol = ""
    private var resultValue: Double {
        get {
            return Double(resultLabel.text!)!
        }
        set {
            resultLabel.text = String(newValue)
        }
    }

    @IBAction private func onDigitPress(_ sender: UIButton) {
        userJustPressedAnOperationButton = false
        let digit = sender.currentTitle!
        
        if userIsTyping {
            let currentText = resultLabel.text!
            resultLabel.text = currentText + digit
        } else {
            resultLabel.text = digit
            userIsTyping = true
        }
    }

    @IBAction func onDecimalDotPress() {
        userJustPressedAnOperationButton = false
        let resultText = resultLabel.text!
        if !resultText.contains(".") {
            let currentText = resultLabel.text!
            resultLabel.text = currentText + "."
        }
    }
    
    @IBAction private func onOperationPress(_ sender: UIButton) {
        if errorIsShownInResultLabel {
            clearDisplay()
            errorIsShownInResultLabel = false
            return
        }
        
        let mathSymbol = sender.currentTitle!
        
        if userJustPressedAnOperationButton && engine.isBinaryOperator(mathSymbol: lastOperationSymbol) && engine.isBinaryOperator(mathSymbol: mathSymbol) {
            if lastOperationSymbol == mathSymbol {
                return
            } else {
                engine.setFirstNumber(first: resultValue)
                userIsTyping = false
                engine.replacePendingOperation(newOperatorSymbol: mathSymbol)
                return
            }
        } else {
            if userIsTyping {
                engine.setFirstNumber(first: resultValue)
                userIsTyping = false
            }
            
            let responseStatus = engine.doOperation(mathSymbol: mathSymbol)
            switch responseStatus {
            case .CannotDivideByZero:
                showError(message: "Cannot divide by zero")
            case .CannotHandleImaginaryNumbers:
                showError(message: "Cannot handle imaginary numbers")
            case .InvalidOperation:
                showError(message: "Invalid Operation")
            case .Valid:
                errorIsShownInResultLabel = false
                resultValue = engine.result
            }
        }
        userJustPressedAnOperationButton = true
        lastOperationSymbol = mathSymbol
    }
    
    @IBAction func onDisplayActionPress(_ sender: UIButton) {
        userJustPressedAnOperationButton = false
        let actionSymbol = sender.currentTitle!
        doDisplayAction(symbol: actionSymbol)
    }
    
    func showError(message: String) {
        resultLabel.text = message
        errorIsShownInResultLabel = true
    }
    
    func doDisplayAction(symbol: String) {
        if let action = displayActions[symbol] {
            switch action {
            case .Clear: 
                clearDisplay()
                engine.clear()
            case .Backspace:
                var currentLabel = resultLabel.text!
                if errorIsShownInResultLabel || currentLabel.count == 1 {
                    clearDisplay()
                } else {
                    deleteLastDigit(currentLabel: &currentLabel)
                }
            }
        }
    }
    
    func deleteLastDigit(currentLabel: inout String) {
        resultLabel.text! = String(currentLabel.dropLast())
        engine.setFirstNumber(first: Double(currentLabel)!)
        userIsTyping = true
    }
    
    func clearDisplay() {
        userIsTyping = false
        resultValue = 0
    }
    
    let displayActions: Dictionary = [
        "AC" : DisplayAction.Clear,
        "⌫" : DisplayAction.Backspace,
    ]
    
    enum DisplayAction {
        case Clear
        case Backspace
    }
    
}
