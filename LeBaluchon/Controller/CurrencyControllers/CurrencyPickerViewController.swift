//
//  CurrencyPickerViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 01/04/2022.
//

import UIKit

class CurrencyPickerViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var currencyToConvertTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let currencyService = CurrencyService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyToConvertTableView.delegate = self
        currencyToConvertTableView.dataSource = self
        
        searchBar.delegate = self
        currencyService.filteredCurrencies = currencyService.currencies
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currencyService.filteredCurrencies = []
        
        if searchText.isEmpty {
            currencyService.filteredCurrencies = currencyService.currencies
        } else {
            for currency in currencyService.currencies {
                if currency.name.lowercased().contains(searchText.lowercased()) {
                    currencyService.filteredCurrencies.append(currency)
                }
            }
        }

        self.currencyToConvertTableView.reloadData()
    }
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
        currencyService.filteredCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let currency = currencyService.filteredCurrencies[indexPath.row]
        cell.textLabel?.text = currency.name
        cell.detailTextLabel?.text = currency.rawValue
        return cell
    }
}


