//
//  UIImageView.swift
//  NearBy
//
//  Created by Khaled Elshamy on 06/10/2021.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage (url : String , placeHolder : UIImage = #imageLiteral(resourceName: "placeholder") ) {
        let url = URL(string: url)
        self.kf.setImage(with: url,placeholder: placeHolder)
    }
}

