//
//  ViewController.swift
//  Calculator
//
//  Created by Alec Charbonneau on 12/28/17.
//  Copyright © 2017 Alec Charbonneau. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var operationsDisplay: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    
    private var displayValue: Double! {
        get{
            return Double(display.text!)
        }
        set{
            display.text = String(newValue) // new value is built in
        }
    }
    
    private var brain = CalculatorBrain()
    
    // MARK: Private Properties
    
    private func updateOperationsDisplay() {
        operationsDisplay.text = brain.description
    }
    
    
    // MARK: Actions
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit: String! = sender.currentTitle
        let textCurrentlyInDisplay: String! = display.text
        
        if digit == "." {
            if display.text!.contains(".") {
                userIsInTheMiddleOfTyping = true
                display.text = "."
                return
            }
        }
        
        brain.description.append(digit)
        
        if userIsInTheMiddleOfTyping {
            display.text = textCurrentlyInDisplay + digit
        }
        else{
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        updateOperationsDisplay()
    }
    @IBAction private func performOperation(_ sender: UIButton) {
        if display.text == "." {    // can't do operations on a .
            userIsInTheMiddleOfTyping = false
            if sender.currentTitle != "C"{
                return
            }
        }
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
        updateOperationsDisplay()
    }
}

