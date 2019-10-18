//
//  CategoryRepository.swift
//  DoubanBooks
//
//  Created by 2017YD on 2019/10/12.
//  Copyright © 2019 2017YD. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CategoryRepository{
    var app: AppDelegate
    var context: NSManagedObjectContext
    
    //insert,get,getBykeyword,deletp,update
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    //插入一笔新的数据
    func insert(cate: VMCategory) throws {
        let description = NSEntityDescription.entity(forEntityName: VMCategory.entityName, in: context)
        let category = NSManagedObject(entity: description!, insertInto: context)
        
        category.setValue(cate.id,forKey: VMCategory.colId)
        category.setValue(cate.name,forKey: VMCategory.colName)
        category.setValue(cate.image,forKey: VMCategory.colImage)
        let category2 = try? get(keyword: cate.name)
        if category2!.count > 0 {
            print("书名重复")
           // UIAlertController.showAlert("书名重复", in: self)
        }else{
             app.saveContext()
        }
    }
    
    func isExists(name: String) throws -> Bool {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "\(VMCategory.colName) = %@", name)
        do {
            let result = try context.fetch(fetch) as! [VMCategory]
            return result.count > 0
        } catch {
            throw DataError.entityExistsError("判断存在数据失败")
        }
    }
    //搜索
    func get(keyword:String? = nil) throws -> [VMCategory] {
        var category = [VMCategory]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        do{
             let result = try context.fetch(fetch) as! [Category]
            for c in result {
                let vm = VMCategory()
                vm.id = c.id!
                vm.name = c.name
                vm.image = c.image
                 category.append(vm)
            }
        }catch{
            throw DataError.readCollectionError("读取集合数据失败")
        }
        if let kw = keyword {
            fetch.predicate = NSPredicate(format: "name like[c] %@", "*\(kw)*")
       }
        let result = try context.fetch(fetch) as! [Category]
        for itme in result {
            let vm = VMCategory()
            vm.id = itme.id!
            vm.name = itme.name
            vm.image = itme.image

            category.append(vm)
        }
        return category
    }
    //删除
    func delete(id: UUID) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        let result = try context.fetch(fetch) as! [Category]
        for m in result{
            context.delete(m)
        }
        app.saveContext()
    }
}
