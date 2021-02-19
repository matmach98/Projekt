//
//  BasketTableViewController.swift
//  ProjektUczelnia
//
//  Created by mateusz on 17/02/2021.
//  Copyright © 2021 mateusz. All rights reserved.
//

import UIKit

class BasketTableViewController: UITableViewController {
    var items = [ItemModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Basket"
        tableView.register(UINib(nibName: "BasketTableViewCell", bundle: .main), forCellReuseIdentifier: "basketCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketCell", for: indexPath) as! BasketTableViewCell
        let item = items[indexPath.item]
        cell.itemNameLabel.text = item.name
        cell.numberOfItemsLabel.text = String(item.numberOfSelectedItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func fetchData() {
        let defaults = UserDefaults.standard
        if let data = defaults.value(forKey: "items") as? Data {
            if let items = try? JSONDecoder().decode([ItemModel].self, from: data) {
                self.items = items
            }
        }
    }
}
