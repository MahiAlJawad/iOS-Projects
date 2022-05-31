//
//  ShareBillViewModel.swift
//  Tipsy
//
//  Created by Mahi Al Jawad on 29/5/22.
//

import Foundation

class ShareBillViewModel {
    private let _result: Result?
    
    private let total: Float
    private let numberOfPeople: Int
    private let percentage: Int
    
    init(totalBill: Float, numberOfPeople: Int, tipPercentage: Int) {
        total = totalBill
        self.numberOfPeople = numberOfPeople
        percentage = tipPercentage
        
        if numberOfPeople != 0, totalBill != 0 {
            let billPerPerson = (total + (total * (Float(percentage)/100.0))) / Float(numberOfPeople)
            _result = Result(billPerPerson: billPerPerson, numberOfPersons: numberOfPeople, percentage: percentage)
        } else {
            _result = nil
        }
    }
    
    var result: Result? { _result }
}
