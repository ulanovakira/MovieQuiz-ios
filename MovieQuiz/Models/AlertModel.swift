//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Кира on 08.05.2023.
//

import Foundation
import UIKit

struct AlertModel {
    // строка заголовка
    let title: String
    // текст сообщения
    let message: String
    // текст для кнопки
    let buttonText: String
    // замыкание без параметров для действияя по кнопке алерта
    let completion:((UIAlertAction) -> ())?
    
}
