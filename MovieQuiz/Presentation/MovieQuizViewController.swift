import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // массив вопросов

    @IBOutlet private var noButton: UIButton!
    
    @IBOutlet private var yesButton: UIButton!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let userAnswer = true
        guard let currentQuestion = currentQuestion else { return }
        
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let userAnswer = false
        guard let currentQuestion = currentQuestion else { return }
        
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var counterLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let question = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return question
    }
// показ вопроса
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let text = """
                    Ваш результат: \(correctAnswers)/\(questionsAmount) \n
                    Количество сыигранных квизов: \(statisticService.gamesCount) \n
                    Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total)
                    (\(statisticService.bestGame.date.dateTimeString))\n
                    Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                    """
            let viewModel = AlertModel(
                        title: "Этот раунд окончен!",
                        message: text,
                        buttonText: "Сыграть ещё раз",
            completion: {[weak self] _ in
                            guard let self = self else {return}
                            self.currentQuestionIndex = 0
                            self.correctAnswers = 0
                            // заново показываем первый вопрос
                            questionFactory?.requestNextQuestion()
                
            })
//            alert(quiz: viewModel)
            alertPresenter?.showAlert(from: self, quiz: viewModel)
            
        } else {
            currentQuestionIndex += 1
            // идём в состояние "Вопрос показан"
            
            self.questionFactory?.requestNextQuestion()
        }
    }
// показ алерта
//    private func showAlert(quiz result: QuizResultsViewModel) {
//        let alert = UIAlertController(
//            title: result.title,
//            message: result.text,
//            preferredStyle: .alert)
//
//        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
//            guard let self = self else {return}
//            self.currentQuestionIndex = 0
//            self.correctAnswers = 0
//            // заново показываем первый вопрос
//            questionFactory?.requestNextQuestion()
//        }
//
//        alert.addAction(action)
//
//        self.present(alert, animated: true, completion: nil)
//    }
//    покраска рамки взависимости от ответа, переход к следующему вопросу
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        self.yesButton.isEnabled = false
        self.noButton.isEnabled = false
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.imageView.layer.borderColor = UIColor.ypBlack.cgColor
           // код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
            
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            
        }
    
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter()
        statisticService = StatisticServiceImplementation()
//        print(NSHomeDirectory())
//        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let fileName = "inception.json"
//        documentsURL.appendPathComponent(fileName)
//        let jsonString = try? String(contentsOf: documentsURL)
//        guard let data = jsonString?.data(using: .utf8) else {
//            return
//        }
//        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
////            print(json)
//        } catch {
//            print("Failed to parse: \(jsonString)")
//        }
    }
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let questionStep = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: questionStep)
        }
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
