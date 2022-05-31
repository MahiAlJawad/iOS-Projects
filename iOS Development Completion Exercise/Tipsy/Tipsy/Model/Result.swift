//
//  Result.swift
//  Tipsy
//
//  Created by Mahi Al Jawad on 29/5/22.
//

import Foundation

final class Result {
    let billPerPerson: Float
    let numberOfPersons: Int
    let percentage: Int
    
    init(billPerPerson: Float, numberOfPersons: Int, percentage: Int) {
        self.billPerPerson = billPerPerson
        self.numberOfPersons = numberOfPersons
        self.percentage = percentage
    }
}
