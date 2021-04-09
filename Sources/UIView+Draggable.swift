//
//  UIView+Draggable.swift
//
//  Created by Yehia Elbehery on 1/10/19.
//  Copyright © 2019 Yehia Elbehery. All rights reserved.
//

import UIKit

extension UIView {
    func addDragging(){
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedAction(_ :)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func draggedAction(_ gesture:UIPanGestureRecognizer){
        
        let padding = UIScreen.main.bounds.width / 320 * 20
        switch gesture.state {
        case .ended:
            let translation = gesture.translation(in: self.superview)
            let view = self as! Floaty
            var x: CGFloat = 0
            if self.frame.minX > superview!.bounds.width / 2 {
                x =  superview!.bounds.width - padding - view.size
            } else {
                x =  padding
            }
            
            var y: CGFloat = 0
            if self.frame.minY > superview!.bounds.height - view.size  {
                var verticalMargin = view.size
                var horizontalMargin = view.size
                if #available(iOS 11, *), view.relativeToSafeArea, let safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets {
                  verticalMargin += safeAreaInsets.bottom
                  horizontalMargin += safeAreaInsets.right
                }
                x = (superview!.bounds.size.width - horizontalMargin) - view.paddingX
                y =  (UIScreen.main.bounds.size.height - verticalMargin) - view.paddingY
            } else if  self.frame.minY > superview!.bounds.height / 2{
                y =  self.frame.minY + translation.y
            } else {
                y =  superview!.bounds.height / 2
            }
            
            let finalPoint = CGPoint(
                x: x,
              y: y
            )
            UIView.animate(
                withDuration: 0.2,
              delay: 0,
              options: .curveEaseOut,
              animations: {
                self.frame.origin = finalPoint
            })
        
        
        case .changed:
            let translation = gesture.translation(in: self.superview)
            self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: self.superview)
        default:
            break
        }
    }
}
