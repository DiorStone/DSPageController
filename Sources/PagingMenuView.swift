//
//  PagingMenuView.swift
//  PagingKit
//
//  Copyright (c) 2017 Kazuhiro Hayashi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit


/**
 A PagingMenuViewCell object presents the content for a single menu item when that item is within the paging menu view's visible bounds. 
 You can use this class as-is or subclass it to add additional properties and methods. The layout and presentation of cells is managed by the paging menu view.
 */
open class PagingMenuViewCell: UIView {
    
    /**
     The selection state of the cell.
     
     It is not managed by this class and paging menu view now.
     */
    open var isSelected: Bool = false
    
    /**
     A string that identifies the purpose of the view.
     
     The paging menu view identifies and queues reusable views using their reuse identifiers. The paging menu view sets this value when it first creates the view, and the value cannot be changed later. When your data source is prompted to provide a given view, it can use the reuse identifier to dequeue a view of the appropriate type.
    */
    public internal(set) var identifier: String!
    
    /**
     A index that identifier where the view locate on.
     
     The paging menu view identifiers and queues reusable views using their reuse identifiers. The index specify current state for the view's position.
     */
    public internal(set) var index: Int!
}


/**
 An object that adopts the PagingMenuViewDataSource protocol is responsible for providing the data and views required by a paging menu view. 
 A data source object represents your app’s data model and vends information to the collection view as needed.
 It also handles the creation and configuration of cells and supplementary views used by the collection view to display your data.
 */
public protocol PagingMenuViewDataSource: class {
    
    /// Asks your data source object for the number of sections in the paging menu view.
    ///
    /// - Returns: The number of items in paging menu view.
    func numberOfItemForPagingMenuView() -> Int
    
    /// Asks your data source object for the cell that corresponds to the specified item in the paging menu view.
    /// You can use this delegate methid like UITableView or UICollectionVew.
    ///
    /// - Parameters:
    ///   - pagingMenuView: The paging menu view requesting this information.
    ///   - index: The index that specifies the location of the item.
    /// - Returns: A configured cell object. You must not return nil from this method.
    func pagingMenuView(pagingMenuView: PagingMenuView, cellForItemAt index: Int) -> PagingMenuViewCell
    
    
    /// Asks the delegate for the width to use for a row in a specified location.
    ///
    /// - Parameters:
    ///   - pagingMenuView: The paging menu view requesting this information.
    ///   - index: The index that specifies the location of the item.
    /// - Returns: A nonnegative floating-point value that specifies the width (in points) that row should be.
    func pagingMenuView(pagingMenuView: PagingMenuView, widthForItemAt index: Int) -> CGFloat
}

/**
 The PagingMenuViewDelegate protocol defines methods that allow you to manage the selection of items in a paging menu view and to perform actions on those items.
 */
public protocol PagingMenuViewDelegate: class {
    
    /// Tells the delegate that the specified row is now selected.
    ///
    /// - Parameters:
    ///   - pagingMenuView: The paging menu view requesting this information.
    ///   - index: The index that specifies the location of the item.
    func pagingMenuView(pagingMenuView: PagingMenuView, didSelectItemAt index: Int)
}


/// Displays menu lists of information and supports selection and paging of the information.
public class PagingMenuView: UIScrollView {

    /// Returns an array of visible cells currently displayed by the menu view.
    public fileprivate(set) var visibleCells = [PagingMenuViewCell]()

    fileprivate var queue = [String: [PagingMenuViewCell]]()
    fileprivate var nibs = [String: UINib]()
    fileprivate var widths = [CGFloat]()
    fileprivate var containerView = UIView()
    fileprivate var touchBeganPoint: CGPoint?
    
    /// space setting between cells
    public var cellSpacing: CGFloat = 0
    
    /// The object that acts as the data source of the paging menu view.
    public weak var dataSource: PagingMenuViewDataSource?
    
    /// The object that acts as the delegate of the paging menu view.
    public weak var menuDelegate: PagingMenuViewDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        containerView.frame = bounds
        containerView.center = center

        backgroundColor = .clear
        
