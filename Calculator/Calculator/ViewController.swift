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
        engine.doOperation(mathSymbol: mathSymbol)
        resultValue = engine.result
        
    }
}
