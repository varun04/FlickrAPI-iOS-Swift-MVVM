//
//  ViewController.swift
//  PhotosApp
//
//  Created by Varun Tomar on 20/05/19.
//  Copyright © 2019 Varun Tomar. All rights reserved.
//

import UIKit

class ImageSearchViewController: UIViewController {

    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var loadingLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    fileprivate var searchBar = UISearchBar()
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate var numberOfCellInArow:CGFloat = 3.0
    fileprivate var cellPadding:CGFloat = 10.0
    fileprivate var isLoading = false
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    var dataSource:ImageViewControllerDataSource = ImageViewControllerDataSource()
    lazy var viewModel:ImageControllerViewModel = {
        let vm = ImageControllerViewModel.init(dataSource: dataSource)
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self.viewModel.dataSource
        //Binding
        
        self.dataSource.data.addAndNotify(listner: self) {[weak self] (photos) in
            print(photos)
            self?.isLoading = false
            self?.removeLoader()
            self?.loadingLbl.text = ""
            self?.collectionView.reloadData()
        }
        
        self.viewModel.errorHandler = {[weak self] (message,error) in
            self?.showAlertWithError((error?.localizedDescription) ?? "Please check your Internet connection or try again.", completionHandler: { status in
                guard status else { return }
                self?.fetchImages()
            })
        }
        collectionView.delegate = self
        self.navigationBarSetUp()
    }
    
    func navigationBarSetUp() {
        searchBar.placeholder = "Search Images"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        let optionBtn = UIBarButtonItem(image: UIImage(named: "threeDots"), style: .plain, target: self, action: #selector(optionTapped))
        self.navigationItem.rightBarButtonItem = optionBtn
    }

    @objc func optionTapped() {
        let optionMenu = UIAlertController(title: "Select", message: "Number of images per row", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "2", style: .default) {[unowned self] (action) in
            self.numberOfCellInArow = 2
            self.collectionView.reloadData()
        }
        let action2 = UIAlertAction(title: "3", style: .default) {[unowned self] (action) in
            self.numberOfCellInArow = 3
            self.collectionView.reloadData()
        }
        let action3 = UIAlertAction(title: "4", style: .default) {[unowned self] (action) in
            self.numberOfCellInArow = 4
            self.collectionView.reloadData()
        }
        let action4 = UIAlertAction(title: "Cancel", style: .cancel) {(action) in
        }
        optionMenu.addAction(action1)
        optionMenu.addAction(action2)
        optionMenu.addAction(action3)
        optionMenu.addAction(action4)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func fetchImages() {
        if(Reachability.connectionAvailable()){
            self.viewModel.fetchSearchImages(searchText: searchBar.text ?? "")
        }else{
            self.showAlertWithError("Please check your Internet connection or try again.") { (retry) in
                if(retry){
                    self.fetchImages()
                }
            }
        }
    }
}

//MARK: - SearchBar Delegate
extension ImageSearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        //Reset old data first befor new search Results
        self.viewModel.resetValuesForNewSearch()
        guard let text = searchBar.text?.removeSpace,
            text.count != 0  else {
                loadingLbl.text = "Please type keyword to search result."
                return
        }
        //Requesting new keyword
        self.fetchImages()
        loadingLbl.text = "Searching Images..."
    }
}

//MARK: - Collection View Delegate
extension ImageSearchViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? PhotoCell{
            cell.cellImage.image = UIImage(named: "placeHolder")
            if let model = self.viewModel.dataSource?.data.value[indexPath.row]{
                ImageDownloadManager.shared.downloadImage(model, indexpath: indexPath) { (image, url,indexpath, error) in
                    DispatchQueue.main.async {
                        if let index = indexpath{
                            if let cell = collectionView.cellForItem(at: index) as? PhotoCell{
                                cell.cellImage.image = image
                            }
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //Reduce priority of the network operation in case the user scrolls and an image is no longer visible
        if(self.viewModel.dataSource?.data.value.count ?? 0 > indexPath.row){
            if let model = self.viewModel.dataSource?.data.value[indexPath.row]{
                ImageDownloadManager.shared.slowDownImageDownloadTaskfor(model)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.viewModel.dataSource?.data.value[indexPath.row]{
            let detailViewController:DetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailViewController.photo = model
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ImageSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width;
        let itemWidth = collectionWidth / numberOfCellInArow - cellPadding;
        
        return CGSize(width: itemWidth, height: itemWidth);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
}

//MARK: - Scrollview Delegate
extension ImageSearchViewController: UIScrollViewDelegate {
    //MARK :- Getting user scroll down event here
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height)){
                //locading new data
                if(!isLoading){
                    self.addLoader()
                    self.fetchImages()
                    isLoading = true
                }
            }
        }
    }
    //MARK: Loader at bottom
    fileprivate func addLoader() {
        self.activityIndicator.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.collectionViewBottomConstraint.constant = 40
        }, completion: nil)
    }

    fileprivate func removeLoader() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.activityIndicator.isHidden = true
            self.collectionViewBottomConstraint.constant = 0
        }, completion: nil)
    }
}
