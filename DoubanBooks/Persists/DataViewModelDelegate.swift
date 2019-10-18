//
//  DataViewModelDelegate.swift
//  DoubanBooks
//
//  Created by 2017YD on 2019/10/15.
//  Copyright © 2019 2017YD. All rights reserved.
//

import Foundation
import CoreData
/**
 - 约束视图模型类实现，暴露CoreData Entity相关属性及组装视图模型对象
 */

protocol DataViewModelDelegate {
    /// 视图模型必须具有id属性
    var id: UUID {get}
    /// 视图模型对应的CoreData Entity的名称
    static var entityName: String {get}
    /// CoreData Entity属性与对应的视图模型对象的属性值集合
    ///
    /// -returns: key是CoreData Entity的各个属性的名称，Any是对应的值
    func entityPairs() -> Dictionary<String,Any?>
    /// 根据查询结果组装视图模型对象
    ///
    ///
    func packageSelf(result: NSFetchRequestResult)
    
}
