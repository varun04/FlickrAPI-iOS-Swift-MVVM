//
//  DetailViewController.swift
//  PhotosApp
//
//  Created by Varun Tomar on 21/05/19.
//  Copyright © 2019 Varun Tomar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.delegate = self
        loadImage()
    }
    
    func loadImage () {
        self.loaderView.startAnimating()
        ImageDownloadManager.shared.downloadImage(photo, size: "b", indexpath: nil) { [weak self] (image, url,indexPath, error) in
            DispatchQueue.main.async {
                self?.loaderView.stopAnimating()
                self?.imageView.image = image
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for view in scrollView.subviews where view is UIImageView {
            return view as! UIImageView
        }
        return nil
    }
}
