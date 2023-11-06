//
//  ViewController.swift
//  shoppingListRx
//
//  Created by 황인호 on 11/5/23.
//

import UIKit
import RxSwift
import RxCocoa

final class ShoppingListTableViewController: UIViewController {
    
    private let tableView = {
        let view = UITableView()
        view.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: ShoppingListTableViewCell.identifier)
        view.backgroundColor = .lightGray
        view.rowHeight = 50
        return view
    }()
    
    private let topView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    
    private let searchBar = {
        let bar = UISearchBar()
        bar.placeholder = "무엇을 구매하실 건가요?"
     return bar
    }()
    
    private let addButton = {
        let button = UIButton()
        button.setTitle(" 추가 ", for: .normal)
        button.backgroundColor = .gray
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    
    let viewModel = ShoppingListViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        bind()
    }
    
    func bind() {
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingListTableViewCell.identifier, cellType: ShoppingListTableViewCell.self)) { (row, element, cell) in
                cell.listName.text = element.listName
                cell.checkButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        owner.viewModel.list[row].checkButton.toggle()
                        cell.cellConfigure(cell: owner.viewModel.list[row])
                    }
                    .disposed(by: cell.disposeBag)
                cell.starButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        owner.viewModel.list[row].star.toggle()
                        cell.starButton.setImage(owner.viewModel.list[row].star ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), for: .normal)
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        //삭제
        tableView.rx.itemDeleted
            .subscribe(with: self) { owner, indexPath in
                owner.viewModel.list.remove(at: indexPath.row)
                owner.viewModel.items.onNext(owner.viewModel.list)
            }
            .disposed(by: disposeBag)
        //수정
        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                let vc = EditViewController()
                vc.editTextField.text = owner.viewModel.list[indexPath.row].listName
                vc.completionHandler = { text in
                    owner.viewModel.list[indexPath.row].listName = text
                    owner.viewModel.items.onNext(owner.viewModel.list)
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
            
            
        
        
        addButton.rx.tap
            .withLatestFrom(searchBar.rx.text.orEmpty, resultSelector: { void, text in
                return text
            })
            .subscribe(with: self) { owner, _ in
                print("searchButtonClicked")
            }
            .disposed(by: disposeBag)
  
        addButton.rx.tap
            .withLatestFrom(searchBar.rx.text.orEmpty) { void, text in
                return text
            }
            .subscribe(with: self) { owner, text in
                owner.viewModel.list.insert(List(checkButton: false, listName: text, star: false), at: 0)
                owner.viewModel.items.onNext(owner.viewModel.list)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged() //같은 문자열을 입력했을 때
            .subscribe(with: self) { owner, value in
                let result = value == "" ? owner.viewModel.list : owner.viewModel.list.filter { $0.listName.contains(value) }
                owner.viewModel.items.onNext(result)
                print("==실시간 검색==")
            }
            .disposed(by: disposeBag)
        
    }
    
    
    func setUI() {
        [tableView, topView, searchBar, addButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            topView.heightAnchor.constraint(equalToConstant: 80),
            
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            searchBar.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            searchBar.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10),
            
            addButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -10)
        
        ])
        
        
        
    }

}

