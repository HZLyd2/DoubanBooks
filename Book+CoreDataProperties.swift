//
//  Book+CoreDataProperties.swift
//  DoubanBooks
//
//  Created by 2017YD on 2019/10/12.
//  Copyright © 2019 2017YD. All rights reserved.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var authorIintro: String?
    @NSManaged public var categoryId: UUID?
    @NSManaged public var id: UUID?
    @NSManaged public var image: String?
    @NSManaged public var isbn10: String?
    @NSManaged public var isbn13: String?
    @NSManaged public var pages: Int32
    @NSManaged public var price: Float
    @NSManaged public var pubdate: String?
    @NSManaged public var publisher: String?
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
    @NSManaged public var binding: String?

}
