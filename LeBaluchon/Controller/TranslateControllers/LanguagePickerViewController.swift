//
//  LanguageToTraductTableViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 01/04/2022.
//

import UIKit

class LanguagePickerViewController: UIViewController {

    @IBOutlet weak var languageToTranslateTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let translateService = TranslateService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupToolBar()
   
        
        languageToTranslateTableView.delegate = self
        languageToTranslateTableView.dataSource = self
        
        searchBar.delegate = self
        
        translateService.filteredLanguages = translateService.filteredLanguages
        
        setupBindings()
        
        
        translateService.searchText = ""
    }
    
    
    private func setupBindings() {
        translateService.onSearchResultChanged = { [weak self] in
            self?.languageToTranslateTableView.reloadData()
        }
    }
    
    @objc private func dismissLanguagePicker() {
        dismiss(animated: true) { [weak self] in
            self?.translateService.languageSelectionType = nil
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = translateService.languageSelectionType?.navigationTitle
        
        let closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissLanguagePicker))
        
        navigationItem.rightBarButtonItem = closeBarButtonItem
        
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
        
        searchBar.inputAccessoryView = toolBar
        
    }
}

extension LanguagePickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguage = translateService.filteredLanguages[indexPath.row]
        
        translateService.assignLanguage(language: selectedLanguage)
        
        dismissLanguagePicker()
    }
}

extension LanguagePickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        translateService.filteredLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let language = translateService.filteredLanguages[indexPath.row]
        cell.textLabel?.text = language.name
        cell.detailTextLabel?.text = language.rawValue
        return cell
    }
}

extension LanguagePickerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        translateService.searchText = searchText
    }
}
