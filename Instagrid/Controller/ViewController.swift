//
//  ViewController.swift
//  Instagrid
//
//  Created by Michael Favre on 14/08/2018.
//  Copyright © 2018 Michael Favre. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var pattern1: UIButton!
    @IBOutlet weak var pattern2: UIButton!
    @IBOutlet weak var pattern3: UIButton!
    
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var bottomRightButton: UIButton!
    
    @IBOutlet weak var gridView: UIView!
    
    let imagePickerController = UIImagePickerController()
    var tag: Int?
    
    var swipeGesture: UISwipeGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupSwipeDirection), name: .UIDeviceOrientationDidChange, object: nil)
        
    // Gesture Recognizer setup
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        guard let swipeGesture = swipeGesture else { return }
        setupSwipeDirection()
        gridView.addGestureRecognizer(swipeGesture)
        
    }
   
    // Device orientation setup
   @objc func setupSwipeDirection() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
           swipeGesture?.direction = .left
        } else {
            swipeGesture?.direction = .up
        }
    }
    
    // Sharing content with multiple plateforms
    func sharingGridContent() {
        guard let image = gridView.convertToUIImage() else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            self.animationGridViewInitialPosition(duration: 0.5)
        }
    }
    
    // Grid animation
    func animationGridView(duration: Double,x: CGFloat, y: CGFloat, onSuccess: @escaping () -> Void){
        UIView.animate(withDuration: duration, animations: {
            self.gridView.transform = CGAffineTransform(translationX: x, y: y)
        }) { _ in
            onSuccess()
        }
    }
    
    func animationGridViewInitialPosition(duration: Double){
        UIView.animate(withDuration: duration, animations: {
            self.gridView.transform = .identity })
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        
    // Ternary Operator
        //gesture.direction == .up ? print("Up") : print("Left")
        if swipeGesture?.direction == .up {
            animationGridView(duration: 0.5, x: 0, y: -view.frame.height) {
                self.sharingGridContent()
            }
        } else {
            animationGridView(duration: 0.5, x: -view.frame.width, y: 0) {
                self.sharingGridContent()
            }
        }
    }
    
    
    // Setting up the patterns
    @IBAction func patternButtonTapped(_ sender: UIButton) {
        [pattern1, pattern2, pattern3].forEach { $0?.isSelected = false }
        sender.isSelected = true
        switch sender.tag {
       
        // Left button pattern selection
        case 0:
            topRightButton.isHidden = true
            bottomRightButton.isHidden = false
        // Middle button selection
        case 1:
            topRightButton.isHidden = false
            bottomRightButton.isHidden = true
        
        // Right button selection
        case 2:
            topRightButton.isHidden = false
            bottomRightButton.isHidden = false
        
        default:
            break
        }
    }
    
    // Choosing an image to the selected frame
    @IBAction func chooseImage(_ sender: UIButton) {
        tag = sender.tag
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePickerController, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        guard let tag = tag else { return }
        let buttons = [topLeftButton, topRightButton, bottomLeftButton, bottomRightButton]
        buttons[tag]?.setImage(selectedImage, for: .normal)
        buttons[tag]?.imageView?.contentMode = .scaleAspectFill
        buttons[tag]?.imageView?.clipsToBounds = true
    
        dismiss(animated: true, completion: nil)
    }

}


