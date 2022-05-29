//
//  ViewController.swift
//  Calculator
//
//  Created by Mahi Al Jawad on 12/4/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var displayLabel: UILabel!
    
    var lastInputType: ButtonType?
    var operation: BinaryOperator?
    var result: Double = 0
    
    override func viewDidLoad() {
        print("[Calculator] ViewDidLoad")
        super.viewDidLoad()
    }

    @IBAction func buttonTapped(_ sender: Any) {
        let button = sender as! UIButton
        print("[Calculator] Button tapped: \(String(describing: button.titleLabel?.text)) Tag: \(button.tag)")
        let buttonType = getButtonType(buttonTag: button.tag)
        
        switch buttonType {
        case .number:
            handleNumber(buttonTag: button.tag)
        case .binaryOperator:
            handleBinaryOps(buttonTag: button.tag)
        case .equalOperator:
            handleEqualOperation()
        case .clear:
            clear()
        case .allClear:
            clearAll()
        case .sqroot:
            handleSqRoot()
        }
        
        lastInputType = buttonType
    }
}

// MARK: Handle button tap operations
extension ViewController {
    func clear() {
        var currentText = displayLabel.text
        currentText?.removeLast()
        displayLabel.text = currentText
    }
    
    func clearAll() {
        displayLabel.text = "0"
        result = 0
        lastInputType = nil
        operation = nil
    }
    
    func handleSqRoot() {
        var displayText = displayLabel.text ?? ""
        if displayText.last == "." { displayText.removeLast() }
        
        let inputValue = Double(displayText) ?? 0
        let sqRootValue = sqrt(inputValue)
        displayLabel.text = processInput(input: sqRootValue)
        result = sqRootValue
        lastInputType = nil
        operation = nil
    }
    
    func handleNumber(buttonTag: Int) {
        if lastInputType != .number { displayLabel.text = "0" }
        
        if displayLabel.text == "0" {
            displayLabel.text = String(buttonTag)
        } else {
            var text = displayLabel.text ?? ""
            text += buttonTag == 10 ? "." : String(buttonTag)
            displayLabel.text = text
        }
    }
    
    func handleBinaryOps(buttonTag: Int) {
        guard let operation = getBinaryOpsType(buttonTag: buttonTag) else {
            print("[Calculator] Unsupported operation")
            return
        }
        if lastInputType != .binaryOperator { handleEqualOperation() }
        self.operation = operation
    }
    
    func handleEqualOperation() {
        var displayText = displayLabel.text ?? ""
        if displayText.last == "." { displayText.removeLast() }
        
        let inputValue = Double(displayText) ?? 0
        
        if self.operation == nil {
            result = inputValue
        } else {
            switch self.operation {
            case .plus: result += inputValue
            case .minus: result -= inputValue
            case .multiplication: result *= inputValue
            case .division:
                if inputValue != 0 { result /= inputValue }
                else { result = 0 }
            default: result = 0
            }
        }
        self.displayLabel.text = processInput(input: result)
        self.operation = nil
    }
}

// MARK: Button type helper
extension ViewController {
    enum ButtonType {
        case number, binaryOperator, equalOperator, clear, allClear, sqroot
    }
    
    enum BinaryOperator {
        case plus, minus, multiplication, division
    }
    
    private func getButtonType(buttonTag: Int) -> ButtonType {
        switch buttonTag {
        case 11                 : return .equalOperator
        case 12, 13, 14, 15     : return .binaryOperator
        case 16                 : return .allClear
        case 17                 : return .clear
        case 18                 : return .sqroot
        default                 : return .number
        }
    }
    
    private func getBinaryOpsType(buttonTag: Int) -> BinaryOperator? {
        switch buttonTag {
        case 12 : return .plus
        case 13 : return .minus
        case 14 : return .multiplication
        case 15 : return .division
        default : return nil
        }
    }
}

// MARK: Other helpers
extension ViewController {
    private func processInput(input: Double) -> String {
        let inputInInt = Double(Int(input))
        if (input - inputInInt) == 0 { // Has trailing zero after decimal point
            return String(Int(input))
        } else {
            return String(input)
        }
    }
}
