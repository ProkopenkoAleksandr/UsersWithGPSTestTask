//
//  UpdatingView.swift
//  e-legionTestTask
//
//  Created by Aleksandr Prokopenko on 15.03.2023.
//

import UIKit

class UpdatingView: UIView {
    
    private var backView: UIView = {
        var view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        var activity = UIActivityIndicatorView()
        activity.color = .orange
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    private var text: UILabel = {
        var label = UILabel()
        label.text = "Загрузка"
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
        updatingViewIsHidden(bool: true)
    }
    
    private func setupView() {
        addSubview(backView)
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(text)
        backView.addSubview(stackView)
    }
    
    private func setupLayout() {
        setupBackgroundViewLayout()
        setupStackViewLayout()
    }
    
    private func setupBackgroundViewLayout() {
        NSLayoutConstraint.activate([backView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
                                     backView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                                     backView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
                                     backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)])
    }
    
    private func setupStackViewLayout() {
        NSLayoutConstraint.activate([stackView.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 16),
                                     stackView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8),
                                     stackView.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -16),
                                     stackView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -8)])
    }
    
    func updatingViewIsHidden(bool: Bool) {
        isHidden = bool
        if bool == true {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }

}
