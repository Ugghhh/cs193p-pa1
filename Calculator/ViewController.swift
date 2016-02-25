//
//  ViewController.swift
//  Calculator
//
//  Created by Angelo Wong on 2/22/16.
//  Copyright © 2016 Stanford. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel! //implicit unwrapped optional
    
    var userIsInTheMiddleOfTypingANumber = false
    var operandStack = Array<Double>()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        let dupDecimal = decimalDupCheck(digit, display.text)
        if userIsInTheMiddleOfTypingANumber {
            if !dupDecimal {
                display.text = display.text! + digit
            }
        } else {
            display.text = digit == "." ? "0" + digit : digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    func decimalDupCheck(digit: String, _ text: String?) -> Bool {
        if userIsInTheMiddleOfTypingANumber {
            return digit == "." && text?.containsString(".") == true
        } else {
            return false
        }
    }

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter() //add to stack if say "6 enter 3 times"
        }
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "-": performOperation { $0 - $1 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π":
            if userIsInTheMiddleOfTypingANumber {
                enter()
            }
            displayValue = M_PI
            enter()
        default: break
        }
        

    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter() //after last 2 operands done, want to work on next op, example: "6 ent 3 ent times 9 plus"
        }
    }
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter() //after last 2 operands done, want to work on next op, example: "6 ent 3 ent times 9 plus"
        }
    }

    
    
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return display.text! == "π" ? M_PI : NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = newValue == M_PI ? "π" : "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

