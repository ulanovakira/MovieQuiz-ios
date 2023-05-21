//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Кира on 07.05.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {              
    func didReceiveNextQuestion(question: QuizQuestion?)
}
