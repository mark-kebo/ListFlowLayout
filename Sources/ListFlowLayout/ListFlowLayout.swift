//
//  ListFlowLayout.swift
//
//
//  Created by Dmitry Vorozhbicki on 06/06/2022.
//

import UIKit

/// FlowLayout for UICollectionView to represent cells as a list
final public class ListFlowLayout: UICollectionViewFlowLayout {
    private let cellEdgeInsets: UIEdgeInsets
    private let interitemSpacing: CGFloat
    private let lineSpacing: CGFloat
    
    /// Init
    /// - Parameter cellSideInset: Cell margin
    init(cellSideInset: CGFloat) {
        interitemSpacing = cellSideInset
        lineSpacing = cellSideInset
        self.cellEdgeInsets = UIEdgeInsets(top: cellSideInset, left: cellSideInset,
                                           bottom: cellSideInset, right: cellSideInset)
        super.init()
        prepareFlowLayout()
    }
    
    /// Init
    /// - Parameters:
    ///   - cellEdgeInsets: Cell margin
    ///   - interitemSpacing: Margins between cells
    ///   - lineSpacing: Line spacing
    init(cellEdgeInsets: UIEdgeInsets,
         interitemSpacing: CGFloat,
         lineSpacing: CGFloat) {
        self.interitemSpacing = interitemSpacing
        self.lineSpacing = lineSpacing
        self.cellEdgeInsets = cellEdgeInsets
        super.init()
        prepareFlowLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareFlowLayout() {
        sectionInsetReference = .fromContentInset
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        minimumInteritemSpacing = interitemSpacing
        minimumLineSpacing = lineSpacing
        sectionInset = cellEdgeInsets
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
        layoutAttributesObjects?.forEach({ layoutAttributes in
            if layoutAttributes.representedElementCategory == .cell {
                if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                    layoutAttributes.frame = newFrame
                }
            }
        })
        return layoutAttributesObjects
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            fatalError()
        }
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        layoutAttributes.frame.origin.x = sectionInset.left
        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        return layoutAttributes
    }
}
