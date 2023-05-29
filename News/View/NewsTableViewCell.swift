//
//  NewsTableViewCell.swift
//  News
//
//  Created by Elmar Ibrahimli on 29.05.23.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let pubDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(coverImageView)
        coverImageView.addSubview(spinner)
        addSubview(titleLabel)
        addSubview(creatorNameLabel)
        addSubview(pubDateLabel)
        addSubview(descriptionLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        coverImageView.frame = CGRect(x: 10, y: 10, width: contentView.width - 20, height: 200)
        spinner.frame = CGRect(x: coverImageView.width / 2, y: coverImageView.height / 2, width: 0, height: 0)
        titleLabel.frame = CGRect(x: 10, y: coverImageView.bottom + 10, width: contentView.width - 20, height: titleLabel.height)
        creatorNameLabel.frame = CGRect(x: 10, y: titleLabel.bottom + 5, width: (contentView.width / 2) - 15, height: 17)
        pubDateLabel.frame = CGRect(x: (contentView.width / 2) + 5, y: titleLabel.bottom + 5, width: (contentView.width / 2) - 15, height: 17)
        descriptionLabel.frame = CGRect(x: 10, y: pubDateLabel.bottom + 10, width: contentView.width - 20, height: descriptionLabel.height)
    }
    
    public func configure(with model: News) {
        titleLabel.text = model.title
        creatorNameLabel.text = model.creator?.first ?? ""
        pubDateLabel.text = model.pubDate.components(separatedBy: " ")[0]
        descriptionLabel.text = model.description
        coverImageView.sd_setImage(with: URL(string: model.image_url ?? "")) {[weak self] _,_,_,_  in
            self?.spinner.stopAnimating()
        }
    }
}
