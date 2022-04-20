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
    
    private func setupBindings() {
        translateService.onSourceLanguageChanged = { [weak self] sourceLanguage in
            self?.sourceLanguageButton.setTitle(sourceLanguage.name, for: .normal)
        }
        
        translateService.onTargetLanguageChanged = { [weak self] targetLanguage in
            self?.targetLanguageButton.setTitle(targetLanguage.name, for: .normal)
        }
        
        
        translateService.onSourceTextChanged = { [weak self] textToConvert in
            self?.sourceLanguageTextView.text = textToConvert.description ?? ""
        }
        
        
        translateService.onTargetTextChanged =  { [weak self] convertedText in
            self?.targetLanguageTextView.text = convertedText.description ?? ""
        }
        
    }
}

