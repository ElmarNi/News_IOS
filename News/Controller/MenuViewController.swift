//
//  MenuViewController.swift
//  News
//
//  Created by Elmar Ibrahimli on 28.05.23.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func menuItemDidTapped(menuItem: MenuViewController.MenuOptions)
}

class MenuViewController: UIViewController {

    weak var delegate: MenuViewControllerDelegate?
    enum MenuOptions: String, CaseIterable {
        case latest = "Latest News"
        case food = "Food"
        case health = "Health"
        case science = "Science"
        case sports = "Sports"
        case tourism = "Tourism"
        case world = "World"
        
        var imageName: String {
            switch self {
            case .latest:
                return "newspaper.fill"
            case .food:
                return "fork.knife.circle.fill"
            case .health:
                return "heart.square.fill"
            case .science:
                return "atom"
            case .sports:
                return "soccerball"
            case .tourism:
                return "mountain.2.fill"
            case .world:
                return "globe"
            }
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    private let bgColor = UIColor(red: 0.2, green: 0.2039, blue: 0.2863, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = bgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = nil
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.color = .white
        content.text = MenuOptions.allCases[indexPath.row].rawValue
        content.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName)
        content.imageProperties.tintColor = .white
        cell.contentConfiguration = content
        cell.backgroundColor = bgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.menuItemDidTapped(menuItem: MenuOptions.allCases[indexPath.row])
    }
    
}
