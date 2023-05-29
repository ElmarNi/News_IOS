//
//  ContainerViewController.swift
//  News
//
//  Created by Elmar Ibrahimli on 28.05.23.
//

import UIKit

enum MenuState {
    case opened
    case closed
}

class ContainerViewController: UIViewController {

    let homeVC = HomeViewController()
    let menuVC = MenuViewController()
    private var navVc: UINavigationController?
    private var menuState: MenuState = .closed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewControllers()
        view.addGestureRecognizer(createSwipeGesture(for: .left))
        view.addGestureRecognizer(createSwipeGesture(for: .right))
    }
    
    private func addChildViewControllers() {
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        homeVC.delegate = self
        let navVC = UINavigationController(rootViewController: homeVC)
        homeVC.title = "Latest News"
        navVC.navigationBar.prefersLargeTitles = false
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        navVC.navigationBar.tintColor = .label
        self.navVc = navVC
    }
    
    private func createSwipeGesture(for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGesture.direction = direction
        return swipeGesture
    }
    
    private func toggleMenu() {
        switch menuState {
        case .closed:
            openMenu()
        case .opened:
            closeMenu()
        }
    }
    
    private func openMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.navVc?.view.frame.origin.x = UIScreen.main.bounds.width - 100
        } completion: {[weak self] done in
            if done {
                self?.menuState = .opened
            }
        }
    }
    
    private func closeMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.navVc?.view.frame.origin.x = 0
        } completion: {[weak self] done in
            if done {
                self?.menuState = .closed
            }
        }
    }
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            openMenu()
        default:
            closeMenu()
        }
    }

}

extension ContainerViewController: HomeViewControllerDelegate {
    
    func didTapMenuButton() {
        HapticsManager.shared.vibrateForSelection()
        toggleMenu()
    }
    
}

extension ContainerViewController: MenuViewControllerDelegate {
    
    func menuItemDidTapped(menuItem: MenuViewController.MenuOptions) {
        HapticsManager.shared.vibrateForSelection()
        homeVC.title = menuItem.rawValue
        closeMenu()
    }
    
}
