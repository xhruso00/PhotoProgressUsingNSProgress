/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
                PhotoCollectionViewCell is a UICollectionViewCell subclass that shows a Photo.
            
*/

import UIKit

/// The KVO context used for all `PhotoCollectionViewCell` instances.
private var photoCollectionViewCellObservationContext = 0

class PhotoCollectionViewCell: UICollectionViewCell {
    // MARK: Properties

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var progressView: UIProgressView!

    fileprivate let fractionCompletedKeyPath = "photoImport.progress.fractionCompleted"

    fileprivate let imageKeyPath = "image"

    fileprivate var fractionCompletedObservation: NSKeyValueObservation?
    fileprivate var photoImportObservation: NSKeyValueObservation?
    fileprivate var imageObservation: NSKeyValueObservation?
    
    var photo: Photo? {
        willSet {
            photoImportObservation?.invalidate()
            fractionCompletedObservation?.invalidate()
            imageObservation?.invalidate()
            
//            if let formerPhoto = photo {
//                formerPhoto.removeObserver(self, forKeyPath: fractionCompletedKeyPath, context: &photoCollectionViewCellObservationContext)
//                formerPhoto.removeObserver(self, forKeyPath: imageKeyPath, context: &photoCollectionViewCellObservationContext)
//            }
        }

        didSet {
            if let newPhoto = photo {
                
                fractionCompletedObservation = newPhoto.observe(\.photoImport?.progress.fractionCompleted) { [weak self] photo, photoImport  in
                    
                    self?.updateProgressView()
                }
                imageObservation = newPhoto.observe(\Photo.image) { [weak self] _,_ in
                    self?.updateImageView()
                }
//                newPhoto.addObserver(self, forKeyPath: fractionCompletedKeyPath, options: [], context: &photoCollectionViewCellObservationContext)
//                newPhoto.addObserver(self, forKeyPath: imageKeyPath, options: [], context: &photoCollectionViewCellObservationContext)
            }

            updateImageView()
            updateProgressView()
        }
    }
    
    fileprivate func updateProgressView() {
        DispatchQueue.main.async {
            if let photoImport = self.photo?.photoImport {
                let fraction = Float(photoImport.progress.fractionCompleted)
                self.progressView.progress = fraction
                self.progressView.isHidden = false
            }
            else {
                self.progressView.isHidden = true
            }
        }
    }

    fileprivate func updateImageView() {
        DispatchQueue.main.async {
            UIView.transition(with: self.imageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.imageView.image = self.photo?.image
            }, completion: nil)
        }
    }
    
    // MARK: Key-Value Observing
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
//        guard context == &photoCollectionViewCellObservationContext else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//            return
//        }
//        
//        OperationQueue.main.addOperation {
//            if keyPath == self.fractionCompletedKeyPath {
//                self.updateProgressView()
//            }
//            else if keyPath == self.imageKeyPath {
//                self.updateImageView()
//            }
//        }
//    }
}
