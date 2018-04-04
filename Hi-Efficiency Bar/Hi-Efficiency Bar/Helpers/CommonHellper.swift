//
//  CommonHellper.swift
//  projectX
//
//  Created by Colin Ngo on 1/23/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
class CommonHellper {
    static func borderSubView(view: UIView)
    {
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
    }
    
    static func isValidEmail(testStr: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func trimSpaceString(txtString:String) -> String {
        return txtString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    static func formatDateBirthday(date: Date)->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: date)
    }
    
    static func animateButton(view: UIView) {
        view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.2),
                       initialSpringVelocity: CGFloat(6.0),
                       options: .allowUserInteraction,
                       animations: {
                        view.transform = .identity
        },
                       completion: { finished in
        }
        )
    }
    static func animateView(view: UIView) {
        UIView.animate(withDuration: 0.25,
                       animations: {
                        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.25) {
                            view.transform = CGAffineTransform.identity
                        }
        })
    }
    
    static func animateViewSmall(view: UIView) {
        UIView.animate(withDuration: 0.25,
                       animations: {
                        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.25) {
                            view.transform = CGAffineTransform.identity
                        }
        })
    }
    
  
}
extension UIColor {
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        let shadowSize : CGFloat = 3.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.frame.size.width + shadowSize,
                                                   height: self.frame.size.height + shadowSize))
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowPath = shadowPath.cgPath
        
    }
    func removedropShadow() {
        let shadowSize : CGFloat = 3.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.frame.size.width + shadowSize,
                                                   height: self.frame.size.height + shadowSize))
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowPath = shadowPath.cgPath
        
    }
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
