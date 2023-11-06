//
//  ShoppingListViewModel.swift
//  shoppingListRx
//
//  Created by 황인호 on 11/5/23.
//

import Foundation
import RxSwift

class ShoppingListViewModel {
    
    
    
    var list: [List] = [
        List(checkButton: false, listName: "맥북", star: false),
        List(checkButton: false, listName: "아이패드", star: false),
        List(checkButton: false, listName: "아이폰", star: false),
        List(checkButton: false, listName: "애플워치", star: false)
    ]
    
    lazy var items = BehaviorSubject(value: list)

    let disposeBag = DisposeBag()

    
  
    
}


