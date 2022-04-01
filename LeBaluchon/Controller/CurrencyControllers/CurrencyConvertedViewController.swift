//
//  CurrencyConvertedTableViewController.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 01/04/2022.
//

import UIKit

class CurrencyConvertedViewController: UIViewController {
    @IBOutlet weak var currencyConvertedTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyConvertedTableView.delegate = self
        currencyConvertedTableView.dataSource = self
    }
}

extension CurrencyConvertedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printContent("test")
    }
}

extension CurrencyConvertedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        return cell
    }
    
}
