//
//  OnBoardingPageViewController.swift
//  HueInspired
//
//  Created by Ashley Arthur on 17/07/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation
import UIKit

class OnBoardingPageViewController: UIPageViewController {
    
    // MARK: PUBLIC 
    var contentViewControllers: [UIViewController] = [] {
        didSet{
            guard let _ = viewIfLoaded else {
                return
            }
            
            if let vc = contentViewControllers.first {
                setViewControllers([vc], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let vc = contentViewControllers.first {
            setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: HELPERS
    
    
}

extension OnBoardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard
            let currentIndex = contentViewControllers.index(of:viewController),
            currentIndex > 0
        else {
            return nil
        }
        return contentViewControllers[currentIndex-1]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard
            let currentIndex = contentViewControllers.index(of:viewController),
            currentIndex + 1 < contentViewControllers.count
            else {
                return nil
        }
        return contentViewControllers[currentIndex+1]
    
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return contentViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard
            let vc = viewControllers?.first,
            let index = contentViewControllers.index(of:vc)
        else {
                return 0
        }
        return index 
    }
    
    
}
