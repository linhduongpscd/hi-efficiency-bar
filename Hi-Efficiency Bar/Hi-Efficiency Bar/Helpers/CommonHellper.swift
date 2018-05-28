//
//  CommonHellper.swift
//  projectX
//
//  Created by Colin Ngo on 1/23/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import RappleProgressHUD
class CommonHellper {
    static func borderSubView(view: UIView)
    {
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
    }
    static func showBusy()
    {
        var attribute = RappleActivityIndicatorView.attribute(style: .apple, tintColor: .white, screenBG: .lightGray, progressBG: .black, progressBarBG: .orange, progreeBarFill: .red, thickness: 4)
        attribute[RappleIndicatorStyleKey] = RappleStyleCircle
        RappleActivityIndicatorView.startAnimatingWithLabel("", attributes: attribute)
        
    }
    static func radomColor()->[UIColor]
    {
        return [UIColor.init(red: 214/255.0, green: 180/255.0, blue: 110/255.0, alpha: 1.0),
                UIColor.init(red: 241/255.0, green: 240/255.0, blue: 144/255.0, alpha: 1.0),
                UIColor.init(red: 201/255.0, green: 233/255.0, blue: 122/255.0, alpha: 1.0),
                UIColor.init(red: 224/255.0, green: 129/255.0, blue: 85/255.0, alpha: 1.0),
                UIColor.init(red: 165/255.0, green: 23/255.0, blue: 14/255.0, alpha: 1.0),
                UIColor.init(red: 248/255.0, green: 225/255.0, blue: 32/255.0, alpha: 1.0),
                UIColor.init(red: 253/255.0, green: 139/255.0, blue: 28/255.0, alpha: 1.0),
                UIColor.init(red: 103/255.0, green: 128/255.0, blue: 255/255.0, alpha: 1.0),
        UIColor.init(red: 232/255.0, green: 103/255.0, blue: 255/255.0, alpha: 1.0),
        UIColor.init(red: 255/255.0, green: 175/255.0, blue: 103/255.0, alpha: 1.0),
        UIColor.init(red: 7/255.0, green: 226/255.0, blue: 12/255.0, alpha: 1.0),
        UIColor.init(red: 255/255.0, green: 45/255.0, blue: 85/255.0, alpha: 1.0),
        UIColor.init(red: 193/255.0, green: 195/255.0, blue: 10/255.0, alpha: 1.0),
        UIColor.init(red: 117/255.0, green: 250/255.0, blue: 252/255.0, alpha: 1.0),
        UIColor.init(red: 160/255.0, green: 168/255.0, blue: 240/255.0, alpha: 1.0),
        UIColor.init(red: 215/255.0, green: 157/255.0, blue: 151/255.0, alpha: 1.0),
        UIColor.init(red: 251/255.0, green: 188/255.0, blue: 225/255.0, alpha: 1.0),
        UIColor.init(red: 177/255.0, green: 177/255.0, blue: 177/255.0, alpha: 1.0)]
    }
    
    static func ramColorViewDetail()->UIColor
    {
        let arrColor = self.radomColor()
        let randomIndex = Int(arc4random_uniform(UInt32(arrColor.count)))
        return arrColor[randomIndex]
    }
    static func hideBusy()
    {
        RappleActivityIndicatorView.stopAnimation()
    }
    static func isValidEmail(testStr: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func convertMLDrink(unit: String, number: Int)-> Double
    {
        
        if unit == "ml"
        {
            return Double(number)
        }
        else if unit == "dash"
        {
             return Double(number) * 0.9240625
        }
        else if unit == "splash"
        {
            return Double(number) * 2.4641666667
        }
        else if unit == "teaspoon"
        {
            return Double(number) * 4.9283333333
        }
        else if unit == "tablespoon"
        {
            return Double(number) * 14.785
        }
        else if unit == "pony"
        {
            return Double(number) * 29.57
        }
        else if unit == "jigger" || unit == "shot"
        {
            return Double(number) * 44.1343283582
        }
        else if unit == "snit"
        {
            return Double(number) * 89.6060606061
        }
        else if unit == "split"
        {
            return Double(number) * 173.9411764706
        }
        else if unit == "oz"
        {
             return Double(number) * 29.57
        }
        else if unit == "part" ||  unit == "%"
        {
            return 0.0
        }
        return Double(number)
    }
    
    
    static func valueUnit(unit: String)-> Int
    {
        
        if unit == "ml"
        {
            return 10
        }
        else if unit == "dash"
        {
            return 20
        }
        else if unit == "splash"
        {
            return 30
        }
        else if unit == "teaspoon"
        {
            return 40
        }
        else if unit == "tablespoon"
        {
            return 50
        }
        else if unit == "pony"
        {
            return 60
        }
        else if unit == "jigger"
        {
            return 70
        }
        else if unit == "shot"
        {
            return 80
        }
        else if unit == "snit"
        {
            return 90
        }
        else if unit == "split"
        {
            return 100
        }
        else if unit == "oz"
        {
            return 110
        }
        else if unit == "part"
        {
            return 1
        }
        else if unit == "%"
        {
            return 0
        }
        return 0
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
    static func formatDateBirthday2(date: Date)->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
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
    
    static func addBlurView(_ inView : UIView)
    {
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = inView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 1
        inView.addSubview(blurView)
    }
    
    static func getTaxDrink(_ price: Double) -> Double
    {
        print(price)
        print(APP_DELEGATE.settingObj.tax)
        print(APP_DELEGATE.settingObj.tax! + APP_DELEGATE.settingObj.free!)
        print((APP_DELEGATE.settingObj.tax! + APP_DELEGATE.settingObj.free!)/100)
        if APP_DELEGATE.settingObj.fee_unit_view == "%"
        {
            return price * Double(Double((APP_DELEGATE.settingObj.tax! + APP_DELEGATE.settingObj.free!)) * 0.01)
        }
        else{
            return price * Double(Double(APP_DELEGATE.settingObj.tax!) * 0.01) + Double(APP_DELEGATE.settingObj.free!)
        }
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

extension String {
    func substring(from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: to - from)
        return String(self[start ..< end])
    }
    
    func substring(range: NSRange) -> String {
        return substring(from: range.lowerBound, to: range.upperBound)
    }
}
