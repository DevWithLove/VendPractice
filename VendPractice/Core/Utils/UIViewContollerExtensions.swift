//
//  UIViewContollerExtensions.swift
//  VendPractice
//
//  Created by Tony Mu on 25/06/21.
//

import UIKit

extension UIViewController {
    func presentMessage(message: String, title: String = "", completion:(() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizableString.buttonOk, style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: completion)
    }
}
