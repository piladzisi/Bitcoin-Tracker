//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var bitcoin: Bitcoin!
    var symbol = "$"
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        initializePrice()
}
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int { //number of columns in picker
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: currencyArray[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return attributedString
    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        symbol = getSymbol(forCurrencyCode: currencyArray[row])!
        getBitcoinData(url: finalURL, completion: bitcoinCompletionHandler)
        
    }
    
    
//    //MARK: - Networking
    
    func getBitcoinData(url: String, completion: @escaping (Result<Bitcoin, Error>) -> ()) {
        guard let url = URL(string: "\(finalURL)") else { return print("return")}
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            do {
                let bitcoin = try JSONDecoder().decode(Bitcoin.self, from: data!)
                DispatchQueue.main.async {
                    completion(.success(bitcoin))
                 }
            } catch let jsonError {
                completion(.failure(jsonError))
            }
            }.resume()
        }
   
    func setupView(bitcoin: Bitcoin) {
        bitcoinPriceLabel.text = "\(self.symbol) \(bitcoin.last)"
    }
    
    func initializePrice() {
        finalURL = baseURL+"USD"
        getBitcoinData(url: finalURL, completion: bitcoinCompletionHandler)
    }
    
    func bitcoinCompletionHandler(result: Result<Bitcoin, Error>) {
        switch result {
        case .success(let result):
            self.setupView(bitcoin: result)
        case .failure(let err):
            print("Failed to fetch bitcoin:", err)
        }
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        symbol = "$"
        initializePrice()
    }
 
}

