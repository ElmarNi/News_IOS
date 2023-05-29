//
//  HomeViewController.swift
//  News
//
//  Created by Elmar Ibrahimli on 28.05.23.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    private var models = [News]()
    private var nextPage: String? = nil
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapMenuButton))
        
        view.addSubview(tableView)
        view.addSubview(spinner)
        tableView.delegate = self
        tableView.dataSource = self
        getData(nextPage: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        spinner.center = view.center
    }
    
    @objc private func didTapMenuButton() {
        delegate?.didTapMenuButton()
    }
    
    private func getData(nextPage: String?) {
        ApiCaller.shared.getNews(nextPage: nil) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.nextPage = model.nextPage
                    self?.models = model.results
                    self?.tableView.isHidden = false
                    self?.tableView.reloadData()
                    self?.spinner.stopAnimating()
                case .failure(let error):
                    showAlert(title: "Error", message: error.localizedDescription, target: self)
                }
            }
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell
        else{
            return UITableViewCell()
        }
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = models[indexPath.row]
        
        let titleLabelHeight = model.title.getHeightForLabel(font: .systemFont(ofSize: 16, weight: .semibold), width: view.width - 20)
        let descriptionLabelHeight = model.description.getHeightForLabel(font: .systemFont(ofSize: 15, weight: .regular), width: view.width - 20)
        
        return titleLabelHeight + descriptionLabelHeight + 262
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset
        if distanceFromBottom < height {
            spinner.startAnimating()
            getData(nextPage: nextPage)
        }
    }
    
}
