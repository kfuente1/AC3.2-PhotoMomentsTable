//
//  PhotoMomentsTableViewController.swift
//  PhotoMomentsTable
//
//  Created by Karen Fuentes on 1/22/17.
//  Copyright © 2017 Karen Fuentes. All rights reserved.
//

import UIKit
import Photos

class PhotoMomentsTableViewController: UITableViewController {
    
    var collectionFetchResult = PHFetchResult<PHCollection>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let momentsLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: nil)
        for i in 0..<momentsLists.count {
            print("Title: ", momentsLists[i].localizedTitle ?? "no title")
            let moments = momentsLists[i]
            let collectionList = PHCollectionList.fetchCollections(in: moments, options: nil)
            
            self.collectionFetchResult = collectionList
            print("collectionFetchResult count: \(self.collectionFetchResult.count)")
            
            for j in 0..<collectionFetchResult.count {
                if let collection = collectionList[j] as? PHAssetCollection {
                    printAssetsInList(collection: collection)
                }
            }
        }
    }
    
    func printAssetsInList(collection: PHAssetCollection) {
        let assets = PHAsset.fetchAssets(in: collection, options: nil)
        print("\n---\(assets.count)---\n")
        for j in 0..<assets.count {
            print(assets[j])
            if j > 10 {
                break
            }
        }
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
     return self.collectionFetchResult.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let collection = self.collectionFetchResult[section] as! PHAssetCollection
        let assets = PHAsset.fetchAssets(in: collection, options: nil)
        return assets.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.collectionFetchResult[section].localizedTitle ?? "Unknown location"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photosCell", for: indexPath)
        
        let manager = PHImageManager.default()
        
        if cell.tag != 0 {
            manager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        let collection = self.collectionFetchResult[indexPath.section] as! PHAssetCollection
        
        let assets = PHAsset.fetchAssets(in: collection, options: nil)
        let asset = assets[indexPath.row]
        
        if let creationDate = asset.creationDate {
            cell.textLabel?.text = DateFormatter.localizedString(from: creationDate,
                                                                 dateStyle: .medium,
                                                                 timeStyle: .medium
            )
        } else {
            cell.textLabel?.text = "Unknown date ¯\"_(ツ)_/¯ "
        }
        
        cell.tag = Int(manager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0),
                                            contentMode: .aspectFill,
                                            options: nil) { (image: UIImage?, _) in
                                                
                                                if let destinationCell = tableView.cellForRow(at: indexPath),
                                                    let unwrappedImage = image {
                                                    print("The loaded image: \(unwrappedImage)")
                                                    destinationCell.imageView?.image = unwrappedImage
                                                    
                                                    DispatchQueue.main.async {
                                                        cell.setNeedsLayout()
                                                    }
                                                }
        })
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullImageSegue" {
            if let dvc = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let collection = collectionFetchResult[indexPath.section] as! PHAssetCollection
                let assets = PHAsset.fetchAssets(in: collection, options: nil)
                let assetsInCell = assets[indexPath.row]
                dvc.chosenAsset = assetsInCell
            }
        }
    }

}
