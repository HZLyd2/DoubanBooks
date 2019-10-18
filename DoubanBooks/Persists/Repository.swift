//
//  Repository.swift
//  DoubanBooks
//
//  Created by 2017YD on 2019/10/15.
//  Copyright © 2019 2017YD. All rights reserved.
//

import Foundation
import CoreData

class Repository<T: DataViewModelDelegate> where T: NSObject {
    var app: AppDelegate
    var context: NSManagedObjectContext
    
    //insert,get,getBykeyword,deletp,update
    
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    //插入一笔新的数据
    func insert(vm: T) {
        let description = NSEntityDescription.entity(forEntityName: T.entityName, in: context)
        let obj = NSManagedObject(entity: description!, insertInto: context)
        for (key,value) in vm.entityPairs(){
            obj.setValue(value, forKey: key)
        }
        app.saveContext()
    }
    /// 根据条件判断实体是否存在
    ///
    /// - parameter cols: 查询条件要匹配的列
    /// - par
    func isEntityExists(_ cols: [String],keyword: String) throws -> Bool {
        var format = ""
        var args = [String]()
        for col in cols {
            format += "\(col) = %@ || "
            args.append(keyword)
        }
        format.removeLast(3)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do{
            let result = try context.fetch(fetch)
            return result.count > 0
        }catch {
            throw DataError.entityExistsError("判断数据存在失败 ")
        }
    }
    /// 从本地数据库读取
    ///
    /// 获取数据
    //搜索
    func get() throws -> [T] {
        var items = [T]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        do{
            let result = try context.fetch(fetch)
            for c in result {
                let t = T()
                t.packageSelf(result: c as! NSFetchRequestResult)
                items.append(t)
            }
        }
        return items
    }
    
    /// 根据关键字词查询某一实体类符合条件的数据，模糊查询
    ///
    /// - parameter cols: 需要匹配的列如：["name","publisher"]
    /// - parameter keyword: 要搜索的关键词
    /// - returns：视图模型对象集合
    func getBy(_ cols: [String],keyword: String) throws -> [T] {
        var format = ""
        var args = [String]()
        for col in cols {
            format += "\(col) like[c] %@ || "
            args.append("*\(keyword)*")
        }
        format.removeLast(3)
        var items = [T]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do{
            let result = try context.fetch(fetch)
            for c in result {
                let t = T()
                t.packageSelf(result: c as! NSFetchRequestResult)
                items.append(t)
            }
        }catch{
            throw DataError.readCollectionError("读取集合数据失败")
        }
        return items
    }
    
    
    //按关键字来查询
    func getExplicitlyBy(_ cols: [String],keyword: String) throws -> [T] {
        var items = [T]()
        var format = ""
        var args = [String]()
        for col in cols {
            format += "\(col) = %@ || "
            args.append(keyword)
        }
        format.removeLast(3)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do{
            let result = try context.fetch(fetch)
            for c in result {
                let t = T()
                
                t.packageSelf(result: c as! NSFetchRequestResult)
                items.append(t)
            }
        }catch{
            throw DataError.readCollectionError("读取集合数据失败")
        }
        return items
    }
    //更新
    func update(vm: T) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
        
        do{
            let obj = try context.fetch(fetch)[0] as! NSManagedObject
            for (key,value) in vm.entityPairs(){
                obj.setValue(value, forKey: key)
            }
            app.saveContext()
        }catch{
            throw DataError.updateEntityError("更新图书失败")
        }
    }
    //删除
    func delete(id: UUID) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do{
            let result = try context.fetch(fetch)
            for b in result{
                context.delete(b as! NSManagedObject)
            }
            app.saveContext()
        }catch{
            throw DataError.deleteEntityError("删除错误")
        }
        
    }
    
}
