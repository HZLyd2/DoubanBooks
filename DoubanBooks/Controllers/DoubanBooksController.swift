//
//  DoubanBooksController.swift
//  DoubanBooks
//
//  Created by 2017YD on 2019/10/18.
//  Copyright © 2019 2017YD. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CategoryCell"

var  categories:[VMCategory]?
var factory = CategoryFactory.getInstance(UIApplication.shared.delegate as! AppDelegate)

class DoubanBooksController: UICollectionViewController {
    
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            categories = try factory.getAllCategories()
        }catch DataError.readCollectionError(let info){
            categories = [VMCategory]()
            UIAlertController.showAlertAndDismiss(info, in: self)
        }catch{
            categories = [VMCategory]()
        }

     self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        
    }
    //跳转视图
     
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categories!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        let categroy = categories![indexPath.item]
        cell.lblName.text = categroy.name!
        cell.lblCount.text = String(factory.getBooksCountOfCategory(category: categroy.id)!)
        cell.btnDel.isHidden = true //随普通模式和删除模式切换
        return cell
    }
   
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
