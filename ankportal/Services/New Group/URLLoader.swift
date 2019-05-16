//
//  ImageStorage.swift
//  ankportal
//
//  Created by Admin on 16/05/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class URLLoader: NSObject {
    
    var delegate: URLSessionDownloadDelegate?
    
    init(delegate: URLSessionDownloadDelegate) {
        self.delegate = delegate
    }
    
    func load(forPath path: URL) {
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let downloadTask = urlSession.downloadTask(with: path)
        downloadTask.resume()
    }
}

extension URLLoader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        delegate?.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        delegate?.urlSession?(session, task: task, didCompleteWithError: error)
    }
}
