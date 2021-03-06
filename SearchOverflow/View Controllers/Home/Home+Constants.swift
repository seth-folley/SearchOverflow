//
//  Home+Constants.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/13/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import UIKit

typealias Home = Constants.Home

extension Constants {
    struct Home {
        static let cellId = "QuestionCell"
        static let cellAnswerGreen = #colorLiteral(red: 0.2720531821, green: 0.6328938603, blue: 0.3870304227, alpha: 1)
        static let searchingFont = UIFont(name: "AvenirNextCondensed-Medium", size: 21)
        static let placeholderFont = UIFont(name: "AvenirNextCondensed-MediumItalic", size: 21)

        static let selectedCellColor = UIColor(hexString: "dcdde1")
        static let unselectedCellColor = UIColor.white
        
        static let defaultUsername = "No Username"
        static let defaultGravatarName = "DefaultGravatar"
        
        static let navBarColor = #colorLiteral(red: 0.1647058824, green: 0.1803921569, blue: 0.262745098, alpha: 1)
        static let navBarItemTintColor = #colorLiteral(red: 0.9996390939, green: 1, blue: 0.9997561574, alpha: 1)
    }
}
