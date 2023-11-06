//
//  EditViewController.swift
//  shoppingListRx
//
//  Created by 황인호 on 11/6/23.
//

import UIKit
import RxSwift

class EditViewController: UIViewController {
    
    let editTextField = {
        let text = UITextField()
        text.placeholder = "수정할 단어를 입력해 주세요"

        return text
    }()
    
    let viewModel = ShoppingListViewModel()
    
    var completionHandler: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigation()
        setUI()
    
      
    }
    
    func setNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정", style: .done, target: self, action: #selector(modifyButtonTapped))
    }
    
    func setUI() {
        view.addSubview(editTextField)
        editTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            editTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            editTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func modifyButtonTapped() {
        completionHandler!(editTextField.text ?? "")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
}
