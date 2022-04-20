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
        
        languageToTranslateTableView.delegate = self
        languageToTranslateTableView.dataSource = self
    }
    
    private func setupBindings() {
        translateService.onSearchResultChanged = { [weak self] in
            self?.languageToTranslateTableView.reloadData()
        }
    }
}

extension LanguagePickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguage = translateService.languages[indexPath.row]
        
        translateService.assignLanguage(language: selectedLanguage)
        
        dismiss(animated: true) { [weak self] in
            self?.translateService.languageSelectionType = nil
        }
    }
}

extension LanguagePickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        translateService.languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let language = translateService.languages[indexPath.row]
        cell.textLabel?.text = language.name
        cell.detailTextLabel?.text = language.rawValue
        return cell
    }
}
