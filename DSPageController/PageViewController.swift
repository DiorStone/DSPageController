//
//  PageViewController.swift
//  DSPageController
//
//  Created by DaiLingchi on 2017/9/7.
//  Copyright © 2017年 DiorStone. All rights reserved.
//

import UIKit

//@objc public protocol PageViewControllerDataSource: class {
//
//    @objc optional func numberOfViewControllers(_ viewController: PageViewController) -> Int
//    @objc optional func pageViewController(_ viewController: PageViewController, viewControllerAtIndex index: Int) -> UIViewController
//    @objc optional func frameForMenuView(_ viewController: PageViewController) -> CGRect
//    @objc optional func frameForContentView(_ viewController: PageViewController) -> CGRect
//}
//
//
//open class PageViewController: UIViewController,PageContentViewControllerDataSource, PageViewControllerDataSource {
//
//    public weak var dataSource: PageViewControllerDataSource?
//
//    fileprivate var contentViewController: PageContentViewController = PageContentViewController()
//
//    public convenience init(_ viewControllers: [UIViewController.Type]) {
//        self.init()
//    }
//
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.dataSource = self
//        contentViewController.dataSource = self
//
//        contentViewController.willMove(toParentViewController: self)
//        addChildViewController(contentViewController)
//        contentViewController.view.frame = self.view.bounds
//        self.view.addSubview(contentViewController.view)
//        contentViewController.didMove(toParentViewController: self)
//
//        contentViewController.reloadData()
//    }
//
//    open override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//    }
//
//    //MARK: PageContentViewControllerDataSource
//    public func numberOfViewController(_ viewController: PageContentViewController) -> Int {
//        return self.dataSource?.numberOfViewControllers?(self) ?? 0
//    }
//
//    public func contentViewController(_ viewController: PageContentViewController, viewControllerAt index: Int) -> UIViewController {
//        return (self.dataSource?.pageViewController?(self, viewControllerAtIndex: index))!
//    }
//}

