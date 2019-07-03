//
//  PhotoCell.swift
//  PhotosApp
//
//  Created by Varun Tomar on 21/05/19.
//  Copyright © 2019 Varun Tomar. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellImage.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
}
