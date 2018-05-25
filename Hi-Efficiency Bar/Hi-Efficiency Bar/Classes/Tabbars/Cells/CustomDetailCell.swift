//
//  CustomDetailCell.swift
//  Hi-Efficiency Bar
//
//  Created by QTS_002 on 22/03/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit

class CustomDetailCell: UITableViewCell, UITextFieldDelegate {
    var tapRemove: (() ->())?
    var tapChangeML: (() ->())?
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txfValue: UITextField!
    var ingredientCusObj = IngredientCusObj.init(dict: NSDictionary.init())
    override func awakeFromNib() {
        super.awakeFromNib()
        txfValue.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func doRemove(_ sender: Any) {
        self.tapRemove?()
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        ingredientCusObj.value = 0
        ingredientCusObj.ratio = 0
        self.tapChangeML?()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = txfValue.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if CommonHellper.trimSpaceString(txtString: updatedText).isEmpty
            {
                ingredientCusObj.value = 0
                ingredientCusObj.unit = 0
            }
            else{
                ingredientCusObj.value = CommonHellper.convertMLDrink(unit: (ingredientCusObj.unit_view?.lowercased())!, number: ingredientCusObj.unit!)
                ingredientCusObj.unit = Int(CommonHellper.trimSpaceString(txtString: updatedText))
            }
            self.tapChangeML?()
        }
        return true
    }
}
