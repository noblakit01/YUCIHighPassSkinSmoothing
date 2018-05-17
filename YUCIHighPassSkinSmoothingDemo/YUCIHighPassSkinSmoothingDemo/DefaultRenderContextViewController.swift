//
//  DefaultContextViewController.swift
//  YUCIHighPassSkinSmoothingDemo
//
//  Created by YuAo on 1/20/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

import UIKit
import YUCIHighPassSkinSmoothing

class DefaultRenderContextViewController: UIViewController {
    
    let context = CIContext(options: [kCIContextWorkingColorSpace: CGColorSpaceCreateDeviceRGB()])
    let filter = YUCIHighPassSkinSmoothing()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var amountSlider: UISlider!

    var sourceImage: UIImage! {
        didSet {
            self.inputCIImage = CIImage(cgImage: self.sourceImage.cgImage!)
        }
    }
    var processedImage: UIImage?
    
    var inputCIImage: CIImage!
    
    @IBAction func chooseImageBarButtonItemTapped(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.view.backgroundColor = UIColor.white
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sourceImage = UIImage(named: "SampleImage")!
        self.processImage()
    }
    
    @IBAction func amountSliderTouchUp(sender: AnyObject) {
        self.processImage()
    }
    
    func processImage() {
        self.filter.inputImage = self.inputCIImage
        self.filter.inputAmount = self.amountSlider.value as NSNumber
        self.filter.inputRadius = 7.0 * self.inputCIImage.extent.width/750.0 as NSNumber
        let outputCIImage = filter.outputImage!
        
        let outputCGImage = self.context.createCGImage(outputCIImage, from: outputCIImage.extent)
        let outputUIImage = UIImage(cgImage: outputCGImage!, scale: self.sourceImage.scale, orientation: self.sourceImage.imageOrientation)
        
        self.processedImage = outputUIImage
        self.imageView.image = self.processedImage
    }
    
    @IBAction func handleImageViewLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            self.imageView.image = self.sourceImage
        } else if (sender.state == .ended || sender.state == .cancelled) {
            self.imageView.image = self.processedImage
        }
    }
}

extension DefaultRenderContextViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        self.sourceImage = image
        self.processImage()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
