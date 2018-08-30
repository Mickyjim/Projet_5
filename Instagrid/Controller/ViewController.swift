//
//  ViewController.swift
//  Instagrid
//
//  Created by Michael Favre on 14/08/2018.
//  Copyright © 2018 Michael Favre. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pattern1: UIButton!
    @IBOutlet weak var pattern2: UIButton!
    @IBOutlet weak var pattern3: UIButton!
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var bottomRightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func patternButtonTapped(_ sender: UIButton) {
        [pattern1, pattern2, pattern3].forEach { $0?.isSelected = false }
        sender.isSelected = true
        switch sender.tag {
        case 0:
            topRightButton.isHidden = true
        case 1:
            print("pattern2")
        case 2:
            print("pattern3")
        default:
            break
        }
    }
    
}

