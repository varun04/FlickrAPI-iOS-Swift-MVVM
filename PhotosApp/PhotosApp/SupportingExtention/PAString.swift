//
//  PAString.swift
//  PhotosApp
//
//  Created by Varun Tomar on 21/05/19.
//  Copyright © 2019 Varun Tomar. All rights reserved.
//

import Foundation

protocol SearchTextSpaceRemover{}

extension String: SearchTextSpaceRemover {
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension SearchTextSpaceRemover where Self == String {
    
    //MARK: - Removing space from String
    var removeSpace: String {
        if self.isNotEmpty {
            return self.components(separatedBy: .whitespaces).joined()
        }else{
            return ""
        }
    }
}
