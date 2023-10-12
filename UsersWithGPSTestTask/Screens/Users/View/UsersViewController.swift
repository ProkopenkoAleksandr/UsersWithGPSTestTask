//
//  UsersViewController.swift
//  e-legionTestTask
//
//  Created by Aleksandr Prokopenko on 10.03.2023.
//

import UIKit

class UsersViewController: UIViewController {
    
    private var viewModel: UsersViewModel!
    
    private var tableView: UITableView = {
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var tableViewDataSource: UITableViewDiffableDataSource<ViewControllerSection, UserViewViewModel> = {
        let dataSource = UITableViewDiffableDataSource<ViewControllerSection, UserViewViewModel>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserTableViewCell else { fatalError("Error register cell") }
            cell.userViewViewModel = self.viewModel.getUserViewViewModel(index: indexPath.row)
            return cell
        }
        return dataSource
    }()
    
    enum ViewControllerSection: Hashable {
        case main
    }
        
    private var pinnedUserView: UserView = {
        var view = UserView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        return view
    }()
    
    private var updatingView: UpdatingView = {
        var view = UpdatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var errorView: ErrorView = {
        var view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(viewModel: UsersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
        let tap = UITapGestureRecognizer(target: self, action: #selector(removePinnedUserView))
        pinnedUserView.addGestureRecognizer(tap)
    }
    
    
    private func initView() {
        setupView()
        setupTableView()
        setupLayout()
    }
    
    private func initViewModel() {
        viewModel.updatePinnedUser = { [weak self] pinnedUserViewViewModel in
            self?.pinnedUserView.userViewViewModel = pinnedUserViewViewModel
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.updatingViewIsHidden = { [weak self] bool in
            self?.updatingView.updatingViewIsHidden(bool: bool)
        }
        
        viewModel.errorIsHidden = { [weak self] bool in
            self?.errorView.errorViewIsHidden(bool: bool)
        }
        
        viewModel.applySnapshot = { [weak self] array in
            var snapshot = NSDiffableDataSourceSnapshot<ViewControllerSection, UserViewViewModel>()
            snapshot.appendSections([.main])
            snapshot.appendItems(array)
            self?.tableViewDataSource.apply(snapshot, animatingDifferences: false)
        }
        
        viewModel.getCurrentLocation()
    }
    
    @objc func removePinnedUserView() {
        viewModel.deletePinnedUser()
        pinnedUserView.userViewViewModel = nil
        viewModel.updateSnapshot()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.addSubview(updatingView)
        view.addSubview(errorView)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell")
    }
    
    private func setupLayout() {
        setupTableViewLayout()
        setupUpdatingViewLayout()
        setupErrorViewLayout()
    }
    
    private func setupTableViewLayout() {
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                                     tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
                                     tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                                     tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0)])
    }
    
    private func setupUpdatingViewLayout() {
        NSLayoutConstraint.activate([updatingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     updatingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     updatingView.widthAnchor.constraint(equalToConstant: 175),
                                     updatingView.heightAnchor.constraint(equalToConstant: 75)])
    }
    
    private func setupErrorViewLayout() {
        NSLayoutConstraint.activate([errorView.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 16),
                                     errorView.rightAnchor.constraint(greaterThanOrEqualTo: view.rightAnchor, constant: -16),
                                     errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }

}

extension UsersViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return pinnedUserView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if pinnedUserView.userViewViewModel == nil {
            return 0
        } else {
            return 100
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pinnedUserView.userViewViewModel = viewModel.getUserAndPin(index: indexPath.row)
        viewModel.updateSnapshot()
    }

}
