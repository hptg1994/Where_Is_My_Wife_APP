//
//  RoundedCornerTextField.swift
//  WifeRider
//
//  Created by 何品泰高 on 2018/1/18.
//  Copyright © 2018年 何品泰高. All rights reserved.
//

import UIKit

class RoundedCornerTextField: UITextField {
    
    
    var textRectOffset:CGFloat = 20
    
    override func awakeFromNib() {
        setupView()
    }
    
    
    func setupView () {
        self.layer.cornerRadius = self.frame.height/2
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0 + textRectOffset, y: 0 + (textRectOffset / 2), width: self.frame.width - textRectOffset, height: self.frame.height + textRectOffset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0 + textRectOffset, y: 0 + (textRectOffset / 2), width: self.frame.width - textRectOffset, height: self.frame.height + textRectOffset)
    }
}

