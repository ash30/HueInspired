//
//  ActionContainer.swift
//  HueInspired
//
//  Created by Ashley Arthur on 17/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import UIKit

class ActionContainer: UIViewController, ErrorHandler {

    typealias Action = (ActionContainer) -> ()
    
    // MARK: PUBLIC
    
    var action: Action? {
        didSet{
            updateDisplay()
        }
    }
    var actionButtonText: String = "" {
        didSet{
            updateDisplay()

        }
    }
    
    var actionButtonIcon: UIImage? = nil {
        didSet{
            updateDisplay()
            
        }
    }
    
    // MARK: PRIVATE
    
    private lazy var actionButton: UIButton! = {
        let customButton = TabbarMenuButton()
        customButton.setTitle(self.actionButtonText, for: .normal)

        customButton.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        self.view.addSubview(customButton)
        customButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            customButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            customButton.centerYAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant:-60),
            customButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            customButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(constraints)
        return customButton
    }()
    
    private lazy var containerView: UIView! = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        NSLayoutConstraint.activate( [
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        return view
    }()
    
    // MARK: LIFE CYLCE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let childVC = childViewControllers.first {
            layoutChildViewController(childVC)
        }
        else {
            _ = containerView // force load anyways for view ordering
        }
        
        actionButton.addTarget(self, action: #selector(callAction), for: .touchUpInside)
        updateDisplay()

    }

    // MARK: CONTAINMENT
    private func layoutChildViewController(_ childController: UIViewController){
    
        childController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(childController.view)

        NSLayoutConstraint.activate( [
            containerView.leadingAnchor.constraint(equalTo: childController.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: childController.view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: childController.view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: childController.view.bottomAnchor)
            ])
    
    }
    
    override func addChildViewController(_ childController: UIViewController) {
        super.addChildViewController(childController)
        childController.didMove(toParentViewController: self)

        if let _ = viewIfLoaded {
            layoutChildViewController(childController)
        }

        navigationItem.titleView = childController.navigationItem.titleView
    }
    
    // MARK: TARGET ACTION
    
    @objc func callAction(){
        action?(self)
    }
    
    // MARK: DISPLAY
    private func updateDisplay(){
        guard let _ = viewIfLoaded else {
            return
        }
        actionButton.isHidden = (action == nil)
        actionButton.setTitle(actionButtonText, for: .normal)
        actionButton.setImage(actionButtonIcon, for: .normal)
    }
    

}
