//
//  UIAlertController.swift
//  Reddit
//
//  Created by Andres Canal on 23/05/2020.
//  Copyright © 2020 Andres Canal. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {

    static func alertWith(title: String?, message: String?, buttonTitle: String) -> UIAlertController {
        let alertController = UIAlertController(
            title: title ?? "",
            message: message ?? "",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default))

        return alertController
    }
}
