//
//  ErrorView.swift
//  e-legionTestTask
//
//  Created by Aleksandr Prokopenko on 15.03.2023.
//

import UIKit

class ErrorView: UIView {
    
    private var backView: UIView = {
        var view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var errorMessage: UILabel = {
        var label = UILabel()
        label.text = "Доступ к геопозиции запрещен. Работа приложения невозможна\n\nПерейдите, пожалуйста, в настройки и разрешите доступ к геопозиции"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var button: UIButton = {
        var button = UIButton()
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.setTitle("Разрешить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(openSetting), for: .touchUpInside)
        return button
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        isHidden = true
    }
    
    private func setupView() {
        addSubview(backView)
        backView.addSubview(errorMessage)
        backView.addSubview(button)
    }
    
    private func setupLayout() {
        setupBackgroundViewLayout()
        setupErrorMessageLayout()
        setupButtonLayout()
    }
    
    private func setupBackgroundViewLayout() {
        NSLayoutConstraint.activate([backView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
                                     backView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                                     backView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
                                     backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)])
    }
    
    private func setupErrorMessageLayout() {
        NSLayoutConstraint.activate([errorMessage.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 16),
                                     errorMessage.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8),
                                     errorMessage.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -16),
                                     errorMessage.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16)])
    }
    
    private func setupButtonLayout() {
        NSLayoutConstraint.activate([
                                     button.topAnchor.constraint(equalTo: errorMessage.bottomAnchor, constant: 16),
                                     button.bottomAnchor.constraint(greaterThanOrEqualTo: backView.bottomAnchor, constant: -8),
                                     button.widthAnchor.constraint(equalToConstant: 200),
                                     button.centerXAnchor.constraint(equalTo: backView.centerXAnchor)])
    }
    
    @objc private func openSetting() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
    
    func errorViewIsHidden(bool: Bool) {
        self.isHidden = bool
    }

}
