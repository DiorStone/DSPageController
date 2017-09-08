//
//  PageViewController.swift
//  DSPageController
//
//  Created by DaiLingchi on 2017/9/7.
//  Copyright © 2017年 DiorStone. All rights reserved.
//

import UIKit

@objc public protocol PageViewControllerDataSource: NSObjectProtocol {
    
    @objc optional func numberOfViewControllers(_ pageViewController: PageViewController) -> Int
    @objc optional func pageViewController(_ pageViewController: PageViewController, viewControllerAtIndex index: Int) -> UIViewController
    @objc optional func frameForMenuView(_ pageViewController: PageViewController) -> CGRect
    @objc optional func frameForContentView(_ pageViewController: PageViewController) -> CGRect
}

public protocol PageViewControllerDelegate {
    
}

open class PageViewController: UIViewController {

    public var selectedIndex: Int = 0
    public var dataSource: PageViewControllerDataSource?

    // MARK: Life Cycle
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(viewControllers: [UIViewController]) {
        self.init()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        p_calculateSize()
        p_setupScrollView()
    }
    
    // for auto resize
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //计算子控件的frame
    }
    
    // MARK: Private
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = UIColor.white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    
    var pageConfiger: (
        menuViewFrame: CGRect,
        contentViewFrame: CGRect,
        childViewFrames: [CGRect]
        ) = (CGRect.zero, CGRect.zero, [])
    
    var configer: (
        childControllersCount: Int?,
        frame: (
            menuViewFrame: CGRect,
            contentViewFrame: CGRect,
            childViewFrames: [CGRect]
            )
        ) = (nil , (CGRect.zero, CGRect.zero,[]))
}

extension PageViewController {
    
    var childControllersCount: Int {
        if let count = configer.childControllersCount {
            return count
        }
        if let dataSource = self.dataSource, dataSource.responds(to: #selector(PageViewControllerDataSource.numberOfViewControllers(_:))) {
            configer.childControllersCount = dataSource.numberOfViewControllers!(self)
        } else {
            configer.childControllersCount = 0
        }
        return configer.childControllersCount!
    }
    
    
    func refreshLayout() {
        
        p_calculateSize()
        p_adjustMenuViewFrame()
        p_adjustContentViewFrame()
    }
    
    func p_calculateSize() {

        if let dataSource = self.dataSource, dataSource.responds(to: #selector(PageViewControllerDataSource.frameForMenuView(_:))) {
           self.pageConfiger.menuViewFrame = dataSource.frameForMenuView!(self)
        } else {
            self.pageConfiger.menuViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30.0)
        }
        
        if let dataSource = self.dataSource, dataSource.responds(to: #selector(PageViewControllerDataSource.frameForContentView(_:))) {
            self.pageConfiger.contentViewFrame = dataSource.frameForContentView!(self)
        } else {
            let originY = self.pageConfiger.menuViewFrame.maxY
            var contentHeight = self.view.frame.height - originY
            if let tabBar = self.tabBarController?.tabBar, !tabBar.isHidden {
                contentHeight -= tabBar.frame.height
            }
            self.pageConfiger.contentViewFrame  = CGRect(x: 0, y: originY, width: self.view.frame.width, height: contentHeight)
        }
        
        self.pageConfiger.childViewFrames.removeAll()
        for i in 0..<self.childControllersCount {
            let frame = CGRect(x: CGFloat(i) * self.pageConfiger.contentViewFrame.width, y: 0, width: self.pageConfiger.contentViewFrame.width, height: self.pageConfiger.contentViewFrame.height)
            self.pageConfiger.childViewFrames.append(frame)
        }
    }
    
    func p_adjustMenuViewFrame() {
        
    }
    
    func p_adjustContentViewFrame() {
        
    }
    
    func p_setupScrollView() {
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
    }
    
    func p_setupChildViewController() {
        
        if let dataSource = self.dataSource, dataSource.responds(to: #selector(PageViewControllerDataSource.pageViewController(_:viewControllerAtIndex:))) {
            let childViewController = dataSource.pageViewController!(self, viewControllerAtIndex: selectedIndex)
            self.addChildViewController(childViewController)
        }
    }
}

extension PageViewController: UIScrollViewDelegate {}

