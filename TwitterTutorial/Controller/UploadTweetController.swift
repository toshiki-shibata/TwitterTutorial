//
//  UploadTweetController.swift
//  TwitterTutorial
//
//  Created by minmin on 2021/09/16.
//

import UIKit



class UploadTweetController: UIViewController {
    
    //MARK:- Properties
    private let user: User
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32/2
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private let captionTextView = CaptionTextView()
    
    //MARK:- LifeCycle
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    
    }
    
    //MARK:- Selectors
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption, type: config) {(error, ref) in
            if let error = error {
                print("DEBUG: Failed to upload with error \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
        if case .reply(let tweet) = self.config{
            NotificationService.shared.uploadNotification(type: .reply, tweet: tweet)
        }
        
    }
    
    //MARK:- API
    
    //MARK:- Helpers
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.alignment = .leading
        imageCaptionStack.spacing = 12
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,right: view.rightAnchor ,paddingTop: 16,paddingLeft: 16, paddingRight: 16)
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        
        replyLabel.isHidden = !viewModel.shouldShoeReplyLabel
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
    }
    
 
    
    private lazy var replyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "replying to @spiderman"
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        //このコードいらない。あると上が黒くなってしまう。
//        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }

    

}