//open class PageViewController: UIViewController {
//
//    // UI
//    var scrollView: UIScrollView!
//
//    var selectedIndex: Int = 0
//    weak var dataSource: PageViewControllerDataSource?
//
//    var viewControllers: [UIViewController] = []
//
//    open fileprivate(set) var selectedViewController: UIViewController?
//    //配置信息
//    fileprivate var configer: (
//        menuViewFrame: CGRect,
//        contentViewFrame: CGRect,
//        childViewFrames: [CGRect]
//        ) = (CGRect.zero, CGRect.zero, [])
//    fileprivate var childControllersCount: Int = 0
//    lazy fileprivate var displayingControllers: [Int : UIViewController] = [:]
//
//    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        self.dataSource = self
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.dataSource = self
//    }
//
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = .white
//
//        self.calculateSize()
//        //addScrollView
//        scrollView = UIScrollView(frame: self.view.bounds)
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.isDirectionalLockEnabled = true
//        scrollView.bounces = false
//        scrollView.backgroundColor = .clear
//        scrollView.clipsToBounds = true
//        scrollView.isPagingEnabled = true
//        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.view.addSubview(scrollView)
//
//        addViewController(at: selectedIndex)
//
//        selectedViewController = displayingControllers[self.selectedIndex]
//    }
//
//    open override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        didEnterController(selectedViewController!, at: self.selectedIndex)
//    }
//
//    open override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        self.calculateSize()
//        self.adjustScrollViewFrame()
//
////        if let count = self.dataSource?.numberOfViewControllers?(self) {
////            viewControllers.removeAll()
////            for i in 0...count {
////                if let viewController = self.dataSource?.pageViewController?(self, viewControllerAtIndex: i) {
////                    viewControllers.append(viewController)
////                }
////            }
////        }
//    }
//
//    func setupViewControllerScroll(to index: Int) {
//        guard index < 0, index >= self.viewControllers.count else {
//            return
//        }
//
//
//
//    }
//
//    func layoutControllerView() {
//        self.viewControllers.enumerated().forEach { [unowned self] (idx, childViewController) in
//            let offSet = fabs(self.scrollView.contentOffset.x - CGFloat(idx) * self.scrollView.bounds.width)
//            if(offSet < self.scrollView.bounds.width) {
//                if childViewController.parent == nil {
//                    childViewController.willMove(toParentViewController: self)
//                    self.addChildViewController(childViewController)
//                    self.scrollView.addSubview(childViewController.view)
//                    childViewController.didMove(toParentViewController: self)
//                }
//            } else {
//                if childViewController.parent != nil {
//                    childViewController.willMove(toParentViewController: nil)
//                    childViewController.view.removeFromSuperview()
//                    childViewController.removeFromParentViewController()
//                }
//            }
//        }
//    }
//}
//
//extension PageViewController {
//
//    // MARK: layout
//    fileprivate func calculateSize() {
//        self.childControllersCount = self.dataSource?.numberOfViewControllers?(self) ?? 0
//
//        //for menu
//        if let viewFrame = self.dataSource?.frameForMenuView?(self) {
//            self.configer.menuViewFrame = viewFrame
//        }
//        //for contentview
//        if let viewFrame = self.dataSource?.frameForContentView?(self) {
//            self.configer.contentViewFrame = viewFrame
//        } else {
//            self.configer.contentViewFrame = self.view.bounds
//        }
//        self.configer.childViewFrames.removeAll()
//
//        for index in 0..<self.childControllersCount {
//            let frame = CGRect(x: CGFloat(index) * self.configer.contentViewFrame.width,
//                               y: 0,
//                               width: self.configer.contentViewFrame.width,
//                               height: self.configer.contentViewFrame.height)
//            self.configer.childViewFrames.append(frame)
//        }
//    }
//
//    fileprivate func adjustScrollViewFrame() {
//        self.scrollView.frame = self.configer.contentViewFrame
//        self.scrollView.contentSize = CGSize(width: CGFloat(self.configer.childViewFrames.count) * self.configer.contentViewFrame.width, height: 0)
//        self.scrollView.contentOffset = CGPoint(x: CGFloat(self.selectedIndex) * self.configer.contentViewFrame.width, y: 0)
//    }
//
//    // MARK: viewcontrollers
//
//    fileprivate func didEnterController(_ viewController: UIViewController, at index: Int) {
//        guard childControllersCount > 0 else {
//            return
//        }
//        var start = 0
//        var end = childControllersCount - 1
//        if index < self.selectedIndex {
//            start = index
//            end = self.selectedIndex
//        } else {
//            start = self.selectedIndex + 1
//            end = index
//        }
//
//        for index in start ... end {
//            addViewController(at: index)
//        }
//
//    }
//
//    fileprivate func getViewController(at index: Int) -> UIViewController {
//        if let viewController = self.dataSource?.pageViewController?(self, viewControllerAtIndex: index) {
//            return viewController
//        }
//        return UIViewController()
//    }
//
//    fileprivate func addViewController(at index: Int) {
//        let viewController = self.getViewController(at: self.selectedIndex)
//        if viewController.parent == nil {
//            viewController.willMove(toParentViewController: self)
//            self.addChildViewController(viewController)
//            self.scrollView.addSubview(viewController.view)
//            viewController.view.frame = self.configer.childViewFrames[index]
//            viewController.didMove(toParentViewController: self)
//        }
//        displayingControllers[index] = viewController
//    }
//
//    fileprivate func removeViewController(_ viewController: UIViewController) {
//        viewController.willMove(toParentViewController: nil)
//        viewController.view.removeFromSuperview()
//        viewController.removeFromParentViewController()
//    }
//}
//
//extension PageViewController: PageViewControllerDataSource {
//
//}
//
//extension PageViewController: UIScrollViewDelegate {
//
//    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        self.setupViewControllerScroll(to: self.selectedIndex - 1)
//        self.setupViewControllerScroll(to: self.selectedIndex + 1)
//    }
//
//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.layoutControllerView()
//    }
//}

