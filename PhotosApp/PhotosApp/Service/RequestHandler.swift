//
//  RequestHandler.swift
//  PhotosApp
//
//  Created by Varun Tomar on 20/05/19.
//  Copyright © 2019 Varun Tomar. All rights reserved.
//

import Foundation

class RequestHandler{
    
    fileprivate let flickrKey = "75f49785083cf8953a3febfae04469da"
    var requestCancelStatus = false
    var perPageCount = 40
    
    enum Result<value>{
        case success(value)
        case failure(Error?)
    }
    
    fileprivate var task: URLSessionTask?
    
    //MARK: - Make URL here based on keyword & page counts
    fileprivate func getURL_Path(_ pageCount: String, and text: String) -> URL?{
        
        guard let urlPath = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(flickrKey)&format=json&nojsoncallback=1&safe_search=\(pageCount)&text=\(text)&per_page=\(perPageCount)") else {
            return nil
        }
        return urlPath
    }
    
    func cancelTask(){
        requestCancelStatus = true
        task?.cancel()
    }
}


extension RequestHandler: SearchTextSpaceRemover{
    
    func requestFor<T: Codable>(text: String, with pageCount: String, decode:T.Type, completionHandler: @escaping(Result<T>) -> Void){
        
        let keyword = text.removeSpace
        guard keyword.count != 0 else { return }
        
        let session = URLSession.shared
        guard let urlPath = getURL_Path(pageCount, and: keyword) else { return }
        
        task = session.photosTask(with: urlPath, decodingType: T.self, completionHandler: { photos, response, error in
            DispatchQueue.main.async {
                guard error == nil,
                    let result = photos else {
                        self.requestCancelStatus = false
                        print("Error I : \(error?.localizedDescription ?? "")")
                        completionHandler(.failure(error))
                        return
                }
                completionHandler(.success(result))
            }
        })
        task?.resume()
    }
    
    fileprivate func requestTimeOut(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20), execute: {
            self.task?.resume()
        })
    }
}
