//
//  UserView.swift
//  e-legionTestTask
//
//  Created by Aleksandr Prokopenko on 10.03.2023.
//

import UIKit

class UserView: UIView {
    
    var userViewViewModel: UserViewViewModel? {
        didSet {
            if let user = userViewViewModel {
                userImage.image = UIImage(named: user.image)
                userName.text = user.name
                userDistance.text = user.distance
            }
        }
    }
    
    private let backgroundView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .gray
        return view
    }()
    
    private let userImage: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let nameDistanceStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let userName: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userDistance: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        addSubview(backgroundView)
        backgroundView.addSubview(userImage)
        nameDistanceStackView.addArrangedSubview(userName)
        nameDistanceStackView.addArrangedSubview(userDistance)
        backgroundView.addSubview(nameDistanceStackView)
    }
    
    private func setupLayout() {
        setupBackgroundViewLayout()
        setupUserImageLayout()
        setupNameDistanceStackViewLayout()
    }
    
    private func setupBackgroundViewLayout() {
        NSLayoutConstraint.activate([backgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
                                     backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                                     backgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
                                     backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)])
    }
    
    private func setupUserImageLayout() {
        NSLayoutConstraint.activate([userImage.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 8),
                                     userImage.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 8),
                                     userImage.rightAnchor.constraint(equalTo: nameDistanceStackView.leftAnchor, constant: -16),
                                     userImage.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -8),
                                     userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor, multiplier: 1)])
    }
    
    private func setupNameDistanceStackViewLayout() {
        NSLayoutConstraint.activate([nameDistanceStackView.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 16),
                                     nameDistanceStackView.topAnchor.constraint(greaterThanOrEqualTo: backgroundView.topAnchor, constant: 8),
                                     nameDistanceStackView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -8),
                                     nameDistanceStackView.bottomAnchor.constraint(greaterThanOrEqualTo: backgroundView.bottomAnchor, constant: -8),
                                     nameDistanceStackView.centerYAnchor.constraint(equalTo: userImage.centerYAnchor)])
    }

}
