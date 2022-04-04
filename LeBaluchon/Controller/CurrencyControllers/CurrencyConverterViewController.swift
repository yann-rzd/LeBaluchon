//
//  CurrencyConverterViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 17/03/2022.
//

import UIKit

final class CurrencyConverterViewController: UIViewController {
    @IBOutlet weak var valueToConvertTextField: UITextField!
    @IBOutlet weak var valueConvertedTextField: UITextField!
    
    @IBOutlet weak var sourceCurrencyButton: UIButton!
    @IBOutlet weak var targetCurrencyButton: UIButton!
    
    private let currencyService = CurrencyService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let _ = segue.destination as? CurrencyPickerViewController,
           let segueIdentifier = segue.identifier
        {
            switch segueIdentifier {
            case "CurrencySourceSegue":
                currencyService.currencySelectionType = .source
            case "CurrencyTargetSegue":
                currencyService.currencySelectionType = .target
            default: break
            }
        }
        
        
    }
    
    
    private func setupBindings() {
        currencyService.onSourceCurrencyChanged = { [weak self] sourceCurrency in
            self?.sourceCurrencyButton.setTitle(sourceCurrency.rawValue, for: .normal)
        }
        
        currencyService.onTargetCurrencyChanged = { [weak self] targetCurrency in
            self?.targetCurrencyButton.setTitle(targetCurrency.rawValue, for: .normal)
        }
    }
    
}


































