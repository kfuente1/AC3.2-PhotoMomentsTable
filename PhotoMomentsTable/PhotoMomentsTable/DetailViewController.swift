//
//  DetailViewController.swift
//  PhotoMomentsTable
//
//  Created by Karen Fuentes on 1/23/17.
//  Copyright © 2017 Karen Fuentes. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: UIViewController {

    var chosenAsset: PHAsset!
    
    
    @IBOutlet weak var fullImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = PHImageManager()
        
        let destinationSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        manager.requestImage(for: chosenAsset, targetSize: destinationSize, contentMode: .aspectFit, options: nil, resultHandler: { (image: UIImage?, _) in
            if let resquestedImage = image {
                self.fullImage.image = resquestedImage
            }
        })
        
        
    }
    
    
}
