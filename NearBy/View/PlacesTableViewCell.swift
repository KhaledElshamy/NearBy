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
    @IBOutlet weak var placeImage: CustomImageView!
    
    var viewModel: PlacesCellModel? {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        if let viewModel = viewModel {
            name?.text = viewModel.name
            address?.text = viewModel.address
            if let url = viewModel.imageUrl {
                placeImage.loadImageUsingUrlString(urlString: url)
            }else {
                placeImage.image = #imageLiteral(resourceName: "placeholder")
            }
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
