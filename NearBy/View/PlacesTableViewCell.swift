//
//  PlacesTableViewCell.swift
//  NearBy
//
//  Created by Khaled Elshamy on 06/10/2021.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    
    var viewModel: PlacesCellModel? {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        if let viewModel = viewModel {
            name?.text = viewModel.name
            address?.text = viewModel.address
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
