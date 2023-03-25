//
//  UserListViewController.swift
//  ObserverVR
//  https://youtu.be/gwGRLpPMt2o
//  Created by Uri on 25/3/23.
//

import UIKit
import Combine

class UserListViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    var loadingIndicator: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.color = .white
        loading.translatesAutoresizingMaskIntoConstraints = false
        return loading
    }()

    var viewModel = UserViewModel()
    var anyCancellable = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptions()
        configureTableView()
        viewModel.getUsers()
    }
    
    func subscriptions(){
        viewModel.reloadData.sink { _ in } receiveValue: { _ in
            self.tableView.reloadData()
        }.store(in: &anyCancellable)
        
        viewModel.$isLoading.sink {[weak self] status in
            guard let status = status else { return }
            self?.configureLoadingIndicator(status: status)
        }.store(in: &anyCancellable)
    }
    
    private func configureTableView(){
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
    }
    
    func configureLoadingIndicator(status: Bool) {
        if status {
            loadingIndicator.startAnimating()
            tableView.addSubview(loadingIndicator)
            NSLayoutConstraint.activate([
                loadingIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            ])
            return
        }
        loadingIndicator.removeFromSuperview()
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = viewModel.userList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = user.name + "" + user.lastName
        return cell
    }
    
    
}
