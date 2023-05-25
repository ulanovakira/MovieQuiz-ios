//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Кира on 08.05.2023.
//

import Foundation
import UIKit

class AlertPresenter {
    
    func showAlert(from viewController: UIViewController, quiz result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "GameResults"
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: result.completion)
        
        alert.addAction(action)

        viewController.present(alert, animated: true, completion: nil)
    }
}
