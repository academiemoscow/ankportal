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
    
    
    
    let ankREST = ANKRESTService(type: .productList)
    lazy var restFilter: RESTParameter = {
        let parameter = RESTParameter(filter: .article, value: "")
        ankREST.add(parameter: parameter)
        return parameter
    }()
    
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
            metadataOutput.metadataObjectTypes = [.dataMatrix]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        setupView()
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
                return
            }
            found(code2D: stringValue)
            return
        }

        dismiss(animated: true)
    }
    
    func found(code2D: String) {
        let splittedCode = code2D.split(separator: ";")
        restFilter.set(value: "2369")
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
    
    func found(code: String) {
        activityIndicator.startAnimating()
        let startIndex = code.index(code.startIndex, offsetBy: 6)
        let endIndex = code.index(code.startIndex, offsetBy: 11)
        let article = code[startIndex...endIndex]
        restFilter.set(value: article.description)
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
    
    func showProductViewProto(product: ProductProto){
        let vc = ProductViewPopupViewControllerProto()
        vc.product = product
        vc.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func showProductView(product: ProductPreview) {
        let vc = ProductViewPopupViewController()
        vc.product = product
        vc.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
