//
//  ViewController.swift
//  Calculator 1.0
//
//  Created by Rodrigo Silva on 2018-09-25.
//  Student ID 300993648
//  
//  Class responsible for Controlling the View using the business rules in Engine Model

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak private var resultLabel: UILabel!
    
    private var engine = Engine() // Model
    private var userIsTyping = false
    private var errorIsBeingShownInResultLabel = false
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
    
    public var backgroundColor = ""
    public var digitsTextColor = ""
    public var opetationsTextColor = ""
    
    private var colors : Dictionary = [
        "Red" : UIColor.red,
        "Yellow" : UIColor.yellow,
        "Green" : UIColor.green,
        "Blue" : UIColor.blue,
        "Black" : UIColor.black
    ]
    
    override func viewDidLoad() {
        if !backgroundColor.isEmpty {
            updateColors(views: self.view.subviews)
        }
    }
    
    let BUTTON_TAG_DIGIT = 458
    let BUTTON_TAG_OPERATION = 1452
    
    private func updateColors(views: [UIView]) {
        for view in views {
            if let button = view as? UIButton {
                if button.tag == BUTTON_TAG_DIGIT {
                    button.setTitleColor(colors[digitsTextColor], for: .normal)
                } else if button.tag == BUTTON_TAG_OPERATION {
                    button.backgroundColor = colors[backgroundColor]
                    button.setTitleColor(colors[opetationsTextColor], for: .normal)
                }
            } else if let label = view as? UILabel {
                label.backgroundColor = colors[backgroundColor]
            } else if let stackView = view as? UIStackView {
                updateColors(views: stackView.subviews)
            }
        }
    }

    // Function triggered by digits (0-9) pressed
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

    // Function triggered by Decimal Dot (.) pressed
    @IBAction private func onDecimalDotPress() {
        userJustPressedAnOperationButton = false
        let resultText = resultLabel.text!
        if !resultText.contains(".") {
            let currentText = resultLabel.text!
            resultLabel.text = currentText + "."
        }
    }
    
    // Function triggered by operation (+,-,...) pressed
    @IBAction private func onOperationPress(_ sender: UIButton) {
        // if there is an error being shown in the result label, the display is cleared and the operation is reset
        if errorIsBeingShownInResultLabel {
            clearResultLabel()
            errorIsBeingShownInResultLabel = false
            return
        }
        
        let mathSymbol = sender.currentTitle!
        
        // if user presses the operation buttons more than once
        if userPressedBinaryOperationButtonsMoreThanOnce(mathSymbol: mathSymbol) {
            if lastOperationSymbol == mathSymbol { // user is pressing the same operator, should ignore
                return
            } else { // user is pressing different operators, should replace pending operation in Engine
                engine.setCurrentValue(newValue: resultValue)
                userIsTyping = false
                engine.replacePendingBinaryOperation(newOperatorSymbol: mathSymbol)
                return
            }
        } else {
            if userIsTyping {
                engine.setCurrentValue(newValue: resultValue)
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
                errorIsBeingShownInResultLabel = false
                resultValue = engine.result
            }
        }
        userJustPressedAnOperationButton = true
        lastOperationSymbol = mathSymbol
    }
    
    private func userPressedBinaryOperationButtonsMoreThanOnce(mathSymbol: String) -> Bool {
        return userJustPressedAnOperationButton && engine.isBinaryOperator(mathSymbol: lastOperationSymbol) && engine.isBinaryOperator(mathSymbol: mathSymbol)
    }
    
    // Function triggered when the display action buttons "AC" or "⌫" are pressed
    @IBAction private func onDisplayActionPress(_ sender: UIButton) {
        userJustPressedAnOperationButton = false
        let actionSymbol = sender.currentTitle!
        doDisplayAction(symbol: actionSymbol)
    }
    
    // Shows an error message in the resultLabel
    private func showError(message: String) {
        resultLabel.text = message
        errorIsBeingShownInResultLabel = true
    }
    
    // Does Clear of Backspace actions to the resultLabel
    private func doDisplayAction(symbol: String) {
        if let action = displayActions[symbol] {
            switch action {
            case .Clear: 
                clearResultLabel()
                engine.clear()
            case .Backspace:
                var currentLabel = resultLabel.text!
                if errorIsBeingShownInResultLabel || currentLabel.count == 1 {
                    clearResultLabel()
                } else {
                    deleteLastDigit(currentLabel: &currentLabel)
                }
            }
        }
    }
    
    // Deletes last digit of the resultLabel and updates the currentValue inside Engine
    private func deleteLastDigit(currentLabel: inout String) {
        resultLabel.text! = String(currentLabel.dropLast())
        engine.setCurrentValue(newValue: Double(currentLabel)!)
        userIsTyping = true
    }
    
    // Clears the resultLabel UIView and resets the resultValue to zero
    private func clearResultLabel() {
        userIsTyping = false
        resultValue = 0
    }
    
    // Dictionary linking the characters to it's relative enum DisplayAction
    private let displayActions: Dictionary = [
        "AC" : DisplayAction.Clear,
        "⌫" : DisplayAction.Backspace,
    ]
    
    // Enum for describing the possible display action buttons
    private enum DisplayAction {
        case Clear
        case Backspace
    }
}
