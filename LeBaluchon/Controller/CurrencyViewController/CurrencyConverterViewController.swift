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
    @IBOutlet weak var swapCurrenciesButton: UIButton!
    
    @IBOutlet weak var sourceCurrencyButton: UIButton!
    @IBOutlet weak var targetCurrencyButton: UIButton!
    
    private let currencyService = CurrencyService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueToConvertTextField.delegate = self
        
        valueConvertedTextField.inputView = UIView()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let refreshRatesBarButtonImage = UIImage(systemName: "arrow.counterclockwise")
        let refreshRatesBarButton = UIBarButtonItem(image: refreshRatesBarButtonImage, style: .plain, target: self, action: #selector(didTapRefreshRatesButton))
        navigationItem.rightBarButtonItem = refreshRatesBarButton
        refreshRatesBarButton.tintColor = .white
        
    }

    @objc public func didTapRefreshRatesButton() {
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

    
    @IBAction func didTapOnSwapCurrenciesButton(_ sender: UIButton) {
        currencyService.swapCurrencies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let _ = segue.destination as? CurrencyPickerViewController,
           let segueIdentifier = segue.identifier
        {
            switch segueIdentifier {
            case "CurrencySourceSegue":
                print("1. JE COMMENCE LE PROCESSUS DE SELECTION DE LA DEVISE SOURCE")
                currencyService.currencySelectionType = .source
            case "CurrencyTargetSegue":
                print("1. JE COMMENCE LE PROCESSUS DE SELECTION DE LA DEVISE CIBLE")
                currencyService.currencySelectionType = .target
            default: break
            }
            
            print("2. JE PRESENTE LECRAN DE SELECTION DE DEVISE")
        }
    }
    
    
    private func setupBindings() {
        print("0. J?ASSIGNE LES BLOCKS DE CODES POUR INDIQUER QUOI FAIRE QUAND SOURCE ETT TARGET CHANGENT")
        currencyService.onSourceCurrencyChanged = { [weak self] sourceCurrency in
            print("7. LA SOURCE A CHANGE JAPPLIQUER (ViewController) LES CHANGEMENT (assigner au source currency button le titre)")
            self?.sourceCurrencyButton.setTitle(sourceCurrency.rawValue, for: .normal)
        }
        
        currencyService.onTargetCurrencyChanged = { [weak self] targetCurrency in
            print("7. LA TARGET A CHANGE JAPPLIQUER (ViewController) LES CHANGEMENT (assigner au target currency button le titre)")
            self?.targetCurrencyButton.setTitle(targetCurrency.rawValue, for: .normal)
        }
        
        
        
        currencyService.onValueToConvertChanged = { [weak self] valueToConvert in
            self?.valueToConvertTextField.text = valueToConvert?.description ?? ""
        }
        
        
        currencyService.onConvertedValueChanged =  { [weak self] convertedValue in
            self?.valueConvertedTextField.text = convertedValue?.description ?? ""
        }
        
    }
    
}


extension CurrencyConverterViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let textFieldText = textField.text,
              let rangeIn = Range(range, in: textFieldText)
        else {
            return false
        }
        
        
        let valueToConvertText = textFieldText.replacingCharacters(in: rangeIn, with: string)
        
        
        if string == "" && textFieldText.count == 1 {
            currencyService.valueToConvert = nil
            return false
        }
        
        
        guard let valueToConvert = Int(valueToConvertText) else {
            return false
        }
    
        
        currencyService.valueToConvert = valueToConvert
        
        return false
    }
}


































