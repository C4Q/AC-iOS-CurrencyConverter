//
//  Currency.swift
//  CurrencyConverter-ClassNotes
//
//  Created by C4Q  on 11/27/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct Currency: Codable {
    let base: String
    let rates: [String: Double]
}
