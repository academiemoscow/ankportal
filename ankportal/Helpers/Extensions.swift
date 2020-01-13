//
//  Extensions.swift
//  ankportal
//
//  Created by Admin on 22/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
import ESTabBarController_swift

extension UIAlertController {
    static func displayError(withTitle title: String, withErrorText error: String, presentIn view: UIViewController) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            view.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIColor {
    static let ballonBlue: UIColor = UIColor(r: 0, g: 134, b: 181)
    static let ballonGrey: UIColor = UIColor(r: 245, g: 245, b: 245)
    static let emeraldGreen: UIColor = UIColor(r: 80, g: 200, b: 120)
    static let ankPurple: UIColor = UIColor.white//(r: 159, g: 131, b: 174)
    static let ankDarkPurple: UIColor = UIColor(r: 129, g: 111, b: 154)
    
    static let backgroundColor: UIColor = UIColor.white//(r: 250, g: 250, b: 250)
    static let sectionUnderlineColor: UIColor = UIColor(r: 200, g: 200, b: 200)
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension NSNumber {
    
    static func intervalSince1970() -> NSNumber {
        return NSNumber(value: Date().timeIntervalSince1970)
    }
    
}

extension UIImage {
    
    struct Icons {
        static let minusRound = UIImage(named: "iconMinusRound")!.withRenderingMode(.alwaysTemplate)
        static let plusRound = UIImage(named: "iconPlusRound")!.withRenderingMode(.alwaysTemplate)
        static let bag = UIImage(named: "bag")!.withRenderingMode(.alwaysTemplate)
    }
    
    static let placeholder = UIImage(named: "photography")?.withRenderingMode(.alwaysTemplate)
    
    public enum ImageRegion {
        case leftHalf
        case rightHalf
        case topHalf
        case bottomHalf
    }
    
    public func portraitOriented() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let portraitOrientedImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return portraitOrientedImage
        }
        return self
    }
    
    public func flip(toOrientation orientation: UIImage.Orientation, withScale scale: CGFloat) -> UIImage {
        return UIImage(cgImage: cgImage!, scale: scale, orientation: orientation)
    }
    
    public func cropping(to: UIImage.ImageRegion) -> UIImage {
        guard let cgImage = cgImage else {
            return self
        }
        
        let croppingRect = makeCGRect(forRegion: to)
        
        guard let croppedImage = cgImage.cropping(to: croppingRect) else {
            return self
        }
        
        return UIImage(cgImage: croppedImage)
    }
    
    private func makeCGRect(forRegion region: ImageRegion) -> CGRect {
        switch region {
        case .topHalf:
            return CGRect(
                x: .zero,
                y: .zero,
                width: size.width,
                height: size.height / 2
            )
        case .bottomHalf:
            return CGRect(
                x: .zero,
                y: size.height / 2,
                width: size.width,
                height: size.height / 2
            )
        case .leftHalf:
            return CGRect(
                x: .zero,
                y: .zero,
                width: size.width / 2,
                height: size.height
            )
        case .rightHalf:
            return CGRect(
                x: size.width / 2,
                y: .zero,
                width: size.width / 2,
                height: size.height
            )
        }
    }
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
}

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}

extension String {
    
