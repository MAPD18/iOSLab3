//
//  ViewController.swift
//  Calculator
//
//  Created by Rodrigo Silva on 2018-09-25.
//  Copyright © 2018 Rodrigo Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var historicLabel: UILabel!
    
    var userIsTyping = false
    var resultValue: Double {
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

    @IBAction func onDigitPress(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if (userIsTyping) {
            let currentText = resultLabel.text!
            resultLabel.text = currentText + digit
        } else {
            resultLabel.text = digit
            userIsTyping = true
        }
    }
    
    @IBAction func onOperationPress(_ sender: UIButton) {
        userIsTyping = false
        let mathSymbol = sender.currentTitle!
        if mathSymbol == "√" {
            resultValue = sqrt(resultValue)
        } else if mathSymbol == "∏" {
            resultValue = .pi
        }
        
    }
}
