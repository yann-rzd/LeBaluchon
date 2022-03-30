//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 17/03/2022.
//

import UIKit

final class CurrencyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        currencyService.fetchConversionRates()
    }

    private let currencyService = CurrencyService()

}


































