//
//  ViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 29/12/2016.
//  Copyright © 2016 AshArthur. All rights reserved.
//

import UIKit

class PaletteDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.image = palette?.sourceImage
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var cellLayout: UICollectionViewFlowLayout!
    
    var palette: RepresentativePalette?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.collectionViewLayout = cellLayout
        setupCollectionCellSize(viewSize: view.frame.size)
        collectionView.reloadData()

    }

    func setupCollectionCellSize(viewSize: CGSize){
        
        if viewSize.height > viewSize.width {
            // Portrait Mode
            let cellwidth = ((viewSize.width/6) - 10)
            cellLayout.itemSize = CGSize.init(width: cellwidth, height: cellwidth)
        }
        else {
            // Landscape
            let cellwidth = ((viewSize.width/5) - 10)
            cellLayout.itemSize = CGSize.init(width: cellwidth, height: cellwidth)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func display(_ image:UIImage){
        // FIXME: Handle possible error
        palette = RepresentativePalette(sourceImage: image)!
        print(palette!)
    }
    
}

extension PaletteDetailViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return palette?.colors.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwatchCollectionCell.defaultReuseIdentifier, for: indexPath) as! SwatchCollectionCell
    
        cell.colorView.backgroundColor = palette?.colors[indexPath.item].uiColor
        
        return cell 
    }
    
}