//open class PageViewController: UIViewController {
//
//    /// 当前选中索引
//    open var selectedIndex: Int = 0 {
//        didSet {
//
//        }
//    }
//    public weak var dataSource: PageViewControllerDataSource?
//
//    // MARK: Private
//    let scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.scrollsToTop = false
//        scrollView.isPagingEnabled = true
//        scrollView.backgroundColor = UIColor.white
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.showsHorizontalScrollIndicator = false
//        return scrollView
//    }()
//
//    fileprivate var numberOfViewControllers: Int = 0
//    fileprivate var viewControllers: [UIViewController] = []
//
//    //配置信息
//    var pageConfiger: (
//        menuViewFrame: CGRect,
//        contentViewFrame: CGRect,
//        childViewFrames: [CGRect]
//        ) = (CGRect.zero, CGRect.zero, [])
//
//    // MARK: Life Cycle
//
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.white
//
//        calculateSize()
//        addScrollView()
//        addViewController(at: selectedIndex)
//    }
//
//    // for auto resize
//    open override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        calculateSize()
//        adjustScrollViewFrame()
//    }
//
//
//
//}
//
//extension PageViewController {
//
//    func setupChildViewController(at index: Int) {
//        if let dataSource = self.dataSource, dataSource.responds(to: #selector(PageViewControllerDataSource.pageViewController(_:viewControllerAtIndex:))) {
//            let childViewController = dataSource.pageViewController!(self, viewControllerAtIndex: index)
//
//            self.addChildViewController(childViewController)
//            childViewController.view.frame = self.pageConfiger.childViewFrames[index]
//            childViewController.didMove(toParentViewController: self)
//            self.scrollView.addSubview(childViewController.view)
//        }
//    }
//
//    func loadContentView() {
//        if let dataSource = self.dataSource, dataSource.responds(to: #selector(PageViewControllerDataSource.pageViewController(_:viewControllerAtIndex:))) {
//            let start = 0
//            let end = numberOfViewControllers - 1
//
//            for i in start ... end {
//
//            }
//        }
//    }
//}
//
////MARK: Private
//extension PageViewController {
//
//    func refreshLayout() {
//
//        calculateSize()
//        adjustMenuViewFrame()
//        adjustScrollViewFrame()
//    }
//
//    /// 计算各部件大小
//    func calculateSize() {
//
//        let count = self.dataSource?.numberOfViewControllers?(self)
//
//        if let dataSource = self.dataSource, dataSource.responds(to: #selector(PageViewControllerDataSource.frameForMenuView(_:))) {
//            self.pageConfiger.menuViewFrame = dataSource.frameForMenuView!(self)
//        } else {
//            self.pageConfiger.menuViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30.0)
//        }
//
//        if let dataSource = self.dataSource, dataSource.responds(to: #selector(PageViewControllerDataSource.frameForContentView(_:))) {
//            self.pageConfiger.contentViewFrame = dataSource.frameForContentView!(self)
//        } else {
//            let originY = self.pageConfiger.menuViewFrame.maxY
//            var contentHeight = self.view.frame.height - originY
//            if let tabBar = self.tabBarController?.tabBar, !tabBar.isHidden {
//                contentHeight -= tabBar.frame.height
//            }
//            self.pageConfiger.contentViewFrame  = CGRect(x: 0, y: originY, width: self.view.frame.width, height: contentHeight)
//        }
//
//        self.pageConfiger.childViewFrames.removeAll()
//        for i in 0..<2 {
//            let frame = CGRect(x: CGFloat(i) * self.pageConfiger.contentViewFrame.width, y: 0, width: self.pageConfiger.contentViewFrame.width, height: self.pageConfiger.contentViewFrame.height)
//            self.pageConfiger.childViewFrames.append(frame)
//        }
//    }
//
//    func addScrollView() {
//        self.scrollView.frame = self.view.bounds
//        self.scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        self.scrollView.delegate = self
//        self.view.addSubview(self.scrollView)
//    }
//
//    func adjustMenuViewFrame() {
//
//    }
//
//    func adjustScrollViewFrame() {
//
//        self.scrollView.frame = self.pageConfiger.contentViewFrame
//        self.scrollView.contentSize = CGSize(width: 2.0 * self.pageConfiger.contentViewFrame.width, height: 0)
//    }
//
//    func addViewController(at index: Int) {
//        let viewController = initializeViewControlle(at: index)
//        self.addChildViewController(viewController)
//        viewController.view.frame = self.pageConfiger.childViewFrames[index]
//        viewController.didMove(toParentViewController: self)
//        self.scrollView.addSubview(viewController.view)
//    }
//
//    func initializeViewControlle(at index: Int) -> UIViewController {
//        if let dataSource = self.dataSource, dataSource.responds(to: #selector(PageViewControllerDataSource.pageViewController(_:viewControllerAtIndex:))) {
//            return dataSource.pageViewController!(self, viewControllerAtIndex: index)
//        } else {
//            return UIViewController()
//        }
//    }
//}
//
//extension PageViewController: UIScrollViewDelegate {
//
//    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//
//    }
//}
//


public protocol PageContentViewControllerDataSource: class {
    
    func numberOfViewController(_ viewController: PageContentViewController) -> Int
    func contentViewController(_ viewController: PageContentViewController, viewControllerAt index: Int) -> UIViewController
}

open class PageContentViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: Config
    public weak var dataSource: PageContentViewControllerDataSource?
    public fileprivate(set) var currentPageIndex: Int = 0
    
    fileprivate var cachedViewControllers = [UIViewController?]()
    fileprivate var numberOfPages: Int = 0
    
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
        removeAll()
        initialLoad(with: currentPageIndex)
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            guard let weakSelf = self else { return }
            weakSelf.scroll(to: weakSelf.currentPageIndex, animated: false)
            }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    //MARK: public
    
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
}
