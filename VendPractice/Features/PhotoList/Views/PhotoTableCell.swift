//
//  PhotoTableCell.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import UIKit
import SnapKit

class PhotoTableCell: UITableViewCell {
    
    // MARK:- Contants
    
    let spacing: CGFloat = 8
    let imageSize: CGSize = CGSize(width: 300, height: 200)
    let textFont = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    
    // MARK:- UI Elements
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = textFont
        label.numberOfLines = 0
        return label
    }()
    
    lazy var photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var detailView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [photoImageView, authorLabel])
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK:- Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        photoImageView.image = nil
    }
    
    private func setupUI() {
        contentView.addSubview(detailView)
        buildConstraints()
    }
    
    private func buildConstraints(){
        detailView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(spacing)
            make.trailing.bottom.equalToSuperview().inset(spacing)
        }
        photoImageView.snp.makeConstraints { make in
            make.height.equalTo(imageSize.height)
            make.width.equalTo(imageSize.width)
        }
    }
}
