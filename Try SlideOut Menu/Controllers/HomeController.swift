//
//  HomeController.swift
//  Try SlideOut Menu
//
//  Created by SaJesh Shrestha on 8/19/20.
//  Copyright © 2020 SaJesh Shrestha. All rights reserved.
//

import UIKit

class HomeController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .red
        setupNavigationItems()
        setupMenuController()
        setupPanGesture()
    }
    
    let menuController = MenuController()
    
    fileprivate let menuWidth: CGFloat = 300
    fileprivate let velocityThreshold: CGFloat = 800
    fileprivate var isMenuOpened = false
    
    @objc func openMenu() {
        isMenuOpened = true
        performAnimation(transform: CGAffineTransform(translationX: self.menuWidth, y: 0))
    }
    
    @objc func hideMenu() {
        isMenuOpened = false
        performAnimation(transform: .identity)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        print(translation.x)
        if gesture.state == .changed {
            var x = translation.x
            if isMenuOpened {
                x += menuWidth
            }
            
            x = min(menuWidth, x)
            x = max(0, x)
            
            let transform = CGAffineTransform(translationX: x, y: 0)
            menuController.view.transform = transform
            navigationController?.view.transform = transform
        
        } else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }
    
    func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        print("velocity", velocity.x)
        if isMenuOpened {
            if abs(velocity.x) > velocityThreshold {
                hideMenu()
                return
            }
            
            if abs(translation.x) < menuWidth / 2 {
                openMenu()
            } else {
                hideMenu()
            }
        } else {
            if velocity.x > velocityThreshold {
                openMenu()
                return
            }
            
            if translation.x < menuWidth / 2 {
                hideMenu()
            } else {
                openMenu()
            }
        }
    }
    
    //MARK:- Fileprivate
    
    fileprivate func performAnimation(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.menuController.view.transform = transform
            self.navigationController?.view.transform = transform
        }, completion: nil)
    }
    
    fileprivate func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
    }
    
    fileprivate func setupMenuController() {
        menuController.view.frame = CGRect(x: 0, y: 0, width: -menuWidth, height: self.view.frame.height)
        let mainWindow = UIApplication.shared.keyWindow
        mainWindow?.addSubview(menuController.view)
        addChild(menuController)
    }
    
    fileprivate func setupNavigationItems() {
        title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(hideMenu))
    }
    
    //MARK:- TableView Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
        cell.textLabel?.text = "Item \(indexPath.row)"
        return cell
    }
    
}
