//
//  CurrencyPickerViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 01/04/2022.
//

import UIKit

class CurrencyPickerViewController: UIViewController {
    @IBOutlet weak var currencyToConvertTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyToConvertTableView.delegate = self
        currencyToConvertTableView.dataSource = self
    }
    
    
    private let currencyService = CurrencyService.shared
}

extension CurrencyPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency = currencyService.currencies[indexPath.row]
        
        print("3. JE RECUPERE LA DEVISE SELECTIONNER \(selectedCurrency)")
        currencyService.assignCurrency(currency: selectedCurrency)
        
        dismiss(animated: true) { [weak self] in
            self?.currencyService.currencySelectionType = nil
        }
    }
}

extension CurrencyPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencyService.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let currency = currencyService.currencies[indexPath.row]
        cell.textLabel?.text = currency.name
        cell.detailTextLabel?.text = currency.rawValue
        return cell
    }
}


