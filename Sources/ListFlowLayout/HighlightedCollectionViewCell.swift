//
//  HighlightedCollectionViewCell.swift
//  
//
//  Created by Dmitry Vorozhbicki on 06/06/2022.
//

import UIKit

/// Basic UICollectionViewCell for working with ListFlowLayout and additional click animation or loading state
open class HighlightedCollectionViewCell: UICollectionViewCell {
    public enum UICollectionViewCellHighlitedStyle {
        case none, alpha, background(UIColor)
    }
    
    private var activityIndicator: UIActivityIndicatorView?
    private let animationOptions: UIView.AnimationOptions = [.curveEaseInOut, .allowUserInteraction]
    private let shortAnimationDuration: TimeInterval = 0.15
    private let notHighlightedAlpha: CGFloat = 1
    private let highlightedAlpha: CGFloat = 0.3
    
    /// Highlighted view background color
    public var highlightedBackgroundColor = UIColor.gray
    
    /// Click animation style
    public var highlitedStyle: UICollectionViewCellHighlitedStyle = .none {
        didSet {
            isHighlighted = false
        }
    }
    
    /// Horizontal resizable state
    public var isHorizontalResizable: Bool = false
    
    /// State for start/stop loading indicator
    public var isLoadingIndicatorStarted: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.changeLoadingState()
            }
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: shortAnimationDuration, delay: 0, options: animationOptions, animations: {
                switch self.highlitedStyle {
                case .none:
                    break
                case .alpha:
                    self.contentView.alpha = self.isHighlighted ? self.highlightedAlpha : self.notHighlightedAlpha
                case .background(let color):
                    self.backgroundColor = self.isHighlighted ? self.highlightedBackgroundColor : color
                }
            })
        }
    }
    
    private func changeLoadingState() {
        UIView.animate(withDuration: shortAnimationDuration,
                       delay: shortAnimationDuration,
                       options: animationOptions, animations: {
            self.contentView.alpha = self.isLoadingIndicatorStarted ? self.highlightedAlpha : self.notHighlightedAlpha
        }) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.isUserInteractionEnabled = !strongSelf.isLoadingIndicatorStarted
            if strongSelf.isLoadingIndicatorStarted {
                if (strongSelf.activityIndicator == nil) {
                    strongSelf.activityIndicator = strongSelf.createActivityIndicator()
                }
                strongSelf.showSpinning()
            } else {
                strongSelf.activityIndicator?.stopAnimating()
                strongSelf.activityIndicator?.removeFromSuperview()
                strongSelf.activityIndicator = nil
            }
        }
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.darkGray
        return activityIndicator
    }

    private func showSpinning() {
        guard let indicator = activityIndicator else { return }
        self.addSubview(indicator)
        landingActivityIndicatorInButton()
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator?.startAnimating()
    }
    
    private func landingActivityIndicatorInButton() {
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal,
                                                   toItem: activityIndicator, attribute: .centerY,
                                                   multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
        
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal,
                                                   toItem: activityIndicator, attribute: .centerX,
                                                   multiplier: 1, constant: 0)

        self.addConstraint(xCenterConstraint)
    }
    
    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize,
                                                                          withHorizontalFittingPriority: isHorizontalResizable ? .fittingSizeLevel : .required,
                                                                          verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
