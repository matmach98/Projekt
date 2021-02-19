//
//  ItemTableViewCell.swift
//  ProjektUczelnia
//
//  Created by mateusz on 16/02/2021.
//  Copyright © 2021 mateusz. All rights reserved.
//

import UIKit

protocol ItemTableViewCellDelegate: class {
    func didBuyButtonTapped(itemModel: ItemModel)
}

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var numberOfItemsTextField: UITextField!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    
    weak var delegate: ItemTableViewCellDelegate?
    
    private lazy var numberOfItemsPicker: UIPickerView = {
        let picker = UIPickerView()
        let toolBar = UIToolbar()
        return picker
    }()
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: false)
        return toolbar
    }()
    
    private let userDefaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numberOfItemsTextField.inputView = numberOfItemsPicker
        numberOfItemsTextField.inputAccessoryView = toolbar
        numberOfItemsPicker.delegate = self
        numberOfItemsPicker.dataSource = self
        numberOfItemsTextField.textAlignment = .center
        shouldBuyButtonBeHidden()
        
    }
    private var array = [ItemModel]()
    
    @IBAction func buyButtonTapped(_ sender: UIButton) {
        if let itemName = itemNameLabel.text, let numberOfSelectedItem = numberOfItemsTextField.text {
            guard let numberOfSelectedItemInt = Int(numberOfSelectedItem) else { return }
            self.delegate?.didBuyButtonTapped(itemModel: ItemModel(name: itemName, numberOfSelectedItem: numberOfSelectedItemInt))
        }
    }
    
    private func shouldBuyButtonBeHidden() {
        if numberOfItemsTextField.text == "" {
            buyButton.isHidden = true
        } else {
            buyButton.isHidden = false
        }
    }
    
    @objc func doneButtonPressed() {
        let selectedRow = numberOfItemsPicker.selectedRow(inComponent: 0) + 1
        numberOfItemsTextField.text = selectedRow.description
        numberOfItemsTextField.endEditing(true)
        shouldBuyButtonBeHidden()
    }
    
}

extension ItemTableViewCell: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let arrayOfNumbers = [1,2,3,4,5,6,7,8,9,10]
        let numbersAsString = arrayOfNumbers.map{String($0)}
        return numbersAsString[row]
    }
}