        addSubview(containerView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        containerView.frame = bounds
        containerView.center = center
        containerView.backgroundColor = .clear
        backgroundColor = .clear
        
        addSubview(containerView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        if numberOfItem != 0 {
            let visibleBounds = convert(bounds, to: containerView)
            let extraOffset = visibleBounds.width / 2
            tileCell(
                from: max(0, visibleBounds.minX - extraOffset),
                to: min(contentSize.width, visibleBounds.maxX + extraOffset)
            )
        }
    }
    
    /// The number of items in the paging menu view.
    public var numberOfItem: Int = 0
    
    /// Returns an index identifying the row and section at the given point.
    ///
    /// - Parameter point: A point in the local coordinate system of the paging menu view (the paging menu view’s bounds).
    /// - Returns: An index path representing the item associated with point, or nil if the point is out of the bounds of any item.
    public func indexForItem(at point: CGPoint) -> Int? {
        var currentOffsetX: CGFloat = 0
        var resultIndex: Int? = nil
        for (idx, width) in widths.enumerated() {
            let nextOffsetX = currentOffsetX + width
            if (currentOffsetX..<nextOffsetX) ~= point.x {
                resultIndex = idx
                break
            }
            currentOffsetX = nextOffsetX
        }
        return resultIndex
    }
    
    /// Returns the paging menu cell at the specified index .
    ///
    /// - Parameter index: The index locating the item in the paging menu view.
    /// - Returns: An object representing a cell of the menu, or nil if the cell is not visible or index is out of range.
    public func cellForItem(at index: Int) -> PagingMenuViewCell? {
        return visibleCells.filter { $0.index == index }.first
    }
    
    /// Reloads the rows and sections of the table view.
    public func reloadData() {
        guard let dataSource = dataSource else {
            return
        }

        visibleCells.forEach { $0.removeFromSuperview() }
        visibleCells = []
        
        numberOfItem = dataSource.numberOfItemForPagingMenuView()
        
        invalidateLayout()
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    /// Registers a nib object containing a cell with the paging menu view under a specified identifier.
    ///
    /// - Parameters:
    ///   - nib: A nib object that specifies the nib file to use to create the cell.
    ///   - identifier: The reuse identifier for the cell. This parameter must not be nil and must not be an empty string.
    public func register(nib: UINib?, with identifier: String) {
        nibs[identifier] = nib
    }

    /// Returns a reusable paging menu view cell object for the specified reuse identifier and adds it to the menu.
    ///
    /// - Parameter identifier: A string identifying the cell object to be reused. This parameter must not be nil.
    /// - Returns: The index specifying the location of the cell.
    public func dequeue(with identifier: String) -> PagingMenuViewCell {
        if var cells = queue[identifier], !cells.isEmpty {
            let cell = cells.removeFirst()
            queue[identifier] = cells
            cell.identifier = identifier
            return cell
        }
        
        if let nib = nibs[identifier] {
            let cell = nib.instantiate(withOwner: self, options: nil).first as! PagingMenuViewCell
            cell.identifier = identifier
            return cell
        }
        
        fatalError()
    }

    /// Returns the drawing area for a row identified by index.
    ///
    /// - Parameter index: An index that identifies a item by its index.
    /// - Returns: A rectangle defining the area in which the table view draws the row or right edge rect if index is over the number of items.
    public func rectForItem(at index: Int) -> CGRect? {
        guard index < widths.count else {
            let rightEdge = widths.reduce(CGFloat(0)) { (sum, width) in sum + width }
            return CGRect(x: rightEdge, y: 0, width: 0, height: bounds.height)
        }
        
        var x = (0..<index).reduce(0) { (sum, idx) in
            return sum + widths[idx]
        }
        x += cellSpacing * CGFloat(index)
        return CGRect(x: x, y: 0, width: widths[index], height: bounds.height)
    }
    
    public func invalidateLayout() {
        guard let dataSource = dataSource else {
            return
        }

        widths = []
        var containerWidth: CGFloat = 0
        (0..<numberOfItem).forEach { (index) in
            let width = dataSource.pagingMenuView(pagingMenuView: self, widthForItemAt: index)
            widths.append(width)
            containerWidth += width
        }
        containerWidth += totalSpacing
        contentSize = CGSize(width: containerWidth, height: bounds.height)
        containerView.frame = CGRect(origin: .zero, size: contentSize)
        align()
    }
    
    private var numberOfCellSpacing: CGFloat {
        return max(CGFloat(numberOfItem - 1), 0)
    }
    
    private var totalSpacing: CGFloat {
        return cellSpacing * numberOfCellSpacing
    }
    
    private func recenterIfNeeded() {
        let currentOffset = contentOffset
        let contentWidth = contentSize.width
        let centerOffsetX = (contentWidth - bounds.size.width) / 2
        let distanceFromCenter = fabs(currentOffset.x - centerOffsetX)
        
        if distanceFromCenter > (contentWidth - bounds.size.width) / 4 {
            contentOffset = CGPoint(x: centerOffsetX, y: currentOffset.y)
            
            for cell in visibleCells {
                var center = containerView.convert(cell.center, to: self)
                center.x += centerOffsetX - currentOffset.x
                cell.center = convert(center, to: containerView)
            }
        }
    }
    
    private func align() {
        visibleCells.forEach { (cell) in
            let leftEdge = (0..<cell.index).reduce(CGFloat(0)) { (sum, idx) in sum + widths[idx] + cellSpacing }
            cell.frame.origin = CGPoint(x: leftEdge, y: 0)
            cell.frame.size = CGSize(width: widths[cell.index], height: bounds.height)
        }
    }
    
    @discardableResult
    private func placeNewCellOnRight(with rightEdge: CGFloat, index: Int, dataSource: PagingMenuViewDataSource) -> CGFloat {
        let nextIndex = (index + 1) % numberOfItem
        let cell = dataSource.pagingMenuView(pagingMenuView: self, cellForItemAt: nextIndex)
        cell.index = nextIndex
        containerView.addSubview(cell)
        
        visibleCells.append(cell)
        cell.frame.origin = CGPoint(x: rightEdge, y: 0)
        cell.frame.size = CGSize(width: widths[nextIndex], height: bounds.height)

        return cell.frame.maxX
    }
    
    private func placeNewCellOnLeft(with leftEdge: CGFloat, index: Int, dataSource: PagingMenuViewDataSource) -> CGFloat {
        let nextIndex: Int
        if index == 0 {
            nextIndex = numberOfItem - 1
        } else {
            nextIndex = (index - 1) % numberOfItem
        }
        let cell = dataSource.pagingMenuView(pagingMenuView: self, cellForItemAt: nextIndex)
        cell.index = nextIndex
        
        containerView.addSubview(cell)
        
        visibleCells.insert(cell, at: 0)
        cell.frame.size = CGSize(width: widths[nextIndex], height: bounds.height)
        cell.frame.origin = CGPoint(x: leftEdge - widths[nextIndex] - cellSpacing, y: 0)
        return cell.frame.minX
    }

    private func tileCell(from minX: CGFloat, to maxX: CGFloat) {
        guard let dataSource = dataSource, 0 < numberOfItem else {
            return
        }
        
        if visibleCells.isEmpty {
            placeNewCellOnRight(with: minX, index: numberOfItem - 1, dataSource: dataSource)
        }
        
        var lastCell = visibleCells.last
        var rightEdge = lastCell.flatMap { $0.frame.maxX + cellSpacing }
        while let _lastCell = lastCell, let _rightEdge = rightEdge,
            _rightEdge < maxX, (0..<numberOfItem) ~= _lastCell.index + 1 {
                rightEdge = placeNewCellOnRight(with: _rightEdge, index: _lastCell.index, dataSource: dataSource) + cellSpacing
                lastCell = visibleCells.last
        }
        
        var firstCell = visibleCells.first
        var leftEdge = firstCell?.frame.minX
        while let _firstCell = firstCell, let _leftEdge = leftEdge,
            _leftEdge > minX, (0..<numberOfItem) ~= _firstCell.index - 1 {
                leftEdge = placeNewCellOnLeft(with: _leftEdge, index: _firstCell.index, dataSource: dataSource)
                firstCell = visibleCells.first
        }
        
        
        while let lastCell = visibleCells.last, lastCell.frame.minX > maxX {
            lastCell.removeFromSuperview()
            let recycleCell = visibleCells.removeLast()
            
            if let cells = queue[recycleCell.identifier] {
                queue[recycleCell.identifier] = cells + [recycleCell]
            } else {
                queue[recycleCell.identifier] = [recycleCell]
            }
        }

        while let firstCell = visibleCells.first, firstCell.frame.maxX < minX {
            firstCell.removeFromSuperview()
            let recycleCell = visibleCells.removeFirst()
            
            if let cells = queue[recycleCell.identifier] {
                queue[recycleCell.identifier] = cells + [recycleCell]
            } else {
                queue[recycleCell.identifier] = [recycleCell]
            }
        }
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchBeganPoint = touches.first.flatMap { $0.location(in: containerView) }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let touchEndedPoint = touches.first.flatMap({ $0.location(in: containerView) }),
            touchBeganPoint == touchEndedPoint else { return }
        
        let selectedCell = visibleCells.filter { cell in cell.frame.contains(touchEndedPoint) }.first
        if let index = selectedCell?.index {
            menuDelegate?.pagingMenuView(pagingMenuView: self, didSelectItemAt: index)
        }
    }
}
