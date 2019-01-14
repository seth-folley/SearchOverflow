//
//  HomeViewController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/13/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField?
    @IBOutlet weak var resultsTableView: UITableView?

    let networkManager = NetworkManager(with: NetworkRouter())
    private var questions: [Question] = [] {
        didSet {
            resultsTableView?.reloadData()
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }

    private func configureViews() {
        // Search text field setup
        searchTextField?.delegate = self
        searchTextField?.borderStyle = .none
        searchTextField?.layer.cornerRadius = 15
        searchTextField?.layer.masksToBounds = true

        // Add padding to left side of text field
        let padding = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 15, height: 30)))
        searchTextField?.leftView = padding
        searchTextField?.leftViewMode = .always

        // Results table setup
        let questionNib = UINib(nibName: "QuestionCell", bundle: nil)
        resultsTableView?.register(questionNib, forCellReuseIdentifier: "QuestionCell")

        resultsTableView?.backgroundColor = .clear
        let background = UIView(frame: .zero)
        resultsTableView?.backgroundView = background
        resultsTableView?.dataSource = self
        resultsTableView?.delegate = self
    }
}

// MARK: - Table View
// MARK: Datasource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell") as? QuestionCell else { return UITableViewCell() }

        let question = questions[indexPath.item]

        cell.usernameLabel?.text = question.owner?.displayName ?? "No Username"
        cell.questionTitleLabel?.text = question.title
        cell.bodyTextField?.text = question.body
        cell.viewsLabel?.text = "\(question.viewCount)"
        cell.answersLabel?.text = "\(question.answerCount)"
        cell.scoreLabel?.text = "\(question.score)"

        let bgView = UIView(frame: .zero)
        bgView.backgroundColor = .clear
        cell.backgroundView = bgView

        cell.background.layer.cornerRadius = 25
        cell.background.layer.masksToBounds = true
        
        return cell
    }
}

// MARK: Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - Text Field Delegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismisses the keyboard
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let text = textField.text, text.count > 0 else { return }

        networkManager.search(for: text) { [weak self] questions, error in

            let questionsSorted = questions.sorted(by: { $0.score > $1.score })
            DispatchQueue.main.async {
                self?.questions = questionsSorted
            }
        }
    }
}
