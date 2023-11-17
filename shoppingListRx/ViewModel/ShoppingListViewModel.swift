//
//  ShoppingListViewModel.swift
//  shoppingListRx
//
//  Created by 황인호 on 11/5/23.
//

import Foundation
import RxSwift

class ShoppingListViewModel: ViewModelType {
    
//    var list: List?
    var list: [List] = [
        List(checkButton: false, listName: "맥북", star: false),
        List(checkButton: false, listName: "아이패드", star: false),
        List(checkButton: false, listName: "아이폰", star: false),
        List(checkButton: false, listName: "애플워치", star: false)
    ]

    
    struct Input {
        let addButtonTap: Observable<Void> //추가버튼

    }
    
    struct Output {
        let items: BehaviorSubject<[List]> // 처음 목록
    }
    
    
    func transform(input: Input) -> Output {
        let items = BehaviorSubject<[List]>(value: list)
        
        return Output(items: items)
    }
    
    
    lazy var items = BehaviorSubject(value: list)

    let disposeBag = DisposeBag()

    
  
    
}


