//
//  Photo.swift
//  PhotosApp
//
//  Created by Varun Tomar on 20/05/19.
//  Copyright © 2019 Varun Tomar. All rights reserved.
//

import Foundation


struct Photos: Codable {
    let photos: PhotosData
}

/*
 page = 1
 pages = 4545
 perpage = 100
 total = "454406"
 */
struct PhotosData: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}

/*
 id = "47837182682"
 owner = "98501951@N08"
 secret = "77160502ef"
 server = "65535"
 farm = 66
 title = "ULTRABIKE 2019"
 ispublic = 1
 isfriend = 0
 isfamily = 0
 */
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}

extension Photo{
    func getImagePath(_ size:String = "m") -> URL?{
        let path = "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret)_\(size).jpg"
        return URL(string: path)
    }
}
