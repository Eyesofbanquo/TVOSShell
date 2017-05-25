//
//  RandomColors.swift
//  TVOSShell
//
//  Created by Markim on 5/10/17.
//  Copyright © 2017 Markim. All rights reserved.
//
import UIKit

func generateRandomData() -> [[UIColor]] {
    let numberOfRows = 20
    let numberOfItemsPerRow = 15
    
    return (0..<numberOfRows).map { _ in
        return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
    }
}

extension UIColor {
    
    class func randomColor() -> UIColor {
        
        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}

extension UILabel {
    override open var canBecomeFocused:Bool {
        return true
    }
}

extension UIImageView {
    override open var canBecomeFocused: Bool {
        return true
    }
    
    func addGradientLayer() {
        // Create the gradient layer
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1).cgColor]
        // Whatever direction you want the fade. You can use gradientLayer.locations
        // to provide an array of points, with matching colors for each point,
        // which lets you do other than just a uniform gradient.
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        // Use the gradient layer as the mask
        self.layer.mask = gradientLayer
    }
}

extension UIView {
    func addParallaxMotionEffects(tiltValue:CGFloat, panValue:CGFloat) {
        var xTilt:UIInterpolatingMotionEffect = UIInterpolatingMotionEffect()
        var yTilt:UIInterpolatingMotionEffect = UIInterpolatingMotionEffect()
        
        var xPan:UIInterpolatingMotionEffect = UIInterpolatingMotionEffect()
        var yPan:UIInterpolatingMotionEffect = UIInterpolatingMotionEffect()
        
        let motionGroup:UIMotionEffectGroup = UIMotionEffectGroup()
        
        xTilt = UIInterpolatingMotionEffect(keyPath: "layer.transform.rotation.y", type: .tiltAlongHorizontalAxis)
        xTilt.minimumRelativeValue = -1 * tiltValue
        xTilt.maximumRelativeValue = tiltValue
        
        yTilt = UIInterpolatingMotionEffect(keyPath: "layer.transform.rotation.x", type: .tiltAlongVerticalAxis)
        yTilt.minimumRelativeValue = -1 * tiltValue
        yTilt.maximumRelativeValue = tiltValue
        
        xPan = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xPan.minimumRelativeValue = -1 * panValue
        xPan.maximumRelativeValue = panValue
        
        yPan = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yPan.minimumRelativeValue = -1 * panValue
        yPan.maximumRelativeValue = panValue
        
        motionGroup.motionEffects = [xTilt, yTilt, xPan, yPan]
        self.addMotionEffect(motionGroup)
        
    }
}
