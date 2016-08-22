//
//  SACircleView.swift
//  PINManagement
//
//  Created by Siavash on 21/08/2016.
//  Copyright © 2016 Siavash Abbasalipour. All rights reserved.
//

import Foundation
import UIKit

/// Thanks to https://github.com/MengTo/Spring
/// vary simplified version of Spring
class SACircleView: UIView {
    
    var autostart: Bool = false
    var autohide: Bool = false
    var animation: String = ""
    var force: CGFloat = 1
    var delay: CGFloat = 0
    var duration: CGFloat = 0.7
    var damping: CGFloat = 0.7
    var velocity: CGFloat = 0.7
    var repeatCount: Float = 1
    var x: CGFloat = 0
    var y: CGFloat = 0
    var scaleX: CGFloat = 1
    var scaleY: CGFloat = 1
    var rotate: CGFloat = 0
    var curve: String = ""
    var opacity: CGFloat = 1
    var animateFrom: Bool = false
    
    var circleBorderColor: UIColor! {
        didSet {
            layer.borderColor = circleBorderColor.colorWithAlphaComponent(0.8).CGColor
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        circleBorderColor = UIColor.whiteColor()
        layer.borderColor = circleBorderColor.colorWithAlphaComponent(0.8).CGColor
        layer.borderWidth = 1
        backgroundColor = UIColor.clearColor()
        layer.cornerRadius = SAPinConstant.CircleWidth/2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func animatePreset() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 30*force, -30*force, 30*force, 0]
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 1.1+Float(force/3), 1, 1)
        animation.duration = CFTimeInterval(duration)
        animation.additive = true
        animation.repeatCount = repeatCount
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        layer.addAnimation(animation, forKey: "shake")
    }
    func animateTapFull() {
        UIView.animateWithDuration(0.17, delay: 0, options: .CurveEaseIn, animations: {
            self.backgroundColor = self.circleBorderColor.colorWithAlphaComponent(0.6)
        }) { (_) in}
    }
    func animateTapEmpty() {
        UIView.animateWithDuration(0.17, delay: 0, options: .CurveEaseIn, animations: {
            self.backgroundColor = UIColor.clearColor()
        }) { (_) in}
    }
    func setView(completion: () -> ()) {
        if animateFrom {
            let translate = CGAffineTransformMakeTranslation(x, y)
            let scale = CGAffineTransformMakeScale(1, 1)
            let rotate = CGAffineTransformMakeRotation(self.rotate)
            let translateAndScale = CGAffineTransformConcat(translate, scale)
            transform = CGAffineTransformConcat(rotate, translateAndScale)
            
            alpha = opacity
        }
        
        UIView.animateWithDuration( NSTimeInterval(duration),
                                    delay: NSTimeInterval(delay),
                                    usingSpringWithDamping: damping,
                                    initialSpringVelocity: velocity,
                                    options: [getAnimationOptions(curve), UIViewAnimationOptions.AllowUserInteraction],
                                    animations: { [weak self] in
                                        if let _self = self
                                        {
                                            if _self.animateFrom {
                                                _self.transform = CGAffineTransformIdentity
                                                _self.alpha = 1
                                            }
                                            else {
                                                let translate = CGAffineTransformMakeTranslation(_self.x, _self.y)
                                                let scale = CGAffineTransformMakeScale(1, 1)
                                                let rotate = CGAffineTransformMakeRotation(_self.rotate)
                                                let translateAndScale = CGAffineTransformConcat(translate, scale)
                                                _self.transform = CGAffineTransformConcat(rotate, translateAndScale)
                                                
                                                _self.alpha = _self.opacity
                                            }
                                            
                                        }
                                        
            }, completion: { [weak self] finished in
                
                completion()
                self?.resetAllForBallView()
                
            })
        
    }
    func getAnimationOptions(curve: String) -> UIViewAnimationOptions {
        return UIViewAnimationOptions.CurveLinear
    }
    func resetAllForBallView() {
        x = 0
        y = 0
        animation = ""
        opacity = 1
        
        rotate = 0
        damping = 0.7
        velocity = 0.7
        repeatCount = 1
        delay = 0
        duration = 0.7
    }
}