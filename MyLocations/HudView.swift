//
//  HudView.swift
//  MyLocations
//
//  Created by Mario Alberto Gonzalez on 23/03/17.
//  Copyright © 2017 Mario Alberto Gonzalez. All rights reserved.
//

import UIKit

class HudView: UIView {
    
    class func hud(inView parent: UIView, animate: Bool) -> HudView {
        let hudView = HudView(frame: parent.bounds)
        hudView.isOpaque = false
        
        parent.addSubview(hudView)
        parent.isUserInteractionEnabled = false
        hudView.show(animated: animate)
        return hudView
    }
    
    override func draw(_ rect: CGRect) {
        let boxWidth: CGFloat = 96.0
        let boxHeigth: CGFloat = 96.0
        let boxRect = CGRect(
            x: round((bounds.size.width - boxWidth) / 2),
            y: round((bounds.size.height - boxHeigth) / 2),
            width: boxWidth,
            height: boxHeigth)
        
        let image = UIImage(named: "hud")
        let imageView = UIImageView(image: image)
        imageView.frame = boxRect
        self.addSubview(imageView)
    }
    
    func show(animated: Bool) {
        if animated {
            alpha = 0
            transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform.identity
            })
        }
    }
}
