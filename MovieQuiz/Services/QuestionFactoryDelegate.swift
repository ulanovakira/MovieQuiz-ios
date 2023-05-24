//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Кира on 07.05.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {              
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    func didFailToLoadImage(with error: String) // сообщение об ошибке загрузки
}
