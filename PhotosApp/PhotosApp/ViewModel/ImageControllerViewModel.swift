//
//  ImageControllerViewModel.swift
//  PhotosApp
//
//  Created by Varun Tomar on 21/05/19.
//  Copyright © 2019 Varun Tomar. All rights reserved.
//

import Foundation

class ImageControllerViewModel {
    
    var dataSource:ImageViewControllerDataSource?
    var requestHandler:RequestHandler?
    var errorHandler:((_ message:String,_ error:Error?) -> Void)?
    fileprivate var pageCount = 0

    init(dataSource:ImageViewControllerDataSource,service:RequestHandler = RequestHandler()) {
        self.dataSource = dataSource
        self.requestHandler = service
    }
    
    func fetchSearchImages(searchText:String) {
        pageCount+=1
        requestHandler?.requestFor(text: searchText, with: pageCount.description, decode: Photos.self, completionHandler: {[unowned self] (result) in
            DispatchQueue.main.async {
                switch result{
                case .success(let value):
                    self.updateSearchResult(with: value.photos.photo)
                    break
                case .failure(let error):
                    print(error.debugDescription)
                    break
                }
            }
        })
    }
    
    //clearing here old data search results
    func resetValuesForNewSearch(){
        pageCount = 0
        self.requestHandler?.cancelTask()
        self.dataSource?.data.value.removeAll()
        ImageDownloadManager.shared.cancelAllOperation()
    }
    
    func updateSearchResult(with photo: [Photo]){
        DispatchQueue.main.async { [unowned self] in
            let newItems = photo
            // update data source
            self.dataSource?.data.value.append(contentsOf: newItems)
        }
    }
}

