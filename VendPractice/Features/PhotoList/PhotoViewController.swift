//
//  ViewController.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import UIKit
import PINRemoteImage

class PhotoViewController: UIViewController {
    
    // MARK: Variables
    
    // MARK: Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(cellClass: PhotoTableCell.self)
        return tableView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizableString.buttonAdd, for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndiatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .black
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var editBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: LocalizableString.buttonEdit,
                                     style: .done,
                                     target: self,
                                     action: #selector(editTapped))
        return button
    }()
    
    private lazy var reloadBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: LocalizableString.buttonReload,
                                     style: .done,
                                     target: self,
                                     action: #selector(reloadTapped))
        return button
    }()
    
    // MARK: iOS life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    // MARK: Helpers
    
    private func setupUI() {
        title = LocalizableString.photoListTitle
        navigationItem.leftBarButtonItem = editBarButtonItem
        navigationItem.rightBarButtonItem = reloadBarButtonItem
        view.addSubview(tableView)
        view.addSubview(button)
        view.addSubview(activityIndiatorView)
        buildConstraints()
    }
    
    private func buildConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.height.equalTo(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        activityIndiatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func loadData() {
        activityIndiatorView.startAnimating()
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc
    private func buttonTapped() {
    }
    
    @objc
    private func editTapped() {
        tableView.isEditing = !tableView.isEditing
    }
    
    @objc
    private func reloadTapped() {
       loadData()
    }
}
