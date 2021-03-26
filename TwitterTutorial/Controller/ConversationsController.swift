//
//  ConversationsController.swift
//  TwitterTutorial
//
//  Created by minmin on 2021/03/26.
//

import UIKit

class ConversationsController: UIViewController {
    //MARK: - Properties
    
    
    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
       configureUI()
    }
    
//MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Messages"
        
    }
}
