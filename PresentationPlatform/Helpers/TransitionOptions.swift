//
//  TransitionOptions.swift
//  PresentationPlatform
//
//  Created by Dino Catalinac on 14/12/2019.
//  Copyright © 2019 DinoCata. All rights reserved.
//

import UIKit

public struct TransitionOptions {
    
    /// Curve of animation
    ///
    /// - linear: linear
    /// - easeIn: ease in
    /// - easeOut: ease out
    /// - easeInOut: ease in - ease out
    public enum Curve {
        case linear
        case easeIn
        case easeOut
        case easeInOut
        
        /// Return the media timing function associated with curve
        internal var function: CAMediaTimingFunction {
            switch self {
            case .linear:
                return CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            case .easeIn:
                return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            case .easeOut:
                return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            case .easeInOut:
                return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            }
        }
    }
    
    /// Direction of the animation
    ///
    /// - fade: fade to new controller
    /// - toTop: slide from bottom to top
    /// - toBottom: slide from top to bottom
    /// - toLeft: pop to left
    /// - toRight: push to right
    public enum Direction {
        case fade
        case toTop
        case toBottom
        case toLeft
        case toRight
        
        /// Return the associated transition
        ///
        /// - Returns: transition
        internal func transition() -> CATransition {
            let transition = CATransition()
            transition.type = CATransitionType.push
            switch self {
            case .fade:
                transition.type = CATransitionType.fade
                transition.subtype = nil
            case .toLeft:
                transition.subtype = CATransitionSubtype.fromLeft
            case .toRight:
                transition.subtype = CATransitionSubtype.fromRight
            case .toTop:
                transition.subtype = CATransitionSubtype.fromTop
            case .toBottom:
                transition.subtype = CATransitionSubtype.fromBottom
            }
            return transition
        }
    }
    
    /// Background of the transition
    ///
    /// - solidColor: solid color
    /// - customView: custom view
    public enum Background {
        case solidColor(_: UIColor)
        case customView(_: UIView)
    }
    
    /// Duration of the animation (default is 0.20s)
    public var duration: TimeInterval = 0.35
    
    /// Direction of the transition (default is `toRight`)
    public var direction: TransitionOptions.Direction = .toRight
    
    /// Style of the transition (default is `linear`)
    public var style: TransitionOptions.Curve = .easeInOut
    
    /// Background of the transition (default is `nil`)
    public var background: TransitionOptions.Background?
    
    /// Return the animation to perform for given options object
    internal var animation: CATransition {
        let transition = self.direction.transition()
        transition.duration = self.duration
        transition.timingFunction = self.style.function
        return transition
    }
    
    /// Initialize a new options object with given direction and curve
    ///
    /// - Parameters:
    ///   - direction: direction
    ///   - style: style
    public init(direction: TransitionOptions.Direction = .toRight, style: TransitionOptions.Curve = .easeInOut) {
        self.direction = direction
        self.style = style
    }
    
    public init() { }
}

