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
            guard let _ = viewIfLoaded else {
                return
            }
            actionButton.setTitle(actionButtonText, for: .normal)
        }
    }
    
    // MARK: PRIVATE
    
    private lazy var actionButton: UIButton! = {
        let customButton = TabbarMenuButton()
        customButton.setTitle(self.actionButtonText, for: .normal)

        // customButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
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
        view.autoresizingMask = [ .flexibleHeight, .flexibleWidth]
        return view
    }()
    
    // MARK: LIFE CYLCE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This needs to happen before the action button
        // inorder to not block events
        self.view.addSubview(containerView)
        
        actionButton.addTarget(self, action: #selector(callAction), for: .touchUpInside)
        updateDisplay()

    }

    // MARK: CONTAINMENT
    
    override func addChildViewController(_ childController: UIViewController) {
        super.addChildViewController(childController)
        // TODO: We're only allowed child view controller, remove existing before adding new
        containerView.addSubview(childController.view)
        childController.view.autoresizingMask = [ .flexibleHeight, .flexibleWidth]
        childController.didMove(toParentViewController: self)
    }
    
    // MARK: TARGET ACTION
    
    @objc func callAction(){
        action?(self)
    }
    
    // MARK: DISPLAY
    private func updateDisplay(){
        actionButton.isHidden = (action == nil)
    }
    

}
