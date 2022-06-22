//
//  CurrencyPickerViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 01/04/2022.
//

import UIKit

final class CurrencyPickerViewController: UIViewController {
    
    // MARK: - INTERNAL: properties
    
    @IBOutlet weak var currencyToConvertTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - INTERNAL: methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupToolBar()
        setupBindings()
        
        currencyToConvertTableView.delegate = self
        currencyToConvertTableView.dataSource = self
        
        searchBar.delegate = self
        
        currencyService.filteredCurrencies = currencyService.filteredCurrencies
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let currencyService = CurrencyService.shared
    
    
    // MARK: - PRIVATE: methods
    
    private func setupBindings() {
        currencyService.onSearchResultChanged = { [weak self] in
            self?.currencyToConvertTableView.reloadData()
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.title = "Select Currency"
        
        let closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissCurrencyPicker))
        
        navigationItem.rightBarButtonItem = closeBarButtonItem
    }
    
    @objc private func dismissCurrencyPicker() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupToolBar() {
        let toolBar = UIToolbar()
        
        let clearButton = UIBarButtonItem(
            title: "CLEAR",
            primaryAction: UIAction(handler: { [weak self] _ in self?.currencyService.emptySourceText() } )
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
        
        searchBar.inputAccessoryView = toolBar
        
    }
}


// MARK: - EXTENSIONS

extension CurrencyPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency = currencyService.filteredCurrencies[indexPath.row]
        
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

extension CurrencyPickerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currencyService.searchText = searchText
    }
}

