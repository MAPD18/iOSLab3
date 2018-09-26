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
    @IBOutlet weak private var historicLabel: UILabel!
    
    private var engine = Engine()
    private var userIsTyping = false
    private var resultValue: Double {
        get {
            return Double(resultLabel.text!)!
        }
        set {
            resultLabel.text = String(newValue)
        }
    }
    private var errorIsShownInResultLabel = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction private func onDigitPress(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if (userIsTyping) {
            let currentText = resultLabel.text!
            resultLabel.text = currentText + digit
        } else {
            resultLabel.text = digit
            userIsTyping = true
        }
    }
    
    @IBAction private func onOperationPress(_ sender: UIButton) {
        if (userIsTyping) {
            engine.setFirstNumber(first: resultValue)
            userIsTyping = false
        }
        
        let mathSymbol = sender.currentTitle!
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
    
    func showError(message: String) {
        resultLabel.text = message
        errorIsShownInResultLabel = true
    }
    
    @IBAction func onDisplayActionPress(_ sender: UIButton) {
        let actionSymbol = sender.currentTitle!
        doDisplayAction(symbol: actionSymbol)
    }
    
    func doDisplayAction(symbol: String) {
        if let action = displayActions[symbol] {
            switch action {
            case .Clear: 
                userIsTyping = false
                resultValue = 0
                engine.clear()
            case .Backspace:
                let currentLabel = resultLabel.text!
                if errorIsShownInResultLabel || currentLabel.count == 1 {
                    resultLabel.text = "0"
                    userIsTyping = false
                    engine.clear()
                } else {
                    var backspacedLabel = resultLabel.text!
                    backspacedLabel = String(backspacedLabel.dropLast())
                    resultLabel.text! = backspacedLabel
                    userIsTyping = true
                }
            }
        }
    }
    
    let displayActions: Dictionary = [
        "AC" : DisplayAction.Clear,
        "⌫" : DisplayAction.Backspace
    ]
    
    enum DisplayAction {
        case Clear
        case Backspace
    }
    
}
