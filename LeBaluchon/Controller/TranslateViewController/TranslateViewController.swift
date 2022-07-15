//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 29/03/2022.
//

import UIKit


class TranslateViewController: UIViewController {
    
    // MARK: - INTERNAL: properties
    
    @IBOutlet weak var sourceLanguageTextView: UITextView!
    @IBOutlet weak var targetLanguageTextView: UITextView!
    @IBOutlet weak var sourceLanguageButton: UIButton!
    @IBOutlet weak var targetLanguageButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var translateButton: UIButton!
    
    
    // MARK: - INTERNAL: methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolBar()
        
        targetLanguageButton.layer.borderWidth = 1
        targetLanguageButton.layer.cornerRadius = 5
        targetLanguageButton.layer.borderColor = UIColor.TranslateButtonBorderColor.cgColor
        
        sourceLanguageTextView.delegate = self
        sourceLanguageTextView.text = ""
        sourceLanguageTextView.layer.cornerRadius = 10.0
        targetLanguageTextView.text = ""
        targetLanguageTextView.layer.cornerRadius = 10.0
//        translateButton.layer.cornerRadius = 10.0

        targetLanguageTextView.inputView = UIView()
        
        setupBindings()
        translateService.setup()
        
        
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        sourceLanguageTextView.resignFirstResponder()
        targetLanguageTextView.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let _ = segue.destination as? UINavigationController,
           let segueIdentifier = segue.identifier
        {
            switch segueIdentifier {
            case "LanguageSourceSegue":
                translateService.languageSelectionType = .source
            case "LanguageTargetSegue":
                translateService.languageSelectionType = .target
            default: break
            }
        }
    }
    
    
    @IBAction func didTapOnTranslateButton(_ sender: UIButton) {
        translateService.fetchTranslation { result in
            switch result {
            case .failure:
                self.presentAlert()
            case .success:
                print("Success")
            }
        }
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let translateService = TranslateService.shared
    
    
    // MARK: - PRIVATE: methods
    
    private func setupBindings() {
        translateService.onSourceLanguageChanged = { [weak self] sourceLanguage in
            DispatchQueue.main.async {
                self?.sourceLanguageButton.setTitle(sourceLanguage?.name ?? "", for: .normal)
            }
        }
        
        translateService.onTargetLanguageChanged = { [weak self] targetLanguage in
            DispatchQueue.main.async {
                self?.targetLanguageButton.setTitle(targetLanguage.name, for: .normal)
            }
        }
        
        translateService.onSourceTextChanged = { [weak self] textToConvert in
            DispatchQueue.main.async {
                self?.sourceLanguageTextView.text = textToConvert
            }
        }
        
        translateService.onTargetTextChanged =  { [weak self] convertedText in
            DispatchQueue.main.async {
                self?.targetLanguageTextView.text = convertedText
            }
       
        }
        
        translateService.onIsLoadingChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                let buttonTitle = isLoading ? "" : "Translate"
                self?.translateButton.setTitle(buttonTitle, for: .normal)
                self?.activityIndicator.isHidden = !isLoading
            }
        }
    }
    
    private func presentAlert() {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Error", message: "Failed to translate", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    private func setupToolBar() {
        let toolBar = UIToolbar()
        
        let clearButton = UIBarButtonItem(
            title: "CLEAR",
            primaryAction: UIAction(handler: { [weak self] _ in self?.translateService.emptySourceText() } )
        )
        
        clearButton.tintColor = .gray
        
        let doneButton = UIBarButtonItem(
            title: "DONE",
            primaryAction: UIAction(handler: { [weak self] _ in self?.view.endEditing(true) } )
        )
        
        toolBar.items = [
            clearButton,
            .flexibleSpace(),
            doneButton
        ]
        
        toolBar.sizeToFit()
        sourceLanguageTextView.inputAccessoryView = toolBar
    }
}


// MARK: - EXTENSIONS

extension TranslateViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textViewText = textView.text,
              let rangeIn = Range(range, in: textViewText)
        else {
            return false
        }

        let valueToConvertText = textViewText.replacingCharacters(in: rangeIn, with: text)
        
        translateService.sourceText = valueToConvertText
        
        return text.count > 1
    }
}

extension UIColor {
    class var TranslateButtonBorderColor: UIColor {
        if let color = UIColor(named: "customBlue") {
            return color
        }
        fatalError("Could not find weatherCellsBackground color")
    }
}
