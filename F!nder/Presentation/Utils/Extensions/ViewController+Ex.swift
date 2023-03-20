//
//  ViewController+Ex.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/10.
//

import Foundation
import UIKit

extension UIViewController {

    /// PopUp1 띄워 줌
    func showPopUp1(title: String, message: String, buttonText: String, buttonAction: @escaping () -> Void) {
        let popUp = Popup1ViewController(title: title,
                                         message: message,
                                         buttonText: buttonText,
                                         buttonAction: buttonAction)

        present(popUp, animated: false)
    }
    
    func showPopUp2(title: String, message: String,
                    leftButtonText: String, rightButtonText: String,
                    leftButtonAction: @escaping () -> Void, rightButtonAction: @escaping () -> Void) {

        let popUp = Popup2ViewController(title: title, message: message,
                                         leftButtonText: leftButtonText,
                                         rightButtonText: rightButtonText,
                                         leftButtonAction: leftButtonAction,
                                         rightButtonAction: rightButtonAction)

        present(popUp, animated: false)
    }
}
