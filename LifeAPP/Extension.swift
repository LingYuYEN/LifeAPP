

import UIKit

class Extension: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}
//extension UILabel {
//    /// 設定NIB Cell(Name)
//    func setDetailCellNameAttriStr(string: String) -> NSAttributedString {
//        let attributedString = NSMutableAttributedString(string: string)
//        let attributeFont = [NSAttributedString.Key.font: UIFont(name: "NotoSansTC-Bold", size: 17.3)]
//        attributedString.addAttribute(NSAttributedString.Key.kern, value: 4.25, range: NSRange(location: 0, length: attributedString.length))
//        attributedString.addAttributes(attributeFont as [NSAttributedString.Key : Any], range: NSRange(location: 0, length: attributedString.length))
//        return attributedString
//    }
//}

extension UIButton {
    @IBInspectable
    var cornerRadius: CGFloat {
        return self.layer.cornerRadius
    }
    
    
    
    @objc func set(image anImage: UIImage?, title: String,
                   titlePosition: UIView.ContentMode, additionalSpacing: CGFloat, state: UIControl.State){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    
    private func positionLabelRespectToImage(title: String, position: UIView.ContentMode,
                                             spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing + 70))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}



extension NSAttributedString {
    // wordSpace字距
    static func setAttributedString(string: String, wordSpace: CGFloat, textColor: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let attributedStringColor = [NSAttributedString.Key.foregroundColor : textColor]
        attributedString.addAttribute(NSAttributedString.Key.kern, value: wordSpace, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes(attributedStringColor, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    
    // 包含置中的字距離
    static func setCenterAttributedString(string: String, wordSpace: CGFloat, textColor: UIColor) -> NSAttributedString {
        let paraph = NSMutableParagraphStyle()
        paraph.alignment = .justified
        paraph.paragraphSpacing = 20
        let attributedString = NSMutableAttributedString(string: string)
        let attributedStringColor = [NSAttributedString.Key.foregroundColor : textColor]
        attributedString.addAttribute(NSAttributedString.Key.kern, value: wordSpace, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes(attributedStringColor, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paraph, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    /// 僅設定字距
    ///
    /// - Parameters:
    ///   - string: 輸入呈現的文字
    ///   - kern: 輸入字距
    static func setKernAttriStr(string: String, kern: NSNumber) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.kern, value: kern, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    
    /// 導覽列標題
    static func setNaviTitleAttriStr(string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 5, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    
    /// 首頁大標題
    static func setLargeTitleAttriStr(string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 4.68, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    
    
    /// 首頁小標題
    static func setTitleAttriStr(string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 3.75, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    
    /// 設定NIB Cell(Name)
    static func setDetailCellNameAttriStr(string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let attributeFont = [NSAttributedString.Key.font: UIFont(name: "NotoSansTC-Bold", size: 17.3)]
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 4.25, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes(attributeFont as [NSAttributedString.Key : Any], range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    /// 設定NIB Cell(SubName)
    static func setDetailCellSubNameAttriStr(string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let attributeFont = [NSAttributedString.Key.font: UIFont(name: "NotoSansTC-Medium", size: 15)]
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 3.67, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes(attributeFont as [NSAttributedString.Key : Any], range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    /// 設定NIB Cell(Detail Button)
    static func setDetailCellBtnAttriStr(string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let attributeFont = [NSAttributedString.Key.font: UIFont(name: "NotoSansTC-Bold", size: 15)]
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 3.75, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes(attributeFont as [NSAttributedString.Key : Any], range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    /// Detail頁面 Body 描述文字
    static func setBodyTextAttriStr(string: String) -> NSAttributedString {
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 10
        paraph.alignment = .justified
        
        let attributedString = NSMutableAttributedString(string: string)
        let stringColor = [NSAttributedString.Key.foregroundColor : UIColor.setPriceUp()]
        attributedString.addAttributes(stringColor, range: NSRange(location: 0, length: attributedString.length))
        
        // 字距調整
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 3.67, range: NSRange(location: 0, length: attributedString.length))
        // 行距調整
        attributedString.addAttribute(.paragraphStyle, value: paraph, range: NSRange(location: 0, length: attributedString.length))
        
        
        
        return attributedString
    }
    
    
    
//======================================================================================================
//    static func setLargeAttributedString(string: String) -> NSAttributedString {
//        let attributedString = NSMutableAttributedString(string: string)
//        let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        attributedString.addAttribute(NSAttributedString.Key.kern, value: 3.5, range: NSRange(location: 0, length: attributedString.length))
//        attributedString.addAttributes(attributedStringColor, range: NSRange(location: 0, length: attributedString.length))
//        return attributedString
//    }
//
//    static func setMediumAttributedString(string: String) -> NSAttributedString {
//        let attributedString = NSMutableAttributedString(string: string)
//        let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor(red: 1, green: 214/255, blue: 0, alpha: 1)]
//        let attributedFont = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 16.0)!]
//        attributedString.addAttribute(NSAttributedString.Key.kern, value: 3, range: NSRange(location: 0, length: attributedString.length))
//        attributedString.addAttributes(attributedStringColor, range: NSRange(location: 0, length: attributedString.length))
//        attributedString.addAttributes(attributedFont, range: NSRange(location: 0, length: attributedString.length))
//        return attributedString
//    }
//
//
//
//    static func setSmallAttributedString(string: String) -> NSAttributedString {
//        let attributedString = NSMutableAttributedString(string: string)
//
//        let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        attributedString.addAttribute(NSAttributedString.Key.kern, value: 2.8, range: NSRange(location: 0, length: attributedString.length))
//        attributedString.addAttributes(attributedStringColor, range: NSRange(location: 0, length: attributedString.length))
//
//        return attributedString
//    }
    
}

extension UIColor {
    static func set(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    static func setPriceUp() -> UIColor {
        return UIColor(red: 255, green: 104 / 255, blue: 104 / 255, alpha: 1)
    }
    
    static func setPriceDown() -> UIColor {
        return UIColor(red: 44 / 255, green: 183 / 255, blue: 164 / 255, alpha: 1)
    }
    
    static func setPriceNormal() -> UIColor {
        return UIColor(red: 99 / 255, green: 186 / 255, blue: 222 / 255, alpha: 1)
    }
    
    //返回隨機顏色
    open class var randomColor:UIColor{
        get
        {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}


// 點擊範圍
class MyButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let margin: CGFloat = 25
        let area = self.bounds.insetBy(dx: -margin, dy: -margin) // 負值是方法響應範圍
        return area.contains(point)
    }
}

// 四捨五入
extension Double {
    func rounding(toDecimal decimal: Int) -> Double {
        let numberOfDigits = pow(10.0, Double(decimal))
        return (self * numberOfDigits).rounded(.toNearestOrAwayFromZero) / numberOfDigits
    }
}

extension String {
    /// 轉換日期格式
    func dateFormatter(sourceDateStr: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        let date = dateFormatter.date(from: sourceDateStr)
        dateFormatter.dateFormat = "yyyy / MM / dd      HH:mm"
        let dateString = dateFormatter.string(from: date!)
        return dateString
    }
    
    // MARK: e-Mail檢查
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
}

extension UIView {
    //設置部分圓角
    func setRoundCorners(corners:UIRectCorner,with radii:CGFloat){
        let bezierpath:UIBezierPath = UIBezierPath.init(roundedRect: (self.bounds), byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let shape:CAShapeLayer = CAShapeLayer.init()
        shape.path = bezierpath.cgPath
        self.layer.mask = shape
    }
}

extension CALayer {
  func applySketchShadow(
    color: UIColor = .set(red: 0, green: 0, blue: 0),
    alpha: Float = 0.17,
    x: CGFloat = 0,
    y: CGFloat = 0.7,
    blur: CGFloat = 9,
    spread: CGFloat = 0)
  {
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}

/// 變更 TabBar 高度
extension UITabBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 60 * screen.height / 736 // 希望的高度
        return sizeThatFits
    }
}

// 變更 NavigationBar 高度 （這個沒反應）
//extension UINavigationBar {
//    open override func sizeThatFits(_ size: CGSize) -> CGSize {
//        return CGSize(width: screen.width, height: 100)
//    }
//}

// 覆寫 UINavigationController 下的 preferredStatusBarStyle 才得以變更 statusBarStyle
extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if let topViewController = presentedViewController{
            return topViewController.preferredStatusBarStyle
        }
        if let topViewController = viewControllers.last {
            return topViewController.preferredStatusBarStyle
        }

        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .lightContent
            // Fallback on earlier versions
        }
    }
}

extension CGSize: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        let size = NSCoder.cgSize(for: value)
    self.init(width: size.width, height: size.height)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        let size = NSCoder.cgSize(for: value)
    self.init(width: size.width, height: size.height)
    }

    public init(unicodeScalarLiteral value: String) {
        let size = NSCoder.cgSize(for: value)
    self.init(width: size.width, height: size.height)
    }
}


// 擴展 UIDevice
extension UIDevice {
    //獲取設備具體詳細型號
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPhone7,2":
            return "iPhone 6"
        case "iPhone7,1":
            return "iPhone 6 Plus"
        case "iPhone8,1":
            return "iPhone 6s"
        case "iPhone8,2":
            return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":
            return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":
            return "iPhone 7 Plus"
        case "iPhone8,4":
            return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":
            return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":
            return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":
            return "iPhone X"
        case "iPhone11,2":
            return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":
            return "iPhone XS Max"
        case "iPhone11,8":
            return "iPhone XR"
        case "iPhone12,1":
            return "iPhone 11"
        case "iPhone12,3":
            return "iPhone 11 Pro"
        case "iPhone12,5":
            return "iPhone 11 Pro Max"
        default: return identifier
        }
    }
}

extension UIColor {
    static func hex(_ val: UInt) -> UIColor {
        var r: UInt = 0, g: UInt = 0, b: UInt = 0;
        var a: UInt = 0xFF
        var rgb = val

        if (val & 0xFFFF0000) == 0 {
            a = 0xF

            if val & 0xF000 > 0 {
                a = val & 0xF
                rgb = val >> 4
            }

            r = (rgb & 0xF00) >> 8
            r = (r << 4) | r

            g = (rgb & 0xF0) >> 4
            g = (g << 4) | g

            b = rgb & 0xF
            b = (b << 4) | b

            a = (a << 4) | a

        } else {
            if val & 0xFF000000 > 0 {
                a = val & 0xFF
                rgb = val >> 8
            }

            r = (rgb & 0xFF0000) >> 16
            g = (rgb & 0xFF00) >> 8
            b = rgb & 0xFF
        }

        //NSLog("r:%X g:%X b:%X a:%X", r, g, b, a)

        return UIColor(red: CGFloat(r) / 255.0,
                       green: CGFloat(g) / 255.0,
                       blue: CGFloat(b) / 255.0,
                       alpha: CGFloat(a) / 255.0)
    }
}

extension UIView {
    // 將當前是圖轉為 UIImage
    func snapImage() -> UIImage {
        let snapImageView = UIImageView()
        snapImageView.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height - 50)
        
        let renderer = UIGraphicsImageRenderer(bounds: snapImageView.frame)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

// 更方便的載入 Nib ViewController
extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
}
