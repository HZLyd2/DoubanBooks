//
//  AddCategoryController.swift
//  DoubanBooks
//
//  Created by 2017YD on 2019/10/19.
//  Copyright © 2019 2017YD. All rights reserved.
//

import UIKit

  let imgDir = "/DOcuments/"
class AddCategoryController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var txtName: UITextField!
   // imgCover
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func saveCategory() throws  {
        let name = txtName.text
        //TODO: 1.检查数据的完整性
        let category = VMCategory()
        category.name = name
        category.image = category.id.uuidString + ".jpg"
        let (success,info) = try factory.addCategory(category: category)
        if !success{
            UIAlertController.showAlertAndDismiss(info!, in: self)
            return
        }
        saveImage(image: selectedImage!, fileName: category.image!)
        //TODO: 2.添加类别编辑时间plist
        //TODO: 3.使用Notification通知列表更新
    }
    func saveImage(image: UIImage,fileName: String) {
        if let imgData = image.jpegData(compressionQuality: 1) as NSData?{
            let path = NSHomeDirectory().appending(imgDir).appending(fileName)
            imgData.write(toFile: path, atomically: true)
        }
    }
    @IBAction func pickFroPhotoLibrary(_ sender: Any) {
        let imgController = UIImagePickerController()
        imgController.sourceType = .photoLibrary
        imgController.delegate = self
        present(imgController,animated: true,completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image =
        info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imgCover.image = image
        selectedImage = image
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
