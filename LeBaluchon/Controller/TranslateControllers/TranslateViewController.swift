//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 29/03/2022.
//

import UIKit

class TranslateViewController: UIViewController {
    @IBOutlet weak var languageToTranslateTextView: UITextView!
    @IBOutlet weak var languageTranslatedTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageToTranslateTextView.text = ""
        languageTranslatedTextView.text = ""

    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        languageToTranslateTextView.resignFirstResponder()
        languageTranslatedTextView.resignFirstResponder()
    }
}

