//
//  LanguageToTraductTableViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 01/04/2022.
//

import UIKit

class LanguageToTranslateViewController: UIViewController {

    @IBOutlet weak var languageToTranslateTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languageToTranslateTableView.delegate = self
        languageToTranslateTableView.dataSource = self
    }
}

extension LanguageToTranslateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printContent("test")
    }
}

extension LanguageToTranslateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        return cell
    }
}
