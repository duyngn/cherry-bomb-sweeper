//
//  FieldGridCollectionView.swift
//  CherryBombSweeper
//
//  Created by Duy Nguyen on 1/15/18.
//  Copyright © 2018 Duy.Ninja. All rights reserved.
//

import UIKit

class FieldGridCollectionView: UICollectionView {
    
    enum Constant {
        static let cellDimension = CGFloat(41)
        static let cellInset = CGFloat(1)
        static let gridCellIdentifier = "FieldGridCell"
    }
    
    fileprivate var mineField: MineField?
    
    fileprivate var cellDimension: CGFloat = Constant.cellDimension
    
    fileprivate var containerView: UIView?
    
    fileprivate var cellTapHandler: CellTapHandler?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.delegate = self
        
        self.register(UINib(nibName: Constant.gridCellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constant.gridCellIdentifier)
    }
    
    func setupFieldGrid(with mineField: MineField, container: UIView,
                        dataSource: UICollectionViewDataSource,
                        cellTapHandler: @escaping CellTapHandler) {
        self.dataSource = dataSource
        self.mineField = mineField
        self.cellTapHandler = cellTapHandler
        self.containerView = container
        
        if let layout = self.collectionViewLayout as? FieldGridCollectionViewLayout {
            layout.delegate = self
        }
        
        let rows = CGFloat(mineField.rows)
        let columns = CGFloat(mineField.columns)
        
        let fieldWidth = (columns * (Constant.cellDimension + Constant.cellInset)) - Constant.cellInset
        let fieldHeight = (rows * (Constant.cellDimension + Constant.cellInset)) - Constant.cellInset
        
        // Setting field width and height via auto layout
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: fieldWidth).isActive = true
        self.heightAnchor.constraint(equalToConstant: fieldHeight).isActive = true
        self.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        // Show and reload
        self.reloadData()
    }
}

extension FieldGridCollectionView: FieldGridLayoutDelegate {    
    func collectionView(rowCountForFieldGrid collectionView: UICollectionView) -> Int {
        return self.mineField?.rows ?? 0
    }
    
    func collectionView(columnCountForFieldGrid collectionView: UICollectionView) -> Int {
        return self.mineField?.columns ?? 0
    }
    
    func collectionView(cellDimensionForFieldGrid collectionView: UICollectionView) -> CGFloat {
        return self.cellDimension // * self.scaleFactor
    }
    
    func collectionView(cellSpacingForFieldGrid collectionView: UICollectionView) -> CGFloat {
        return Constant.cellInset
    }
    
    func collectionView(viewWindowForFieldGrid collectionView: UICollectionView) -> CGRect? {
        return self.containerView?.bounds
    }
}

extension FieldGridCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt: IndexPath) {
        self.cellTapHandler?(didSelectItemAt.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.cellInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.cellInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellDimension, height: self.cellDimension);
    }
}

extension FieldGridCollectionView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
