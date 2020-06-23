//
//  PickerView.swift
//  LifeAPP
//
//  Created by 顏淩育 on 2020/6/23.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class PickerView: UIView {

    @IBOutlet var contView: UIView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var doneBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
    var labels: [String] = [] {
        didSet {
            self.pickerView.reloadAllComponents()
        }
    }
    
    var pickerIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            initFromXib()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            initFromXib()
        }
        
        func initFromXib() {
            let bundle = Bundle.init(for: PickerView.self)
            let nib = UINib(nibName: "PickerView", bundle: bundle)
            contView = nib.instantiate(withOwner: self, options: nil).first as? UIView
            contView.frame = bounds
            
            pickerView.setValue(UIColor.black, forKey: "textColor")
    //        contView.setRoundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight], with: 10)
//            contView.layer.cornerRadius = 10
//            contView.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor
//            contView.layer.shadowOffset = CGSize(width: 0, height: 0)
//            contView.layer.shadowRadius = 10
//            contView.layer.shadowOpacity = 1.0
//            contView.layer.masksToBounds = false
            self.addSubview(contView)
        }

}

extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return labels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return labels[row]
    }
    
    // 更改字體顏色
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        // row == pickerView.selectedRow(inComponent: component) 所選中的component中的row，記得reloadAllComponents()
//        let attributedString = (row == pickerView.selectedRow(inComponent: component)) ? NSAttributedString.setMediumAttributedString(string: self.labels[row]) : .setSmallAttributedString(string: self.labels[row])
//        return attributedString
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerIndex = IndexPath(row: row, section: component)
        pickerView.reloadAllComponents()
    }
    
}
