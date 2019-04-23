//
//  HomeViewController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/13/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import UIKit
import Down
import Kingfisher
import NVActivityIndicatorView

class HomeViewController: BaseViewController {
    weak var coordintator: AppCoordinator?
    
    @IBOutlet weak var searchTextField: UITextField?
    @IBOutlet weak var resultsTableView: UITableView?
    @IBOutlet weak var noResultsImage: UIImageView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    lazy var categoryNavButton: QuestionCategoryNavigationButton = {
        let view = QuestionCategoryNavigationButton.instantiateFromNib()!
        view.categoryLabel.text = "Featured"
        return view
    }()
    
    var searchController: SearchController? {
        didSet {
            searchController?.delegate = self
        }
    }

    var questionPages: [[Question]] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryNavButton.sizeToFit()
        navigationItem.titleView = categoryNavButton

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
        let questionNib = UINib(nibName: Home.cellId, bundle: nil)
        resultsTableView?.register(questionNib, forCellReuseIdentifier: Home.cellId)

        resultsTableView?.layer.cornerRadius = 12
        resultsTableView?.layer.masksToBounds = true
        resultsTableView?.backgroundColor = .clear
        let background = UIView(frame: .zero)
        resultsTableView?.backgroundView = background

        resultsTableView?.showsVerticalScrollIndicator = false
        resultsTableView?.dataSource = self
        resultsTableView?.prefetchDataSource = self
        resultsTableView?.delegate = self
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

        searchController?.beginSearch(for: text)
    }
}
