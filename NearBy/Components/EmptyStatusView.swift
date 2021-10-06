//
//  EmptyStatusView.swift
//  NearBy
//
//  Created by Khaled Elshamy on 06/10/2021.
//

import UIKit

class EmptyStatusView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    
    lazy var emptyImage : UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var labelEmpty : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    
    private func initViews () {
        addViews()
    }
    
    private func addViews () {
        
        self.addSubview(emptyImage)
        self.addSubview(labelEmpty)
        
        emptyImage.anchor( centerX: self.centerXAnchor , centerY: self.centerYAnchor ,  width: 200 , height: 200 )
        labelEmpty.anchor(top: emptyImage.bottomAnchor , leading: self.leadingAnchor , trailing: self.trailingAnchor , paddingTop: 16 , paddingLeft: 16 , paddingRight: 16 )
    }
    
}

