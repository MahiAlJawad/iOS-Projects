//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateTitle()
    }
    
    func animateTitle() {
        titleLabel.text = ""
        
        let title = Constants.appName
        var index = 0
        
        for letter in title {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(index), repeats: false) { _ in
                self.titleLabel.text?.append(letter)
            }
            index += 1
        }
    }
}
