//
//  ViewController.swift
//  Instagrid
//
//  Created by Michael Favre on 14/08/2018.
//  Copyright © 2018 Michael Favre. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    // Links between from storyboard to controller with outlets
    @IBOutlet weak var pattern1: UIButton!
    @IBOutlet weak var pattern2: UIButton!
    @IBOutlet weak var pattern3: UIButton!
    
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var bottomRightButton: UIButton!
    
    @IBOutlet weak var gridView: UIView!
    
    // MARK: - Variables
    private let imagePickerController = UIImagePickerController()
    private var tag: Int?
    private var swipeGesture: UISwipeGestureRecognizer?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBehaviors()
        setupGestures()
    }
    
    // MARK: - Class methods
    // METHOD: UIGestureRecognizer
    private func setupGestures() {
        // Resetting images with UITapGestureRecognizer
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(tapToErase))
        doubleTap.numberOfTapsRequired = 2
        gridView.addGestureRecognizer(doubleTap)
        
        // Gesture Recognizer setup with UISwipeGestureRecognizer
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        guard let swipeGesture = swipeGesture else { return }
        setupSwipeDirection()
        gridView.addGestureRecognizer(swipeGesture)
        
        // Notification setup with NotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(setupSwipeDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func setupBehaviors() {
        imagePickerController.delegate = self
        topRightButton.isHidden = false
        bottomRightButton.isHidden = true
    }
    
   @objc private func tapToErase() {
        [topLeftButton, topRightButton, bottomLeftButton, bottomRightButton].forEach {$0?.setImage(UIImage(named: "Combined Shape"), for: .normal)}
    }
    
    // Device orientation setup
   @objc private func setupSwipeDirection() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
           swipeGesture?.direction = .left
        } else {
            swipeGesture?.direction = .up
        }
    }
    
    // Sharing content with multiple plateforms
    private func sharingGridContent() {
        guard let image = gridView.convertToUIImage() else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            self.animationGridViewInitialPosition(duration: 0.5)
        }
    }
    
    // Grid animation
    private func animationGridView(duration: Double,x: CGFloat, y: CGFloat, onSuccess: @escaping () -> Void){
        UIView.animate(withDuration: duration, animations: {
            self.gridView.transform = CGAffineTransform(translationX: x, y: y)
        }) { _ in
            onSuccess()
        }
    }
    
    // Grid animation returning to initial position
    private func animationGridViewInitialPosition(duration: Double){
        UIView.animate(withDuration: duration, animations: {
            self.gridView.transform = .identity })
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        
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
    
    // MARK: - Actions
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
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(imagePickerController, animated: true)
    }
}

// MARK: - UIImagePickerController
extension ViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // Image picker setup for selection of chosen images
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let tag = tag else { return }
        let buttons = [topLeftButton, topRightButton, bottomLeftButton, bottomRightButton]
        buttons[tag]?.setImage(selectedImage, for: .normal)
        buttons[tag]?.imageView?.contentMode = .scaleAspectFill
        buttons[tag]?.imageView?.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
}
