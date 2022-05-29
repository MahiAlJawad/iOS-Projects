//
//  ResultViewController.swift
//  Tipsy
//
//  Created by Mahi Al Jawad on 29/5/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var resultMessage: UILabel!
    
    var result: Result!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showResult()

    }
    
    func showResult() {
        resultLabel.text =  String(format: "%.2f", result.billPerPerson)
        resultMessage.text = "Split between \(result.numberOfPersons) people, with \(result.percentage)% tip."
    }
    
    
    @IBAction func recalculateTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
