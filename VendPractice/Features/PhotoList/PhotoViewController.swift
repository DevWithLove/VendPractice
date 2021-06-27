//
//  ViewController.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import UIKit
import PINRemoteImage

class PhotoViewController: UIViewController {
    
    // MARK: Constants
    
    private let buttonHeight: CGFloat = 30
    private let margin: CGFloat = 10
    
    // MARK: Variables
    
    var viewModel: PhotoListViewModelProtocol!
    
    // MARK: Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
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
        viewModel.delegate = self
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
            make.top.equalTo(tableView.snp.bottom).offset(margin)
            make.height.equalTo(buttonHeight)
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().inset(margin)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(margin)
        }
        activityIndiatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func loadData() {
        activityIndiatorView.startAnimating()
        navigationItem.rightBarButtonItem?.isEnabled = false
        viewModel.loadPhoto()
    }
    
    @objc
    private func buttonTapped() {
        viewModel.addRandomPhoto()
        UIView.animate(withDuration: 0) { [weak self] in
            self?.tableView.reloadData()
        } completion: { [weak self] _ in
            self?.tableView.scrollToLastRow()
        }
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

extension PhotoViewController: PhotoViewModelDelegate {
    func displayError(_ error: PhotoListError) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.presentMessage(message: error.localizedMessage)
        }
    }
    
    func didLoadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.activityIndiatorView.stopAnimating()
            self.tableView.reloadData()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}

extension PhotoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableCell.cellId, for: indexPath) as! PhotoTableCell
        let photo = getPhoto(at: indexPath)
        cell.configureWithModel(photo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let photo = getPhoto(at: indexPath)
            viewModel.delete(photo: photo)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourcePhoto = getPhoto(at: sourceIndexPath)
        let destinationPhoto = getPhoto(at: destinationIndexPath)
        viewModel.swap(sourcePhoto: sourcePhoto, destinationPhoto: destinationPhoto)
    }
    
    private func getPhoto(at indexPath: IndexPath) -> Photo {
        return viewModel.photos[indexPath.row]
    }
}

extension PhotoTableCell: Configurable {
    func configureWithModel(_ photo: Photo) {
        photoImageView.image = nil
        if let url = URL(string: photo.downloadUrl) {
            photoImageView.pin_setImage(from: url)
        }
        authorLabel.text = photo.author
    }
}


