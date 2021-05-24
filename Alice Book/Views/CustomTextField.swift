//
//  CustomTextField.swift
//  Alice Book
//
//  Created by Alice on 5/24/21.
//  Copyright © 2021 Alice. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    @IBInspectable var imageLeft: UIImage? {
        didSet {
            setImageLeft()
        }
    }
    
    
    
    func setImageLeft() {
        if let image = imageLeft {
            leftViewMode = .always
            
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height)
            leftView = view
            
            let imageView = UIImageView()
            imageView.frame = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height).inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
            
            view.addSubview(imageView)
            
            
        }
    }
}
