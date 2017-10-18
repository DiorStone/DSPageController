//
//  PageContentViewController.swift
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

import Foundation
import UIKit

public protocol PageContentViewDataSource: class {
    
    func numberOfViewController(_ viewController: PageContentViewController) -> Int
    func contentViewController(_ viewController: PageContentViewController, viewControllerAt index: Int) -> UIViewController
}

public protocol PageContentViewDelegate: class {
    func contentViewController(_ viewController: PageContentViewController, percent: CGFloat)
}


/// Page容器
///
///[参考链接](https://github.com/kazuhiro4949/PagingKit/blob/master/PagingKit/PagingContentViewController.swift)
open class PageContentViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: Config
    public weak var dataSource: PageContentViewDataSource?
    public weak var delegate: PageContentViewDelegate?
    
    /// 当前选中页
    public fileprivate(set) var currentPageIndex: Int = 0
    
    fileprivate var cachedViewControllers = [UIViewController?]()
    fileprivate var numberOfPages: Int = 0
    fileprivate var isExplicityScrolling = false
    
    //MARK: UI
    public let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        //add scrollview
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.frame = self.view.bounds
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        self.view.backgroundColor = .clear
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // setup scrollview
        scrollView.contentSize = CGSize(
            width: scrollView.bounds.width * CGFloat(numberOfPages),
            height: scrollView.bounds.height)
        scrollView.contentOffset = CGPoint(x: scrollView.bounds.width * CGFloat(currentPageIndex), y: 0)
        cachedViewControllers.enumerated().forEach {(offset, viewController) in
            viewController?.view.frame = scrollView.bounds
            viewController?.view.frame.origin.x = scrollView.bounds.width * CGFloat(offset)
        }
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //for rotate
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            guard let weakSelf = self else { return }
            weakSelf.scroll(to: weakSelf.currentPageIndex, animated: false)
            }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    //MARK: Public
    
    /// 重新加载page容器
    ///
    /// - Parameter page: 指定页码(会自动滚动到该页)
    public func reloadData(with page: Int = 0) {
        removeAll()
        numberOfPages = dataSource?.numberOfViewController(self) ?? 0
        UIView.animate(
            withDuration: 0,
            animations: { [weak self] in
                self?.view.setNeedsLayout()
                self?.view.layoutIfNeeded()
            },
            completion: { [weak self] (finish) in
                self?.initialLoad(with: page)
                self?.scroll(to: page, animated: false)
        })
    }
    
    /// 滚动到指定页
    ///
    /// - Parameters:
    ///   - page: 指定页码
    ///   - animated: 是否有动画
    public func scroll(to page: Int, animated: Bool) {
        let offsetX = scrollView.bounds.width * CGFloat(page)
        loadPagesIfNeeded(page: page)
        currentPageIndex = page
        if animated {
            UIView.perform(
                .delete,
                on: [],
                options: UIViewAnimationOptions(rawValue: 0),
                animations: { [weak self] in
                    self?.scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
                }, completion: nil)
        } else {
            scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
        }
    }
    
    //MARK: Private
    fileprivate func initialLoad(with page: Int) {
        cachedViewControllers = Array(repeating: nil, count: numberOfPages)
        loadScrollView(with: page - 1)
        loadScrollView(with: page)
        loadScrollView(with: page + 1)
    }
    
    fileprivate func loadPagesIfNeeded(page: Int? = nil) {
        let loadingPage = page ?? currentPageIndex
        loadScrollView(with: loadingPage - 1)
        loadScrollView(with: loadingPage)
        loadScrollView(with: loadingPage + 1)
    }
    
    fileprivate func loadScrollView(with page: Int) {
        guard (0..<cachedViewControllers.count).contains(page) else { return }
        
        if cachedViewControllers[page] == nil, let dataSource = dataSource {
            let viewController = dataSource.contentViewController(self, viewControllerAt: page)
            viewController.willMove(toParentViewController: self)
            addChildViewController(viewController)
            viewController.view.frame = self.scrollView.bounds
            viewController.view.frame.origin.x = scrollView.bounds.width * CGFloat(page)
            scrollView.addSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
            cachedViewControllers[page] = viewController
        }
        
    }
    
    fileprivate func removeAll() {
        childViewControllers.forEach {
            $0.willMove(toParentViewController: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParentViewController()
            $0.didMove(toParentViewController: nil)
        }
    }
    
    //MARK: UIScrollViewDelegate
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isExplicityScrolling = true
        currentPageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isExplicityScrolling {
            currentPageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            let contentOffset = CGFloat(currentPageIndex) * scrollView.bounds.width
            var percent = (scrollView.contentOffset.x - contentOffset) / scrollView.bounds.width
            percent = min(max(0, percent), 1)
            delegate?.contentViewController(self, percent: percent)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isExplicityScrolling {
            currentPageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        }
        isExplicityScrolling = false
        loadPagesIfNeeded()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        if isExplicityScrolling {
            currentPageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        }
        isExplicityScrolling = false
        loadPagesIfNeeded()
    }
}

