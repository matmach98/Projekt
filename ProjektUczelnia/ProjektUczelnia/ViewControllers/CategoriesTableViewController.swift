//
//  CategoriesTableViewController.swift
//  ProjektUczelnia
//
//  Created by mateusz on 15/02/2021.
//  Copyright © 2021 mateusz. All rights reserved.
//

import UIKit

protocol CategoriesTableViewDelegate: class {
    func didSelect(category: String)
}

class CategoriesTableViewController: UITableViewController {
    
    weak var delegate: CategoriesTableViewDelegate?
    
    init(delegate: CategoriesTableViewDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let categories = ["Coats", "Jackets", "Jeans", "Jumpers", "Hoodies", "Denim Jackets", "Formal Shirts", "Blazers"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: .main), forCellReuseIdentifier: "categoryCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        cell.categoryNameLabel.text = categories.sorted(by: <)[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(category: categories.sorted(by: <)[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
