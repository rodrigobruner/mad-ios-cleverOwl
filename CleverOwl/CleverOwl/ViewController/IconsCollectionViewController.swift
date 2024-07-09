//
//  IconsCollectionViewController.swift
//  CleverOwl
//
//  Created by user228347 on 7/8/24.
//

import UIKit

private let reuseIdentifier = "Cell"

class IconsCollectionViewController: UICollectionViewController {

    @IBOutlet var colectionView: UICollectionView!
    
    let icons = ["iconName1", "iconName2", "iconName3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }



    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return icons.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        if let imageView = cell.viewWithTag(100) as? UIImageView {
            imageView.image = UIImage(named: icons[indexPath.row])
        }
    
        return cell
    }

}
