//
//  AboutCompanyViewController.swift
//  ankportal
//
//  Created by OlegR on 28.11.2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class AboutCompanyViewController: UIViewController, WKUIDelegate {

    
    var webView: WKWebView!
    var url: String = ""
    
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}
