//
//  ShoppingListTableViewCell.swift
//  shoppingListRx
//
//  Created by 황인호 on 11/5/23.
//

import UIKit
import RxSwift

final class ShoppingListTableViewCell: UITableViewCell {
    
    let listName = {
        let label = UILabel()
        label.text = "ddddd"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
       return label
    }()
    
    let checkButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        return button
    }()
    
    let starButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        return button
    }()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // 인스턴스 초기화
        
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellConfigure(cell: List) {
        checkButton.setImage(cell.checkButton ? UIImage(systemName: "check.square") : UIImage(systemName: "check.square.fill"), for: .normal)
        
        starButton.setImage(cell.star ? UIImage(systemName: "star") : UIImage(systemName: "star.fill"), for: .normal)
        
    }
    
 
    func setUI() {
        [checkButton, starButton, listName].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            
            starButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            starButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            starButton.widthAnchor.constraint(equalTo: starButton.heightAnchor, multiplier: 1),
            
            checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.widthAnchor.constraint(equalTo: checkButton.heightAnchor, multiplier: 1),
            
            listName.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 10),
            listName.trailingAnchor.constraint(equalTo: starButton.leadingAnchor, constant: -10),
            listName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            
        
        ])
        
        
        
    }
}
