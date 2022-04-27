//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 29/03/2022.
//

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet weak var sourceLanguageTextView: UITextView!
    @IBOutlet weak var targetLanguageTextView: UITextView!
    
    @IBOutlet weak var sourceLanguageButton: UIButton!
    @IBOutlet weak var targetLanguageButton: UIButton!
    
    @IBOutlet weak var swapLanguagesButton: UIButton!
    
    private let translateService = TranslateService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolBar()
        sourceLanguageTextView.delegate = self
        sourceLanguageTextView.text = ""
        targetLanguageTextView.text = ""

        targetLanguageTextView.inputView = UIView()
        
        setupBindings()
        
        
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        sourceLanguageTextView.resignFirstResponder()
        targetLanguageTextView.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let _ = segue.destination as? LanguagePickerViewController,
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
    
    @IBAction func didTapOnSwapLanguagesButton(_ sender: UIButton) {
        translateService.swapLanguages()
    }
    
    
    @IBAction func didTapOnTranslateButton(_ sender: UIButton) {
    }
    
    private func setupBindings() {
        translateService.onSourceLanguageChanged = { [weak self] sourceLanguage in
            self?.sourceLanguageButton.setTitle(sourceLanguage.name, for: .normal)
        }
        
        translateService.onTargetLanguageChanged = { [weak self] targetLanguage in
            self?.targetLanguageButton.setTitle(targetLanguage.name, for: .normal)
        }
        
        
        translateService.onSourceTextChanged = { [weak self] textToConvert in
            self?.sourceLanguageTextView.text = textToConvert
        }
        
        
        translateService.onTargetTextChanged =  { [weak self] convertedText in
            self?.targetLanguageTextView.text = convertedText
        }
        
    }
    
    
    private func setupToolBar() {
        let toolBar = UIToolbar()
        
        let clearButton = UIBarButtonItem(
            title: "CLEAR",
            primaryAction: UIAction(handler: { [weak self] _ in self?.translateService.emptySourceText() } )
        )
        
        toolBar.items = [
            .flexibleSpace(),
            clearButton
           
        ]
        
        
        toolBar.sizeToFit()
        
        sourceLanguageTextView.inputAccessoryView = toolBar
        
        
    }
}


extension TranslateViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textViewText = textView.text,
              let rangeIn = Range(range, in: textViewText)
        else {
            return false
        }
        
        
        let valueToConvertText = textViewText.replacingCharacters(in: rangeIn, with: text)
    
        
        translateService.sourceText = valueToConvertText
        
        return false
    }
    
}
