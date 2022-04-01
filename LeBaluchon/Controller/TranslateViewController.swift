//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 29/03/2022.
//

import UIKit

class TranslateViewController: UIViewController {
    @IBOutlet weak var languageToTraductTextView: UITextView!
    @IBOutlet weak var languageTraductedTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageToTraductTextView.text = ""
        languageTraductedTextView.text = ""

    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        languageToTraductTextView.resignFirstResponder()
        languageTraductedTextView.resignFirstResponder()
    }
}

