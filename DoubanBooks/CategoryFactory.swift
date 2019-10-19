//
//  CategoryFactoty.swift
//  DoubanBooks
//
//  Created by 2017YD on 2019/10/14.
//  Copyright © 2019 2017YD. All rights reserved.
//

import Foundation
import CoreData

final class CategoryFactory{
   
   var repository: Repository<VMCategory>
    var app: AppDelegate?
    
   private static var instance: CategoryFactory?
   private init(_ app: AppDelegate) {
        repository = Repository<VMCategory>(app)
    self.app = app
    }
    static func getInstance(_ app: AppDelegate) -> CategoryFactory{
        if let obj = instance {
            return obj
        } else {
            let token = "net.lzzy.factory.category"
            DispatchQueue.once(token: token, block: {
                if instance == nil{
                    instance = CategoryFactory(app)
                }
            })
              return instance!
        }
    }
    //查询所有
    func getAllCategories() throws -> [VMCategory] {
        return try repository.get()
    }
    //根据类别查询
    func getVague(_ cols: [String],keyword: String) throws -> [VMCategory]  {
        return try repository.getBy(cols, keyword: keyword )
    }
    //精确查询
    func getTing(_ cols: [String],keyword: String) throws -> [VMCategory] {
        return try repository.getExplicitlyBy([VMCategory.colName,VMCategory.colImage], keyword: keyword)
    }
    //新增
    func addCategory(category: VMCategory) throws -> (Bool, String?) {
        do{
            if try repository.isEntityExists([VMCategory.colName],keyword: category.name!){
                return (false,"图书已存在")
            }
           repository.insert(vm: category)
            return(true,nil)
            
        }catch DataError.entityExistsError(let info){
            return (false,info)
        }catch{
            return (false, error.localizedDescription)
        }
    }
    
    //根据ID来查询一个数据的长度
    func getBooksCountOfCategory(category id: UUID) -> Int? {
        do{
            return try
            BookFactory.getInstance(app!).getBooksOf(category: id).count
        }catch{
            return nil
        }
    }
    //修改
    func update(category: VMCategory ) throws{
        return try repository.update(vm: category)
    }
    //删除
    func remove(category: VMCategory) -> (Bool,String?) {
        if let count = getBooksCountOfCategory(category: category.id){
            if count > 0 {
                return (false,"存在该类别图书，不能删除")
            }
        }else{
            return (false,"无法获取类别信息")
        }
        do{
            try repository.delete(id: category.id)
            return (true,nil)
        }catch DataError.deleteEntityError(let info){
            return (false,info)
        }catch{
            return (false,error.localizedDescription)
        }
        }
        private static let plistName = "CategoryTimeList"
        static func updateEditTime(id: UUID){
        let path = Bundle.main.path(forResource: plistName, ofType: "plist")
        let dic = NSMutableDictionary(contentsOfFile: path!)
            dic?.setObject("2019/10/19 12:10", forKey: id.uuidString as NSCopying)
            dic?.write(toFile: path!, atomically: true)
    }
    static func getEditTimeFromPlist(id: UUID) -> String {
        let path = Bundle.main.path(forResource: plistName, ofType: "plist")
        let dic = NSMutableDictionary(contentsOfFile: path!)
        if let time = dic?[id.uuidString] as? String{
            return time
        }
        return "2019/10/19 12:10"
    }
    static func removeEditTime(id: UUID){
        let path = Bundle.main.path(forResource: plistName, ofType: "plist")
        let dic = NSMutableDictionary(contentsOfFile: path!)
        dic?.removeObject(forKey: id.uuidString)
        dic?.write(toFile: path!, atomically: true)
    }

}
extension DispatchQueue {
    private static var _onceTracker = [String]()
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
            
        }
        if _onceTracker.contains(token) {
            
            return
            
        }
        _onceTracker.append(token)
        
        block()
        
    }
    
}
