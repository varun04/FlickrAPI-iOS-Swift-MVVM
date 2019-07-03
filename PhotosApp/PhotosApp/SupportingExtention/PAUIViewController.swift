//
//  PAUIViewController.swift
//  PhotosApp
//
//  Created by Varun Tomar on 21/05/19.
//  Copyright © 2019 Varun Tomar. All rights reserved.
//

import Foundation
import UIKit

typealias Events = (_ retry: Bool)-> Void

extension UIViewController {
    func showAlertWithError(_ message: String, completionHandler: @escaping Events) {
        let alert = UIAlertController(title: NSLocalizedString("Opps!", comment: ""),
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""),
                                      style: .cancel,
                                      handler: nil))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""),
                                      style: .default,
                                      handler: { _ in completionHandler(true) }))
        present(alert, animated: true, completion: nil)
    }
}

