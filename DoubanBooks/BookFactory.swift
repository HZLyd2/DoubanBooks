//
//  BookFactory.swift
//  DoubanBooks
//
//  Created by 2017YD on 2019/10/14.
//  Copyright © 2019 2017YD. All rights reserved.
//

import Foundation
import CoreData

final class BookFactory{
    var repository: Repository<VMBook>
    private static var instance: BookFactory?
    
    private init(_ app: AppDelegate) {
        
        repository = Repository<VMBook>(app)
    }
    static func getInstance(_ app: AppDelegate) -> BookFactory{
        if let obj = instance {
            return obj
        } else {
            let token = "net.lzzy.factory.book"
            DispatchQueue.once2(token: token, block: {
                if instance == nil{
                    instance = BookFactory(app)
                }
            })
            return instance!
        }
    }
    //
    func getBooksOf(category id: UUID) throws -> [VMBook] {
        return try repository.getExplicitlyBy([VMBook.colCategoryId], keyword: id.uuidString)
    }
    //查询所有
    func getAllBook() throws -> [VMBook] {
        return try repository.get()
    }
    //根据ID来查询
    func getBookBy(id: UUID) throws -> VMBook? {
        let books = try
        repository.getExplicitlyBy([VMBook.colId], keyword: id.uuidString)
        if books.count > 0 {
            return books[0]
        }
        return nil
    }
    //
    func isBookExists(book: VMBook) throws -> Bool {
        var match10 = false
        var match13 = false
        if let isbn10 = book.isbn10{
            if isbn10.count > 0{
                match10 = try
                repository.isEntityExists([VMBook.colIsbn10], keyword: isbn10)
            }
        }
        if let isbn13 = book.isbn13{
            if isbn13.count > 0 {
                match13 = try
                repository.isEntityExists([VMBook.colIsbn13], keyword: isbn13)
         }
      }
         return match13 || match10
}
    //模糊查询
    func searchBooks(keyword: String) throws -> [VMBook] {
        let cols =
        [VMBook.colIsbn13]
        let books = try repository.getBy(cols, keyword: keyword)
        return books
    }
    //修改
    func update(book: VMBook ) throws{
        return try repository.update(vm: book)
    }
    //新增
    func addBook(book: VMBook) throws -> (Bool, String?) {
        do{
            if try isBookExists(book: book){
                return (false,"图书已存在")
            }
             repository.insert(vm: book)
            return(true,nil)

        }catch DataError.entityExistsError(let info){
            return (false,info)
        }catch{
            return (false, error.localizedDescription)
        }
    }
    //删除
    func removeBook(id: UUID) -> (Bool,String?) {
        do{
            try repository.delete(id: id)
            return (true,nil)
        }catch DataError.deleteEntityError(let info){
            return (false,info)
        }catch{
            return (false,error.localizedDescription)
        }
    }
}
extension DispatchQueue {
    private static var _onceTracker = [String]()
    public class func once2(token: String, block: () -> Void) {
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
