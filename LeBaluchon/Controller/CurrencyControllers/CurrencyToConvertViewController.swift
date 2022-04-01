//
//  CurrencyToConvertTableViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 01/04/2022.
//

import UIKit

class CurrencyToConvertViewController: UIViewController {
    @IBOutlet weak var currencyToConvertTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyToConvertTableView.delegate = self
        currencyToConvertTableView.dataSource = self
    }
}

extension CurrencyToConvertViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printContent("test")
    }
}

extension CurrencyToConvertViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        return cell
    }
}
