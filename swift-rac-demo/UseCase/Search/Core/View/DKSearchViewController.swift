//
// Created by Denis Kapusta on 12/25/16.
// Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class DKSearchViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var retryButton: UIButton!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: DKSearchViewModel = DKSearchModuleBuilder.sharedInstance.viewModel
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
}

// MARK: - RAC Bindings
extension DKSearchViewController {
    func setupBindings() {

        resultLabel.reactive.text <~ viewModel.resultText
        resultLabel.reactive.isHidden <~ viewModel.isSearching

        activityIndicator.reactive.isAnimating <~ viewModel.isSearching
        activityIndicator.reactive.isHidden <~ viewModel.isSearching.map{ !$0 }

        cancelButton.reactive.isEnabled <~ viewModel.isSearching
        retryButton.reactive.isHidden <~ viewModel.searchFailed.map{ !$0 }
        
        cancelButton.reactive.pressed = CocoaAction(viewModel.cancelSearch)
        retryButton.reactive.pressed = CocoaAction(viewModel.retrySearch)
        
        viewModel.searchText <~ inputTextField.reactive.continuousTextValues.skipNil()
    }
}


