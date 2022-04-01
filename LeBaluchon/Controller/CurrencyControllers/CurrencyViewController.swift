//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 17/03/2022.
//

import UIKit

final class CurrencyViewController: UIViewController {
    
    

    @IBOutlet weak var valueToConvertTextField: UITextField!
    @IBOutlet weak var valueConvertedTextField: UITextField!
    
    
    private let currencyService = CurrencyService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyService.fetchConversionRates { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let rates):
                    print(rates)
                }
            }
        }
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        valueToConvertTextField.resignFirstResponder()
        valueConvertedTextField.resignFirstResponder()
    }
    
}


































