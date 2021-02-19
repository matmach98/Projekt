//
//  StartViewController.swift
//  ProjektUczelnia
//
//  Created by mateusz on 15/02/2021.
//  Copyright © 2021 mateusz. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var selectCategoryLabel: UILabel!
    @IBOutlet weak var subtextLabel: UILabel!
    @IBOutlet weak var itemsTableView: UITableView!
    
    typealias Factory = ViewControllerFactory
    
    init(factory: Factory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let factory: Factory
    private let userDefaults = UserDefaults.standard
    
    private var category: String?
    private var itemArray = [ItemModel]()
    
    private lazy var categoriesTableViewController = factory.makeCategoriesTableViewController(delegate: self)
    
    let items = ["Coats":
                    ["Pier One Parka - green",
                     "Pier One Parka - black",
                     "Pier One Parka - khaki",
                     "Pier One Classic coat - dark blue",
                     "WINTER AVIATOR - Parka - deep depths",
                     "ADAIR - Short coat - dark blue" ],
                 "Jumpers":
                    ["Polo Ralph Lauren Jumper - andover heather",
                     "Tommy Hilfiger C-NECK - Jumper - charcoal heather",
                     "BOSS Jumper - sand", "Pier One Jumper - mottled grey",
                     "Springfield SMOKING - Jumper - dark blue",
                     "Mango LUXUS - Jumper - grau"],
                 "Blazers":
                    ["VOLPI BLAZER - Suit jacket - black",
                     "BISLEVA - Blazer jacket - beige",
                     "ACTIVE - Suit jacket - dark grey",
                     "ACTIVE - Suit jacket - black",
                     "UNCONSTRUCTED BLAZER - Blazer jacket",
                     "DAVIN - Denim jacket - medium green",
                     "MAGEORGE - Blazer jacket - dark navy",
                     "HUSTLE - Suit jacket - grey"],
                 "Jeans":
                    ["Pepe Jeans CASH - Straight leg jeans - blanco",
                     "Only & Sons ONSLOOM - Slim fit jeans - blue denim",
                     "Levi's® 512™ SLIM TAPER FIT - Slim fit jeans",
                     "TOM TAILOR JOSH - Slim fit jeans - mid stone wash",
                     "Scotch & Soda SKIM - Slim fit jeans - icon blauw",
                     "Cars Jeans CAVIN - Slim fit jeans - grey used",
                     "Gym King DISTRESSED - Jeans Skinny Fit - dark grey",
                     "Tommy Jeans RYAN - Straight leg jeans"],
                 "Jackets":
                    ["Pier One Light jacket - black",
                     "Jack & Jones JJDIEGO - Blazer jacket - navy",
                     "The North Face 1996 RETRO NUPTSE JACKET UNISEX",
                     "adidas Performance Fleece jacket - black/crew navy/scarlet",
                     "Pepe Jeans DONNIE - Leather jacket - black",
                     "HUGO BALTINO - Waistcoat - dark blue",
                     "Nike Sportswear ANORAK - Windbreaker - black"],
                 "Hoodies":
                    ["Pier One Hoodie - black",
                     "YOURTURN UNISEX - Hoodie - teal",
                     "Tommy Hilfiger LOGO HOODY - Hoodie - grey",
                     "Nike SportswearCLUB HOODIE - Hoodie - charcoal heath",
                     "Tommy Jeans REGULAR FLEECE HOODIE",
                     "Ellesse GOTTERO - Hoodie - grey marl",
                     "Alpha Industries Hoodie - black",
                     "Carhartt WIP HOODED CHASE - Hoodie - black/gold",
                     "Hoodrich AMBUSH HOODIE - Sweatshirt - black",
                     "Champion Rochester BEKLEIDUNG - Hoodie - blue",
                     "Tommy Hilfiger LOGO HOODY - Hoodie - orange"],
                 "Denim Jackets":
                    ["Pepe Jeans PINNER - Denim jacket - dark blue",
                     "Denim Project KASH JACKET - Denim jacket - black",
                     "Brave Soul MJK-LARSON - Denim jacket - blue denim",
                     "Jack & Jones JJIALVIN JJJACKET - Denim jacket ",
                     "Only & Sons ONSCOIN - Denim jacket - black denim",
                     "RYAN - Denim jacket - beige",
                     "Levi's®VINTAGE FIT TRUCKER UNISEX",
                     "Redefined Rebel JASON JACKET - Denim jacket - light blue"],
                 "Formal Shirts":
                    ["Pier One Formal shirt - white",
                     "Eterna SLIM FIT - Formal shirt - light blue",
                     "CELIO MASANTAL - Formal shirt - noir",
                     "Selected Homme SLHSLIMBROOKLYN - Formal shirt - black",
                     "Mango TADI - Shirt - beige",
                     "DRYKORN LOKEN - Formal shirt - light blue",
                     "HUGO KOEY - Formal shirt - navy"]]
    
    private lazy var selectCategoryBarButtonItem: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Select Category", style: .plain, target: self, action: #selector(selectCategoryButtonTapped))
        barButton.tintColor = .white
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        itemsTableView.register(UINib(nibName: "ItemTableViewCell", bundle: .main), forCellReuseIdentifier: "selectedCategoryItemCell")
    }
    
    @objc private func selectCategoryButtonTapped() {
        present(categoriesTableViewController, animated: true)
    }

    private func setupNavBar() {
        navigationItem.leftBarButtonItem = selectCategoryBarButtonItem
    }
}

extension StartViewController: CategoriesTableViewDelegate {
    func didSelect(category: String) {
        self.category = category
        subtextLabel.isHidden = true
        selectCategoryLabel.isHidden = true
        itemsTableView.isHidden = false
        DispatchQueue.main.async {
            self.itemsTableView.reloadData()
        }
    }
}

extension StartViewController: ItemTableViewCellDelegate {
    func didBuyButtonTapped(itemModel: ItemModel) {
        itemArray.removeAll(where: {$0.name == itemModel.name})
        itemArray.append(itemModel)
        guard let items = try? JSONEncoder().encode(itemArray) else { return }
        userDefaults.setValue(items, forKey: "items")
        navigationController?.pushViewController(factory.makeBasketTableViewController(), animated: false)
    }
}

extension StartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let category = category else { return 0 }
        return items[category]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedCategoryItemCell", for: indexPath) as! ItemTableViewCell
        if let category = category {
            cell.itemNameLabel.text = items[category]![indexPath.row]
            cell.numberOfItemsTextField.text = ""
            cell.selectionStyle = .none
            cell.delegate = self
            cell.buyButton.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
