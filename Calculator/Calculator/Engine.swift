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
    
    func setFirstNumber(first: Double) {
        calculus = first
    }
    
    func doOperation(mathSymbol: String) {
        switch mathSymbol {
        case "√": calculus = sqrt(calculus)
        case "∏": calculus = .pi
        default:
            break;
        }
    }
    
    var result : Double {
        get {
            return calculus
        }
    }
}
