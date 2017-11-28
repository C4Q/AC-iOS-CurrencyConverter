//
//  ViewController.swift
//  CurrencyConverter-ClassNotes
//
//  Created by C4Q  on 11/27/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var basePickerView: UIPickerView!
    @IBOutlet weak var currencyTwoPickerView: UIPickerView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    
    var allCurrencies = [String]()
    
    var baseCurrency: Currency? {
        didSet {
            allCurrencies = ([baseCurrency!.base] + baseCurrency!.rates.keys).sorted()
            basePickerView.reloadAllComponents()
            currencyTwoPickerView.reloadAllComponents()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basePickerView.dataSource = self
        basePickerView.delegate = self
        currencyTwoPickerView.dataSource = self
        currencyTwoPickerView.delegate = self
        loadData()
    }
    
    func loadData(from currencyInitials: String = "USD") {
        let url = "https://api.fixer.io/latest?base=\(currencyInitials)"
        let completion: (Currency) -> Void = {(currency: Currency) in
            self.baseCurrency = currency
        }
        CurrencyAPIClient.manager.getCurrency(from: url, completionHandler: completion, errorHandler: {print($0)})
    }
    
    
    @IBAction func convertButtonPressed(_ sender: Any) {
        if let moneyAmountStr = self.inputTextField.text {
            if let moneyAmount = Double(moneyAmountStr) {
                let currencyStr = allCurrencies[self.currencyTwoPickerView.selectedRow(inComponent: 0)]
                let finalAmount = (self.baseCurrency!.rates[currencyStr] ?? 1) * moneyAmount
                outputLabel.text = "\(finalAmount)"
            }
        }
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.allCurrencies.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allCurrencies[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case basePickerView:
            loadData(from: self.allCurrencies[row])
        default:
            break
        }
    }
}



