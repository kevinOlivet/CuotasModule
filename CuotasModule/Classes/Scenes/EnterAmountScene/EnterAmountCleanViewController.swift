//
//  EnterAmountCleanViewController.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons
import BasicUIElements

protocol EnterAmountCleanDisplayLogic: class {
    func displaySetUpUI(viewModel: EnterAmountClean.Texts.ViewModel)
    func catchCuota(notification: Notification)
    func displayTextFieldWithRegexNumber(viewModel: EnterAmountClean.Regex.ViewModel)
    func showPaymentMethod()
    func displayCatchCuotaAlert(viewModel: EnterAmountClean.CatchNotification.ViewModel)
    func displayInputAlert(viewModel: EnterAmountClean.Errors.ViewModel)
}

public class EnterAmountCleanViewController: BaseViewController, EnterAmountCleanDisplayLogic {
    
    var interactor: EnterAmountCleanBusinessLogic?
    public var router: (NSObjectProtocol & EnterAmountCleanRoutingLogic & EnterAmountCleanDataPassing)?

    var messageView: BottomMessage?
    
    @IBOutlet private weak var enterAmountTextField: UITextField!
    @IBOutlet private weak var enterAmountLabel: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    
    // MARK: Object lifecycle
    
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

    // MARK: View lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        interactor?.prepareSetUpUI(request: EnterAmountClean.Texts.Request())
        setupNotiications()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Methods

    func displaySetUpUI(viewModel: EnterAmountClean.Texts.ViewModel) {
        title = viewModel.title
        enterAmountLabel.text = viewModel.enterAmountLabel
        nextButton.titleLabel?.text = viewModel.nextButton
        nextButton.addTapAction(target: self, action: #selector(nextButtonTapped))
        nextButton.setStyle(.first)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.stop,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }

    private func setupNotiications() {
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: "cuotasFinishedNotification"),
            object: nil,
            queue: nil,
            using: catchCuota
        )
    }

    @objc
    func closeButtonTapped() {
        router?.closeToDashboard()
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
        messageView = BottomMessage(
            withTitle: viewModel.errorTitle,
            andMessage: viewModel.errorMessage,
            buttonText: viewModel.buttonTitle,
            style: .basic,
            headerImage: viewModel.image,
            action: nil,
            self
        )
        guard let messageView = messageView else {
            return
        }
        messageView.elementsAlignment = .center
        view.addSubview(messageView)
    }

    @objc
    func nextButtonTapped() {
        guard let amountEntered = enterAmountTextField.text else  { return }
        let request = EnterAmountClean.EnterAmount.Request(amountEntered: amountEntered)
        interactor?.handleNextButtonTapped(request: request)
    }

    // GettersSetters
    var titleText: String? { self.title }
    var enterAmountLabelText: String? { enterAmountLabel.text }
    var enterAmountTextFieldText: String? {
        get { enterAmountTextField.text}
        set { enterAmountTextField.text = newValue }
    }
    var nextButtonText: String? { nextButton.titleLabel?.text }
}
