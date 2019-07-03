//
//  InternetCheck.swift
//  PhotosApp
//
//  Created by Varun Tomar on 22/05/19.
//  Copyright © 2019 Varun Tomar. All rights reserved.
//

import Foundation

extension Reachability
{
    static func connectionAvailable() -> Bool
    {
        let reachability:Reachability? = Reachability()
        guard let rbility = reachability else
        {
            return false
        }
        return rbility.isReachable
    }
}
