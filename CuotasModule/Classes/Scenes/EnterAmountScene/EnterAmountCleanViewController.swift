//
//  EnterAmountCleanViewController.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons

protocol EnterAmountCleanDisplayLogic: class {
    func displaySetUpUI(viewModel: EnterAmountClean.Texts.ViewModel)
    func catchCuota(notification: Notification)
    func displayTextFieldWithRegexNumber(viewModel: EnterAmountClean.Regex.ViewModel)
    func showPaymentMethod()
    func displayCatchCuotaAlert(viewModel: EnterAmountClean.CatchNotification.ViewModel)
    func displayInputAlert(viewModel: EnterAmountClean.Errors.ViewModel)
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
        interactor?.prepareSetUpUI(request: EnterAmountClean.Texts.Request())
        setupNotiications()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Do something

    func displaySetUpUI(viewModel: EnterAmountClean.Texts.ViewModel) {
        title = viewModel.title
        enterAmountLabel.text = viewModel.enterAmountLabel
        nextButton.titleLabel?.text = viewModel.nextButton
    }

    private func setupNotiications() {
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: "cuotasFinishedNotification"),
            object: nil,
            queue: nil,
            using: catchCuota
        )
    }
    
    func catchCuota(notification: Notification) {
        let request = EnterAmountClean.CatchNotification.Request(notification: notification)
        interactor?.catchCuota(request: request)
    }
    
    func displayTextFieldWithRegexNumber(viewModel: EnterAmountClean.Regex.ViewModel) {
        enterAmountTextField.text = viewModel.numberToUse
    }
    
    func showPaymentMethod() {
        router?.routeToPaymentMethod()
    }

    func displayCatchCuotaAlert(viewModel: EnterAmountClean.CatchNotification.ViewModel) {
        router?.routeToRootViewController()
        Alerts.dismissableAlert(
            title: viewModel.successTitle,
            message: viewModel.successMessage,
            vc: self,
            actionBtnText: viewModel.buttonTitle
        )
    }
    
    func displayInputAlert(viewModel: EnterAmountClean.Errors.ViewModel) {
        Alerts.dismissableAlert(
            title: viewModel.errorTitle,
            message: viewModel.errorMessage,
            vc: self,
            actionBtnText: viewModel.buttonTitle
        )
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let amountEntered = enterAmountTextField.text else  { return }
        let request = EnterAmountClean.EnterAmount.Request(amountEntered: amountEntered)
        interactor?.handleNextButtonTapped(request: request)
    }
}
