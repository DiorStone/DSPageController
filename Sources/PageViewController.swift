//
//  PageViewController.swift
//
//  The MIT License (MIT)
//  Copyright © 2017 DiorStone

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

public protocol PageViewDataSource: PageContentViewDataSource {
    
    func frameForMenuView(_ viewController: PageViewController) -> CGRect
    func frameForContentView(_ viewController: PageViewController) -> CGRect
}

public protocol PageViewDelegate: PageContentViewDelegate {
    
}

public protocol PageableMenuView {
    
    func scroll(index: Int, percent: CGFloat, animated: Bool)
}

/// PageViewController
///
/// 参考链接
/// * [WMPageController](https://github.com/wangmchn/WMPageController-Swift/blob/master/PageController/PageController.swift)
open class PageViewController: PageContentViewController, PageViewDataSource, PageViewDelegate {
  
    var menuFrame: CGRect?
    var contentFrame: CGRect?
    var viewControllers: [UIViewController.Type] = []
    
    var menuView: (UIView & PageableMenuView)?
    
    public convenience init(viewControllers: [UIViewController.Type]) {
        self.init()
        self.viewControllers = viewControllers
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        self.reloadData()
    }
    
    open override func viewDidLayoutSubviews() {
        
        calculateSize()
        adjustMenuViewFrame()
        adjustScrollViewFrame()
        
        super.viewDidLayoutSubviews()
    }
    
    //MARK: private
    fileprivate func calculateSize() {
        self.menuFrame = (self.dataSource as? PageViewDataSource)?.frameForMenuView(self)
        self.contentFrame = (self.dataSource as? PageViewDataSource)?.frameForContentView(self)
    }
    
    fileprivate func adjustMenuViewFrame() {
        self.menuView?.frame = self.menuFrame ?? CGRect.zero
    }
    
    fileprivate func adjustScrollViewFrame() {
        self.scrollView.frame = contentFrame ?? self.scrollView.frame
    }
    
    
    //MARK: PageViewDataSource
    open func frameForMenuView(_ viewController: PageViewController) -> CGRect {
        return CGRect.zero
    }
    
    open func frameForContentView(_ viewController: PageViewController) -> CGRect {
        return self.view.bounds
    }
    
    open func numberOfViewController(_ viewController: PageContentViewController) -> Int {
        return viewControllers.count
    }
    
    open func contentViewController(_ viewController: PageContentViewController, viewControllerAt index: Int) -> UIViewController {
        return viewControllers[index].init()
    }
    
    //MARK: PageViewDelegate
}
