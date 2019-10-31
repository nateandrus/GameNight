//
//  NPTextField.swift
//  GameNight
//
//  Created by Nathan Andrus on 10/30/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class NPTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.tintColor = #colorLiteral(red: 0.1674007663, green: 0.4571400597, blue: 0.5598231282, alpha: 1)
        toolbar.barTintColor = #colorLiteral(red: 0.9223575178, green: 0.9223575178, blue: 0.9223575178, alpha: 1)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        self.inputAccessoryView = toolbar
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func dismissKeyboard() {
        self.resignFirstResponder()
    }
}