    var encodeURL: String {
        get {
            return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
    }
    
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension UIView {
    
    func firstAvailableViewController() -> UIViewController? {
        var parent: UIResponder = self
        while let responder = parent.next {
            if responder.isKind(of: UIViewController.self) {
                return responder as? UIViewController
            }
            parent = responder
        }
        return nil
    }
    
    func makeShadow(color: UIColor = UIColor.black, opacity: Float = 0.5, offset: CGSize = CGSize(width: -1, height: 1), radius: CGFloat = 5) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    func addInnerShadow(to edges:[UIRectEdge], size: CGSize, radius:CGFloat){
        
        let toColor = self.backgroundColor!
        let fromColor = UIColor(red: 188.0/255.0, green: 188.0/255.0, blue: 188.0/255.0, alpha: 1.0)
        let viewFrame = size
        for edge in edges{
            let gradientlayer          = CAGradientLayer()
            gradientlayer.colors       = [fromColor.cgColor,toColor.cgColor]
            gradientlayer.shadowRadius = radius
            
            switch edge {
            case UIRectEdge.top:
                gradientlayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientlayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                gradientlayer.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: gradientlayer.shadowRadius)
            case UIRectEdge.bottom:
                gradientlayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientlayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                gradientlayer.frame = CGRect(x: 0.0, y: viewFrame.height - gradientlayer.shadowRadius, width: viewFrame.width, height: gradientlayer.shadowRadius)
            case UIRectEdge.left:
                gradientlayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientlayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                gradientlayer.frame = CGRect(x: 0.0, y: 0.0, width: gradientlayer.shadowRadius, height: viewFrame.height)
            case UIRectEdge.right:
                gradientlayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientlayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                gradientlayer.frame = CGRect(x: viewFrame.width - gradientlayer.shadowRadius, y: 0.0, width: gradientlayer.shadowRadius, height: viewFrame.height)
            default:
                break
            }
            self.layer.addSublayer(gradientlayer)
        }
        
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func removeAllSublayers(){
        if let sublayers = self.layer.sublayers, !sublayers.isEmpty{
            for sublayer in sublayers{
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
}

extension UIView {
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
}

extension UIFont {
    
    static func boldSystemFont(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        let textSize = UIFont.preferredFont(forTextStyle: textStyle).pointSize
        return UIFont.boldSystemFont(ofSize: textSize)
    }
    
    /**
     MyriadPro light
    */
    static func defaultFont(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "MyriadPro-Regular", size: size)
    }
    
    static func defaultFontBold(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "MyriadPro-Bold", size: size)
    }
    
    static func defaultFont(forTextStyle textStyle: UIFont.TextStyle ) -> UIFont? {
        let textSize = UIFont.preferredFont(forTextStyle: textStyle).pointSize
        return UIFont.defaultFont(ofSize: textSize)
    }
    
    static func defaultFontBold(forTextStyle textStyle: UIFont.TextStyle ) -> UIFont? {
        let textSize = UIFont.preferredFont(forTextStyle: textStyle).pointSize
        return UIFont.defaultFontBold(ofSize: textSize)
    }
}

extension Collection where Element: CustomStringConvertible {
    
    func uniqueElementsCount() -> Int {
        var uniqueStringsArray = [String]()
        self.forEach { (element) in
            if ( !uniqueStringsArray.contains("\(element)") ) {
                uniqueStringsArray.append("\(element)")
            }
        }
        return uniqueStringsArray.count
    }
    
    func mapToRESTParameterArray(forRESTFilter restFilter: RESTFilter) -> [RESTParameter] {
        return self.map({ (element) -> RESTParameter in
            return RESTParameter(name: "\(restFilter.rawValue)[]", value: "\(element)")
        })
    }
    
    func mapToRESTParameters(forRESTFilter restFilter: RESTFilter) -> [RESTParameter] {
        return self.map({ (element) -> RESTParameter in
            return RESTParameter(name: "\(restFilter.rawValue)", value: "\(element)")
        })
    }
}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return nil
    }
}

class CurrencyFormatter: NumberFormatter {
    
    override init() {
        super.init()
        
        self.currencySymbol = ""
        self.minimumFractionDigits = 0
        self.numberStyle = .currencyAccounting
    }
    
    convenience init(locale: String) {
        self.init()
        self.locale = Locale(identifier: locale)
    }
    
    convenience init(maximumFractionDigits: Int) {
        self.init()
        self.maximumFractionDigits = maximumFractionDigits
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beautify(_ price: Double) -> String {
        let formatted = self.string(from: NSNumber(value: price))!
        
        // Fixes an extra space that is left sometimes at the end of the string
        return formatted.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
}

extension Array where Element == RESTParameter {
    static func == (left: [RESTParameter], right: [RESTParameter]) -> Bool {
        guard left.count == right.count else {
            return false
        }
        guard left.count > 0 else {
            return true
        }
        for leftRESTParameter in left {
            var flag = false
            for rightRESTParameter in right {
                if ( leftRESTParameter == rightRESTParameter ) {
                    flag = true
                    break
                }
            }
            guard flag == true else {
                return false
            }
        }
        return true
    }
 }

class StrikeThroughLabel: UILabel {
    override var text: String? {
        didSet {
            guard let text = text else {
                return
            }
            let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.strikethroughStyle: 2])
            self.attributedText = attributedString
        }
    }
}

extension URL {
    static func ankportalURL(withType type: ANKRESTServiceType, _ parameters: [RESTParameter]) -> URL? {
        let service = ANKRESTService(type: type, parameters: parameters)
        return URL(string: service.serialize())
    }
}

extension ESTabBarController {
    
    func presentProductViewController(withFilters filters: [RESTParameter]) {
        if let productViewController = findViewController(type: ProductsTableViewController()) {
            productViewController.optionalRESTFilters = filters
            if productViewController.parent == self {
                selectedViewController = productViewController
            } else {
                selectedViewController = productViewController.parent
            }
            productViewController.fetchData()
            productViewController.tableView.scrollToRow(at: [0, 0], at: .top, animated: false)
        }
    }
    
    func openChat() {
        if let chatLogController = findViewController(type: ChatLogController()) {
            if chatLogController.parent == self {
                selectedViewController = chatLogController
            } else {
                selectedViewController = chatLogController.parent
            }
        }
    }
    
    func openMain() {
        if let chatLogController = findViewController(type: MainPageViewController()) {
            if chatLogController.parent == self {
                selectedViewController = chatLogController
            } else {
                selectedViewController = chatLogController.parent
            }
        }
    }
    
    func getMainPageController() -> MainPageViewController? {
        return findViewController(type: MainPageViewController())
    }
    
    private func findViewController<T>(type: T) -> T? {
        if let productViewControllers = viewControllers?
            .map({ (viewController) -> T? in
                if let productViewController = viewController as? T { return productViewController }
                if let navController = viewController as? UINavigationController {
                    if let productViewController = navController.viewControllers.first as? T {
                        return productViewController
                    }
                }
                return nil
            })
            .filter({ $0 != nil })
        {
            return productViewControllers.first!
        }
        return nil
    }
    
}
