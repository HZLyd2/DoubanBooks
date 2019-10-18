//
//  DataError.swift
//  Movie
//
//  Created by 2017YD on 2019/10/12.
//  Copyright © 2019 2017YD. All rights reserved.
//

import Foundation
import UIKit

enum DataError:Error {
    case readCollectionError(String)    //
    case readSingleError(String)        //单独的抛出异常
    case entityExistsError(String)      //实体的抛出异常
    case deleteEntityError(String)      //删除的抛出异常
    case updateEntityError(String)      //修改的抛出异常
}
extension UIAlertController{
    static func showAlert(_ message:String,in
        controller:UIViewController){
        //显示警告框
        let alert = UIAlertController(title: "警告", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    static func showConfirm(_ message: String,in controller: UIAlertController,confirm:((UIAlertAction) -> Void)?){
        //显示一个对话框，确定按钮可执行confirm方法
        let alert = UIAlertController(title: "警告",message: "内容不能为空", preferredStyle: .alert)
        let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let firm = UIAlertAction(title: "确认", style: .default, handler: confirm)
        alert.addAction(firm)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertAndDismiss(_ message:String ,in controller: UIViewController ,completion:(()->Void)? = nil){
        //显示警告框，几秒后消失
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        controller.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3, execute: {()-> Void in
            controller.presentedViewController?.dismiss(animated: true, completion: completion)
        })
    }
}
