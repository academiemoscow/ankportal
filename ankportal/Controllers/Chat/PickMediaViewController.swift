//
//  PickMediaViewController.swift
//  ankportal
//
//  Created by Admin on 06/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class PickMediaViewController: UIViewController {

    var alertController: UIAlertController?
    var delegate: UIImagePickerControllerDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        present(alertController!, animated: true, completion: nil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        modalPresentationStyle = .overCurrentContext
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController?.addAction(prepareImagePickerAction(forSourceType: .camera, style: .default, title: "Камера"))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alertController?.addAction(prepareImagePickerAction(forSourceType: .photoLibrary, style: .default, title: "Библиотека"))
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) {[weak self] _ in
            self?.dismiss(animated: false, completion: nil)
        }
        alertController?.addAction(cancelAction)
        
    }
    
    private func prepareImagePickerAction(forSourceType type: UIImagePickerController.SourceType, style: UIAlertAction.Style, title: String?) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style) { [weak self] _ in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = type
            imagePicker.delegate = self
            self?.present(imagePicker, animated: true, completion: nil)
        }
        return action
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PickMediaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            self?.dismiss(animated: false) {
                self?.delegate?.imagePickerController!(picker, didFinishPickingMediaWithInfo: info)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {[weak self] in
            self?.dismiss(animated: false) {
                self?.delegate?.imagePickerControllerDidCancel!(picker)
            }
        }
    }
}
