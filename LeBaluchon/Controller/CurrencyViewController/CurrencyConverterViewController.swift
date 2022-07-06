//
//  CurrencyConverterViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 17/03/2022.
//

import UIKit

final class CurrencyConverterViewController: UIViewController {
    
    // MARK: - INTERNAL: properties
    
    @IBOutlet weak var valueToConvertTextField: UITextField!
    @IBOutlet weak var valueConvertedTextField: UITextField!
    @IBOutlet weak var swapCurrenciesButton: UIButton!
    @IBOutlet weak var sourceCurrencyButton: UIButton!
    @IBOutlet weak var targetCurrencyButton: UIButton!
    
    
    // MARK: - INTERNAL: methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(isLoading: currencyService.isLoading)
        valueToConvertTextField.delegate = self
        valueConvertedTextField.inputView = UIView()

        sourceCurrencyButton.layer.borderWidth = 1
        sourceCurrencyButton.layer.cornerRadius = 5
        sourceCurrencyButton.layer.borderColor = UIColor.currencyButtonBorderColor.cgColor
        
        targetCurrencyButton.layer.borderWidth = 1
        targetCurrencyButton.layer.cornerRadius = 5
        targetCurrencyButton.layer.borderColor = UIColor.currencyButtonBorderColor.cgColor
        
        refreshControl.addTarget(self, action: #selector(didTapRefreshRatesButton), for: .valueChanged)
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        valueToConvertTextField.resignFirstResponder()
        valueConvertedTextField.resignFirstResponder()
    }

    
    @IBAction func didTapOnSwapCurrenciesButton(_ sender: UIButton) {
        currencyService.swapCurrencies()
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let currencyService = CurrencyService.shared

    private lazy var refreshBarButton: UIBarButtonItem = {
        let refreshDataImage = UIImage(systemName: "arrow.clockwise")
        let refreshDataBarButton = UIBarButtonItem(image: refreshDataImage, style: .plain, target: self, action: #selector(didTapRefreshRatesButton))
        refreshDataBarButton.tintColor = .white
        return refreshDataBarButton
    }()
    
    private var loadingBarButtonItem: UIBarButtonItem = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .white
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        let loadingBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
        return loadingBarButtonItem
    }()
    
    private let refreshControl = UIRefreshControl()
    
    
    // MARK: - PRIVATE: methods
    
    private func setupBindings() {
        currencyService.onSourceCurrencyChanged = { [weak self] sourceCurrency in
            self?.sourceCurrencyButton.setTitle(sourceCurrency.rawValue, for: .normal)
        }
        
        currencyService.onTargetCurrencyChanged = { [weak self] targetCurrency in
            self?.targetCurrencyButton.setTitle(targetCurrency.rawValue, for: .normal)
        }
        
        currencyService.onValueToConvertChanged = { [weak self] valueToConvert in
            self?.valueToConvertTextField.text = valueToConvert?.description ?? ""
        }
        
        currencyService.onConvertedValueChanged =  { [weak self] convertedValue in
            self?.valueConvertedTextField.text = convertedValue?.description ?? ""
        }
        
        currencyService.isLoadingDidChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.setupNavigationBar(isLoading: isLoading)
                if !isLoading {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    @objc private func didTapRefreshRatesButton() {
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
    
    private func setupNavigationBar(isLoading: Bool) {
        navigationItem.rightBarButtonItems = [
            isLoading ? loadingBarButtonItem : refreshBarButton
        ]
    }
}


// MARK: - EXTENSIONS

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

extension UIColor {
    class var currencyButtonBorderColor: UIColor {
        if let color = UIColor(named: "customBlue") {
            return color
        }
        fatalError("Could not find weatherCellsBackground color")
    }
}


































