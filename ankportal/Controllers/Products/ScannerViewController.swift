//
//  ScannerViewController.swift
//  Dartz
//
//  Created by Admin on 22/05/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    
//    lazy var restFilter: RESTParameter = {
//        let parameter = RESTParameter(filter: .article, value: "")
//        ankREST.add(parameter: parameter)
//        return parameter
//    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        self.view.addSubview(indicator)
        indicator.center = self.view.center
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.dataMatrix, .ean13]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
//        setupView()
    }
    
    func setupView() {
        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor.blue
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        closeButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }
    
    @objc func dismissViewController() {
        captureSession.stopRunning()
        dismiss(animated: true, completion: nil)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            captureSession.stopRunning()
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            if (metadataObject.type == .ean13) {
                found(code: stringValue)
                print(stringValue)
                return
            }
            found(code2D: stringValue)
            return
        }

        dismiss(animated: true)
    }
    
    func found(code2D: String) {
        ankREST.clearParameters()
        let splittedCode = code2D.split(separator: ";")
        ankREST.add(parameters: (["2369"].mapToRESTParameters(forRESTFilter: .article)))
//        restFilter.set(value: "2369")
        ankREST.execute {[weak self] (data, urlResponse, error) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            if (error != nil) {
                print(error!)
                return
            }
            if let data = try? JSONDecoder().decode([ProductPreview].self, from: data!) {
                self?.captureSession.startRunning()
                let product = ProductProto(name: data[0].name, imagePath: data[0].previewPicture, lotn: splittedCode[1].description, expirationDate: splittedCode[2].description)
                self?.showProductViewProto(product: product)
            }
        }
    }
    
    let ankREST = ANKRESTService(type: .productList)

    func found(code: String) {
        
        ankREST.clearParameters()
        activityIndicator.startAnimating()
        
        var articleArray: [String] = []
        
//        var startIndex = code.index(code.startIndex, offsetBy: 6)
//        var endIndex = code.index(code.startIndex, offsetBy: 11)
//
//        for i in 6...9 {
//            for j in 3...5 {
//                if i+j < code.count {
//                    startIndex = code.index(code.startIndex, offsetBy: i)
//                    endIndex = code.index(code.startIndex, offsetBy: i+j)
//                    let article = code[startIndex...endIndex]
//                    articleArray.append(article.description)
//                    articleArray.append(article.description+"0")
//                    articleArray.append(article.description+"00")
//                }
//            }
//
//        }
        
        articleArray.append(code)

        ankREST.add(parameters: (articleArray.mapToRESTParameters(forRESTFilter: .barcode)))
        
        ankREST.execute {[weak self] (data, urlResponse, error) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            if (error != nil) {
                print(error!)
                return
            }
            if let data = try? JSONDecoder().decode([ProductPreview].self, from: data!) {
                self?.captureSession.startRunning()
                self?.showProductView(product: data[0])
            }
        }
        
    }
    
    func showProductViewProto(product: ProductProto) {
        DispatchQueue.main.async {
            let productInfoViewController = ProductInfoTableViewController()
            productInfoViewController.productId = "6336"
            firstPageController?.navigationController?.pushViewController(productInfoViewController, animated: true)
        }
    }
    
    func showProductView(product: ProductPreview) {
         DispatchQueue.main.async {
            let productInfoViewController = ProductInfoTableViewController()
            productInfoViewController.productId = String(Int(product.id))
            firstPageController?.navigationController?.pushViewController(productInfoViewController, animated: true)
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
