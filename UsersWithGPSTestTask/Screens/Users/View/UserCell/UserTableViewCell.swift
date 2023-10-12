//
//  UserTableViewCell.swift
//  e-legionTestTask
//
//  Created by Aleksandr Prokopenko on 10.03.2023.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    var userViewViewModel: UserViewViewModel? {
        didSet {
            userView.userViewViewModel = userViewViewModel
        }
    }
    
    private let userView: UserView = {
        var view = UserView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        addSubview(userView)
    }
    
    private func setupLayout() {
        setupUserViewLayout()
    }
    
    private func setupUserViewLayout() {
        NSLayoutConstraint.activate([userView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
                                     userView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                                     userView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
                                     userView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)])
    }

}
