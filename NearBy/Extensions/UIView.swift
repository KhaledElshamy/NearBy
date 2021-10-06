//
//  UIView.swift
//  NearBy
//
//  Created by Khaled Elshamy on 06/10/2021.
//

import UIKit

protocol NibLoadable {
    static var nibName : String { get }
}

extension UIView: NibLoadable {
    class func fromNib<V: UIView>() -> V {
        guard let view = Bundle.main.loadNibNamed(V.nibName, owner: nil, options: nil)?[0] as? V else {
            fatalError("Could not initialize view")
        }
        return view
    }
}

extension NibLoadable where Self: UIView {
    static var nibName : String {
        return String(describing: self)
    }
}


extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil , leading: NSLayoutXAxisAnchor? = nil , bottom: NSLayoutYAxisAnchor? = nil , trailing: NSLayoutXAxisAnchor? = nil , centerX:NSLayoutXAxisAnchor? = nil ,centerY: NSLayoutYAxisAnchor? = nil ,paddingTop: CGFloat = 0 ,paddingLeft: CGFloat = 0 ,paddingBottom: CGFloat = 0 ,paddingRight: CGFloat = 0 , width: CGFloat = 0 ,height: CGFloat = 0 ,paddingCenterX: CGFloat = 0 ,paddingCenterY: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant:paddingTop).isActive = true
        }
        
        if let left = leading {
            leadingAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant:-paddingBottom).isActive = true
        }
        
        if let right = trailing {
            trailingAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX, constant: paddingCenterX).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY, constant: paddingCenterY).isActive = true
        }
    }
    
}
