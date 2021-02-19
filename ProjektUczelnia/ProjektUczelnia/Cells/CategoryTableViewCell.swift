//
//  CategoryTableViewCell.swift
//  ProjektUczelnia
//
//  Created by mateusz on 16/02/2021.
//  Copyright © 2021 mateusz. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
