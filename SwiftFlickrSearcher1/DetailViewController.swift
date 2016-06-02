//
//  DetailViewController.swift
//  SwiftFlickrSearcher1
//
//  Created by suraj poudel on 30/05/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit


class ImageCell:UICollectionViewCell{
    
    @IBOutlet weak var imageView:UIImageView!
}

class DetailViewController:UIViewController{
    
    @IBOutlet var collectionView:UICollectionView!
    var photos:[Flickr.Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecongizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.handleTap))
        view.addGestureRecognizer(tapRecongizer)
    }
    
    func handleTap(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension DetailViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let imageCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ImageCell
        
        let photo = self.photos[indexPath.item]
        photo.loadImage(true) { (result) in
            switch result{
            case .Error:
                break
            case .Result(let image):
                imageCell.imageView.image = image
            }
        }
        
        return imageCell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = view.bounds.width/3
        
        let height = (width/4) * 3
        
        return CGSize(width:width,height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}
