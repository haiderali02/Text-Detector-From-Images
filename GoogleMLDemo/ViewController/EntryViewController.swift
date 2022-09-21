//
//  ViewController.swift
//  GoogleMLDemo
//
//  Created by Haider Ali on 21/09/2022.
//

import UIKit
import MLImage
import MLKit
import AVFoundation
import Vision
import VisionKit

class EntryViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var resultsText: String = ""
    
    let mediaPicker = MediaPicker()
    // let vision = Vision.vision()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

   
    
    private func process(_ visionImage: VisionImage, with textRecognizer: TextRecognizer?) {
      weak var weakSelf = self
      textRecognizer?.process(visionImage) { text, error in
        guard let strongSelf = weakSelf else {
          print("Self is nil!")
          return
        }
        guard error == nil, let text = text else {
          let errorString = error?.localizedDescription ?? "Failed To Read Text"
          strongSelf.resultsText = "Text recognizer failed with error: \(errorString)"
          strongSelf.showResults()
          return
        }
        // Blocks.
        for block in text.blocks {
          // Lines.
          for line in block.lines {
            let transformedRect = line.frame.applying(strongSelf.transformMatrix())

            // Elements.
            for element in line.elements {
              print("Element: \(element)")
            }
          }
        }
        strongSelf.resultsText += "\(text.text)\n"
          
          let resultsVC = self.storyboard?.instantiateViewController(withIdentifier: "DetetctedTextViewController") as! DetetctedTextViewController
          resultsVC.textDetected = strongSelf.resultsText
          self.navigationController?.pushViewController(resultsVC, animated: true)
          
        // strongSelf.showResults()
      }
    }
     
    /// Detects text on the specified image and draws a frame around the recognized text using the
    /// On-Device text recognizer.
    ///
    /// - Parameter image: The image.
    private func detectTextOnDevice(image: UIImage?) {
        guard let image = image else { return }
        
        let options = TextRecognizerOptions.init()
        
        let onDeviceTextRecognizer = TextRecognizer.textRecognizer(options: options)
        // [END init_text]
        
        // Initialize a `VisionImage` object with the given `UIImage`.
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        // self.resultsText += "Running On-Device Text Recognition...\n"
        process(visionImage, with: onDeviceTextRecognizer)
    }
    
    
    private func showResults() {
      let resultsAlertController = UIAlertController(
        title: "Detection Results",
        message: nil,
        preferredStyle: .actionSheet
      )
      resultsAlertController.addAction(
        UIAlertAction(title: "OK", style: .destructive) { _ in
          resultsAlertController.dismiss(animated: true, completion: nil)
        }
      )
      resultsAlertController.message = resultsText
      present(resultsAlertController, animated: true, completion: nil)
      print(resultsText)
    }
    
    
    private func transformMatrix() -> CGAffineTransform {
      guard let image = imageView.image else { return CGAffineTransform() }
      let imageViewWidth = imageView.frame.size.width
      let imageViewHeight = imageView.frame.size.height
      let imageWidth = image.size.width
      let imageHeight = image.size.height

      let imageViewAspectRatio = imageViewWidth / imageViewHeight
      let imageAspectRatio = imageWidth / imageHeight
      let scale =
        (imageViewAspectRatio > imageAspectRatio)
        ? imageViewHeight / imageHeight : imageViewWidth / imageWidth

      // Image view's `contentMode` is `scaleAspectFit`, which scales the image to fit the size of the
      // image view by maintaining the aspect ratio. Multiple by `scale` to get image's original size.
      let scaledImageWidth = imageWidth * scale
      let scaledImageHeight = imageHeight * scale
      let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
      let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)

      var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
      transform = transform.scaledBy(x: scale, y: scale)
      return transform
    }
    
    private func clearResults() {
      self.resultsText = ""
    }
    
    // MARK: - ACTIONS -
    
    @IBAction func didTapChoosPhoto(_ sender: UIButton) {
        mediaPicker.showPicker(self) { items, cancelled in
            
            if let signlePhoto = items.singlePhoto {
                self.imageView.image = signlePhoto.image
            }
            
        }
    }
    
    
    @IBAction func didTapDetectText(_ sender: UIButton) {
        
        clearResults()
        
        guard let image = self.imageView.image else {return}
        
        self.detectTextOnDevice(image: image)
   
    }
}

