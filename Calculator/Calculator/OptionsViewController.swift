//
//  OptionsViewController.swift
//  Calculator
//
//  Created by Rodrigo Silva on 2018-10-11.
//  Copyright © 2018 Rodrigo Silva. All rights reserved.
//

//
//  OptionsViewController.swift
//  Calculator 1.1
//
//  Created by Rodrigo Silva on 2018-10-11.
//  Student ID 300993648
//
//  Class responsible for Controlling the Options View where the user can select colors

import UIKit

class OptionsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var digitsTextColorPickerView: UIPickerView!
    @IBOutlet weak var operationTextColorPickerView: UIPickerView!
    @IBOutlet weak var backgroundPickerView: UIPickerView!
    
    @IBAction func save(_ sender: UIButton) {
        
    }
    
    var digitsPickerRow = 0
    var operationPickerRow = 0
    var backgroundPickerRow = 0
    
    let colors = ["Black","Red","Yellow","Green","Blue"]
    
    // UIPicker protocol function
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPicker protocol function that gets the number of options for the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    // UIPicker protocol function that captures user selection
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case digitsTextColorPickerView:
            digitsPickerRow = row
        case operationTextColorPickerView:
            operationPickerRow = row
        case backgroundPickerView:
            backgroundPickerRow = row
        default:
            break
        }
        return colors[row]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initPickerViews()
    }
    
    // Function thet nitializes all Pickers
    func initPickerViews() {
        backgroundPickerView.delegate = self
        backgroundPickerView.dataSource = self
        operationTextColorPickerView.delegate = self
        operationTextColorPickerView.dataSource = self
        digitsTextColorPickerView.delegate = self
        digitsTextColorPickerView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ViewController {
            dest.backgroundColor = colors[backgroundPickerRow]
            dest.digitsTextColor = colors[digitsPickerRow]
            dest.opetationsTextColor = colors[operationPickerRow]
        }
    }

}
