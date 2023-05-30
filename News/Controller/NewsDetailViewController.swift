//
//  NewsDetailViewController.swift
//  News
//
//  Created by Elmar Ibrahimli on 30.05.23.
//

import UIKit

class NewsDetailViewController: UIViewController {

    private var news: News
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
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
    
    private let contentTextLabel: UILabel = {
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
    
    init(news: News) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = news.title
        view.addSubview(scrollView)
        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(creatorNameLabel)
        scrollView.addSubview(pubDateLabel)
        scrollView.addSubview(contentTextLabel)
        scrollView.addSubview(coverImageView)
        coverImageView.addSubview(spinner)
        
        titleLabel.text = news.title
        creatorNameLabel.text = news.creator?.first ?? ""
        pubDateLabel.text = news.pubDate.components(separatedBy: " ")[0]
        contentTextLabel.text = news.content ?? ""
        coverImageView.sd_setImage(with: URL(string: news.image_url ?? ""), placeholderImage: UIImage(systemName: "photo")) {[weak self] _,_,_,_  in
            self?.spinner.stopAnimating()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                            style: .done, target: self, action: #selector(didShareTapped))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let contentTextLabelHeigt = contentTextLabel.text?.getHeightForLabel(font: .systemFont(ofSize: 15, weight: .regular), width: view.width - 20)
        let titleTextLabelHeigt = titleLabel.text?.getHeightForLabel(font: .systemFont(ofSize: 16, weight: .semibold), width: view.width - 20)
        
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.width, height: (contentTextLabelHeigt ?? 0) + 265 + (titleTextLabelHeigt ?? 0))
        
        coverImageView.frame = CGRect(x: 10, y: 10, width: view.width - 20, height: 200)
        spinner.frame = CGRect(x: coverImageView.width / 2, y: coverImageView.height / 2, width: 0, height: 0)
        titleLabel.frame = CGRect(x: 10, y: coverImageView.bottom + 10, width: view.width - 20, height: titleTextLabelHeigt ?? 0)
        creatorNameLabel.frame = CGRect(x: 10, y: titleLabel.bottom + 5, width: (view.width / 2) - 15, height: 17)
        pubDateLabel.frame = CGRect(x: (view.width / 2) + 5, y: titleLabel.bottom + 5, width: (view.width / 2) - 15, height: 17)
        contentTextLabel.frame = CGRect(x: 10, y: pubDateLabel.bottom + 10, width: view.width - 20, height: contentTextLabelHeigt ?? 0)
    }

    @objc private func didShareTapped() {
        guard let url = URL(string: news.link ?? "") else { return }
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: [])
        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityController, animated: true)
    }
    
}
