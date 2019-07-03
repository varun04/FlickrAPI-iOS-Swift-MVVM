//
//  ImageViewControllerDataSource.swift
//  PhotosApp
//
//  Created by Varun Tomar on 21/05/19.
//  Copyright © 2019 Varun Tomar. All rights reserved.
//

import Foundation
import UIKit

class GenricDataSource<T> : NSObject{
    var data : GenricValue<[T]> = GenricValue([])
}

class ImageViewControllerDataSource: GenricDataSource<Photo>, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        guard self.data.value.count != 0 else {
            return cell
        }
        return cell
    }
}

