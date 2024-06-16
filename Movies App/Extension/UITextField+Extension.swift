//
//  UITextField+UIView.swift
//  Movies App
//
//  Created by SAHIL AMRUT AGASHE on 15/06/24.
//

import UIKit

extension UITextField {

 /// set icon of 13x13 with left padding of 15px
 func setLeftIcon(_ icon: UIImage) {

    let padding = 15
    let size = 13

    let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
    let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
    iconView.image = icon
    outerView.addSubview(iconView)

    leftView = outerView
    leftViewMode = .always
  }
}

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
// drawing and positioning overrides in UITextField
//- (CGRect)borderRectForBounds:(CGRect)bounds;
//- (CGRect)textRectForBounds:(CGRect)bounds;
//- (CGRect)placeholderRectForBounds:(CGRect)bounds;
//- (CGRect)editingRectForBounds:(CGRect)bounds;
//- (CGRect)clearButtonRectForBounds:(CGRect)bounds;
//- (CGRect)leftViewRectForBounds:(CGRect)bounds;
//- (CGRect)rightViewRectForBounds:(CGRect)bounds;
