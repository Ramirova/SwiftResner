//
//  ViewController.swift
//  SwiftResnet
//
//  Created by Розалия Амирова on 20/06/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var predictionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    @IBAction func cameraTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel.init(for: Resnet50().model) else { fatalError("Loading CoreML model failed") }
        
        let request = VNCoreMLRequest.init(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else { fatalError("Model failed to process Image") }
            print(results)
            var textResult = ""
            for i in 0...2 {
                textResult += "We detected " + results[i].identifier + " with confidence " + String(results[i].confidence) + "\n"
            }
            self.predictionsLabel.text = textResult
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request] )
        } catch {
            print(error)
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            mainImageView.image = userPickedImage
            guard let ciimage = CIImage.init(image: userPickedImage) else { fatalError("Could not convert to CIImage") }
            detect(image:  ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
}

extension ViewController: UINavigationControllerDelegate {
    
}
