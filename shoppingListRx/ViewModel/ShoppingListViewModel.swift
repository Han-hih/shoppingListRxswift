//
//  ShoppingListViewModel.swift
//  shoppingListRx
//
//  Created by 황인호 on 11/5/23.
//

import Foundation
import RxSwift

class ShoppingListViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    var list: [List] = [
        List(checkButton: false, listName: "맥북", star: false),
        List(checkButton: false, listName: "아이패드", star: false),
        List(checkButton: false, listName: "아이폰", star: false),
        List(checkButton: false, listName: "애플워치", star: false)
    ]

    struct Input {
        let addButtonTap: Observable<Void> //추가버튼
        let addText: Observable<String>
        let deleteRow: Observable<IndexPath>
        let modifyRow: Observable<IndexPath>
        let pushNavigation: Observable<IndexPath>
    }
    
    struct Output {
        let items: BehaviorSubject<[List]> // 처음 목록
        let nextScreen: Observable<Void>
    }
    
    
    func transform(input: Input) -> Output {
        let items = BehaviorSubject<[List]>(value: list)
        let nextScreen = PublishSubject<Void>()
        
        
        input.addButtonTap
            .withLatestFrom(input.addText) { void, text in
            return text
        }
            .subscribe(with: self) { owner, text in
                owner.list.insert(List(checkButton: false, listName: text, star: false), at: 0)
                items.onNext(owner.list)
            }
            .disposed(by: disposeBag)
        
        input.deleteRow
            .subscribe(with: self) { owner, indexPath in
                owner.list.remove(at: indexPath.row)
                items.onNext(owner.list)
            }
            .disposed(by: disposeBag)
        
        input.modifyRow
            .subscribe(with: self) { owner, indexPath in
                print("ddddddddddd")
                let vc = EditViewController()
                vc.editTextField.text = owner.list[indexPath.row].listName
                vc.completionHandler = { text in
                    owner.list[indexPath.row].listName = text
                    items.onNext(owner.list)
                }
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(items: items, nextScreen: nextScreen)
    }

    
  
    
}


