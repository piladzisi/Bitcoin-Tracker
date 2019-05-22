//
//  Bitcoin.swift
//  BitcoinTicker
//
//  Created by anna.sibirtseva on 16/05/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

struct Bitcoin: Decodable {
    let last: Double
    let ask: Double
    let bid: Double
    let high: Double
    let low: Double
}


let currencyArray = ["USD", "AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","ZAR"]
