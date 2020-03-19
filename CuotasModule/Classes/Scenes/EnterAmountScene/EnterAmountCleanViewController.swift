//
//  EnterAmountCleanViewController.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import Commons

protocol EnterAmountCleanDisplayLogic: class {
    func setUpUI()
    func catchCuota(notification: Notification)
    func setTextFieldWithRegexNumber(numberToUse: String)
    func showPaymentMethod(amountEntered: Int)
    func displayEnterAmountAlert(viewModel: EnterAmountClean.EnterAmount.ViewModel.Failure)
    func displayCatchCuotaAlert(viewModel: EnterAmountClean.EnterAmount.ViewModel.TotalSuccess)
    func displayNumberToUseAlert(viewModel: EnterAmountClean.EnterAmount.ViewModel.Failure)
    func nextButtonTapped(_ sender: Any)
}

public class EnterAmountCleanViewController: UIViewController, EnterAmountCleanDisplayLogic {
    
    var interactor: EnterAmountCleanBusinessLogic?
    public var router: (NSObjectProtocol & EnterAmountCleanRoutingLogic & EnterAmountCleanDataPassing)?
    
    //@IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var enterAmountTextField: UITextField!
    @IBOutlet weak var enterAmountLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = EnterAmountCleanInteractor()
        let presenter = EnterAmountCleanPresenter()
        let router = EnterAmountCleanRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Do something
    
    func setUpUI() {
        self.title = "Amount".localized()
        enterAmountLabel.text = "Enter amount in Chilean Pesos".localized()
        nextButton.titleLabel?.text = "Next".localized()
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "cuotasFinishedNotification"),
                                               object: nil,
                                               queue: nil,
                                               using: catchCuota)
    }
    
    func catchCuota(notification: Notification) {
        interactor?.catchCuota(notification: notification)
    }
    
    func setTextFieldWithRegexNumber(numberToUse: String) {
        enterAmountTextField.text = numberToUse
    }
    
    func showPaymentMethod(amountEntered: Int) {
        router?.routeToPaymentMethod()
    }
    
    // Replace messages with viewModels
    func displayEnterAmountAlert(viewModel: EnterAmountClean.EnterAmount.ViewModel.Failure) {
        Alerts.dismissableAlert(title: viewModel.errorTitle,
                                message: viewModel.errorMessage,
                                vc: self,
                                actionBtnText: viewModel.buttonTitle)
    }
    
    func displayCatchCuotaAlert(viewModel: EnterAmountClean.EnterAmount.ViewModel.TotalSuccess) {
        router?.routeToRootViewController()
        Alerts.dismissableAlert(title: viewModel.successTitle,
                                message: viewModel.successMessage,
                                vc: self,
                                actionBtnText: viewModel.buttonTitle)
    }
    
    func displayNumberToUseAlert(viewModel: EnterAmountClean.EnterAmount.ViewModel.Failure) {
        Alerts.dismissableAlert(title: viewModel.errorTitle,
                                message: viewModel.errorMessage,
                                vc: self,
                                actionBtnText: viewModel.buttonTitle)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let amountEntered = enterAmountTextField.text else  { return }
        interactor?.handleNextButtonTapped(amountEntered: amountEntered)
    }
}
