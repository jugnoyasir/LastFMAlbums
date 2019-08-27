//
//  ViewControllTransitionAnimation.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import UIKit

// Custom view controller tranition animation
protocol ViewControllTransitionAnimationProtocol: UIViewControllerAnimatedTransitioning {
  var originFrame: CGRect { get set }
  var duration: Double { get }
  var presenting: Bool { get set }
  var dismissCompletion: (() -> Void)? { get set }
  
}

class ViewControllTransitionAnimation: NSObject, ViewControllTransitionAnimationProtocol {
  var originFrame = CGRect.zero
  let duration = 0.2
  var presenting = true
  
  // View controller closing the animation
  var dismissCompletion: (() -> Void)?
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    
    guard let toView = transitionContext.view(forKey: .to), let detailsView = presenting ? toView : transitionContext.view(forKey: .from) else {
      fatalError("Animator:: veiw not found. this should not be called ever")
    }
    
    let initialFrame = presenting ? originFrame : detailsView.frame
    let finalFrame = presenting ? detailsView.frame : originFrame
    
    let xScaleFactor = presenting ?
      initialFrame.width / finalFrame.width :
      finalFrame.width / initialFrame.width
    
    let yScaleFactor = presenting ?
      initialFrame.height / finalFrame.height :
      finalFrame.height / initialFrame.height
    
    let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
    
    if presenting {
      detailsView.transform = scaleTransform
      detailsView.center = CGPoint(
        x: initialFrame.midX,
        y: initialFrame.midY)
      detailsView.clipsToBounds = true
    }
    
    detailsView.layer.cornerRadius = presenting ? 20.0 : 0.0
    detailsView.layer.masksToBounds = true
    
    containerView.addSubview(toView)
    containerView.bringSubviewToFront(detailsView)
    
    UIView.animate(
      withDuration: duration,
      delay: 0.0,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 0.2,
      animations: {
        detailsView.transform = self.presenting ? .identity : scaleTransform
        detailsView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        detailsView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
      }, completion: { _ in
        if !self.presenting {
          self.dismissCompletion?()
        }
        transitionContext.completeTransition(true)
    })
  }
}
