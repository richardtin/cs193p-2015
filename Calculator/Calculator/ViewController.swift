//
//  ViewController.swift
//  Calculator
//
//  Created by Richard Ting on 1/31/15.
//  Copyright (c) 2015 Richard Ting. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfTypingANumber = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if display.text!.rangeOfString(".") == nil || digit != "." {
                display.text = display.text! + digit
            }
        } else {
            if digit == "." {
                if displayValue > 0 {
                    display.text = "0"
                }
                display.text = display.text! + digit
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        history.text! = ""
        display.text! = "0"
        operandStack.removeAll(keepCapacity: false)
        historyStack.removeAll(keepCapacity: false)
    }

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        // FIXME: this line will make duplicate operation history
        historyStack.append(operation)

        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π": performOperation { M_PI }
        default: break
        }
    }

    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }

    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }

    func performOperation(operation: () -> Double) {
        displayValue = operation()
        enter()
    }

    var operandStack = Array<Double>()
    var historyStack = Array<String>()
    @IBAction func enter() {
        if userIsInTheMiddleOfTypingANumber {
            historyStack.append(display.text!)
        }
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack), historyStack = \(historyStack)")
        history.text = "\(historyStack)"
    }

    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }

}

