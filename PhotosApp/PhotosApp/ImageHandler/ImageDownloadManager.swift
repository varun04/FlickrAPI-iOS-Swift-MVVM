//
//  ImageHandler.swift
//  PhotosApp
//
//  Created by Varun Tomar on 21/05/19.
//  Copyright © 2019 Varun Tomar. All rights reserved.
//

import UIKit

typealias ImageDownloadHandler = (_ image: UIImage?, _ url: URL,_ indexpath:IndexPath?, _ error: Error?) -> Void

final class ImageDownloadManager {
    private var completionHandler: ImageDownloadHandler?
    lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.photoApp.imageDownloadQueue"
        queue.qualityOfService = .background
        return queue
    }()
    private let imageCache = NSCache<NSString, UIImage>()
    static let shared = ImageDownloadManager()
    
    func downloadImage(_ photo: Photo, size: String = "m", indexpath:IndexPath?, handler: @escaping ImageDownloadHandler) {
        self.completionHandler = handler
        guard let url = photo.getImagePath(size) else {
            return
        }
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            /* check for the cached image for url, if YES then return the cached image */
            print("Return cached Image for \(url)")
            self.completionHandler?(cachedImage, url,indexpath, nil)
        } else {
            /* check if there is a download task that is currently downloading the same image. */
            if let operations = (imageDownloadQueue.operations as? [PAOperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
                print("Increase the priority for \(url)")
                operation.queuePriority = .veryHigh
            }else {
                /* create a new task to download the image.  */
                print("Create a new task for \(url)")
                let operation = PAOperation(url: url, indexPath: indexpath)
                if size == "b" {
                    operation.queuePriority = .high
                }else{
                    operation.queuePriority = .normal
                }
                operation.downloadHandler = { (image, url, indexpath, error) in
                    if let newImage = image {
                        self.imageCache.setObject(newImage, forKey: url.absoluteString as NSString)
                    }
                    self.completionHandler?(image, url, indexpath, error)
                }
                imageDownloadQueue.addOperation(operation)
            }
        }
    }
    
    /*To reduce the priority of the operation in case the user scrolls and an image is no longer visible. */
    func slowDownImageDownloadTaskfor (_ photo: Photo) {
        guard let url = photo.getImagePath() else {
            return
        }
        if let operations = (imageDownloadQueue.operations as? [PAOperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
            print("Reduce the priority for \(url)")
            operation.queuePriority = .low
        }
    }
    
    func cancelAllOperation() {
        imageDownloadQueue.cancelAllOperations()
    }
    
}
