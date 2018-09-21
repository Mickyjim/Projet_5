//
//  UIImagePickerController.swift
//  Instagrid
//
//  Created by Michael Favre on 14/09/2018.
//  Copyright © 2018 Michael Favre. All rights reserved.
//

import UIKit

// Enabling device rotation orientation mode
extension UIImagePickerController {
    open override var shouldAutorotate: Bool { return true }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .all }
}
