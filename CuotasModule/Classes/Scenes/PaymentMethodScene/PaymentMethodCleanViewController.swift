//
//  PaymentMethodCleanViewController.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons
import BasicUIElements
import Alamofire
import AlamofireImage

protocol PaymentMethodCleanDisplayLogic: class {
    func displaySetupUI(viewModel: PaymentMethodClean.Texts.ViewModel)
    func displayLoadingView()
    func hideLoadingView()
    func displayErrorAlert(viewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.Failure)
    func displayAmountErrorAlert(viewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.AmountFailure)
    func displayPaymentMethodArray(viewModel: PaymentMethodClean.PaymentMethods.ViewModel)
    func showBankSelect(viewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.Success)
}

class PaymentMethodCleanViewController: BaseViewController, PaymentMethodCleanDisplayLogic {
    
    var interactor: (PaymentMethodCleanBusinessLogic & PaymentMethodCleanDataStore)?
    var router: (NSObjectProtocol & PaymentMethodCleanRoutingLogic & PaymentMethodCleanDataPassing)?
    var messageView: BottomMessage?

    var paymentMethodsToDisplay: [PaymentMethodClean.PaymentMethods.ViewModel.DisplayPaymentMethodViewModelSuccess] = []

    @IBOutlet private weak var paymentTableView: UITableView!
    
    // MARK: Object lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = PaymentMethodCleanInteractor()
        let presenter = PaymentMethodCleanPresenter()
        let router = PaymentMethodCleanRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        interactor?.prepareSetUpUI(request: PaymentMethodClean.Texts.Request())
        fetchPaymentMethods()
    }
    
    // MARK: Methods
    @objc
    func fetchPaymentMethods() {
        genericHideErrorView()
        interactor?.fetchPaymentMethods(request: PaymentMethodClean.PaymentMethods.Request())
    }
    
    func displaySetupUI(viewModel: PaymentMethodClean.Texts.ViewModel) {
        self.title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.stop,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }

    @objc
    func closeButtonTapped() {
        genericHideErrorView()
        router?.closeToDashboard()
    }
    
    func displayLoadingView() {
        genericDisplayLoadingView()
    }
    
    func hideLoadingView() {
        genericHideLoadingView()
    }
    
    func displayPaymentMethodArray(viewModel: PaymentMethodClean.PaymentMethods.ViewModel) {
        paymentMethodsToDisplay = viewModel.displayPaymentMethodViewModelArray
        paymentTableView.reloadData()
    }
    
    func displayErrorAlert(viewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.Failure) {
        genericDisplayErrorView(
            typeOfError: viewModel.errorType,
            retryAction: #selector(fetchPaymentMethods),
            closeAction: #selector(closeButtonTapped)
        )
    }
    func displayAmountErrorAlert(viewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.AmountFailure) {
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
    
    func showBankSelect(viewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.Success) {
        router?.routeToBankSelect()
    }
}

extension PaymentMethodCleanViewController: UITableViewDataSource, UITableViewDelegate {

    private static let cellIdentifier = "PaymentMethodCell"
    private func setupTableView() {
        let cellIdentifier = type(of: self).cellIdentifier
        let bundle = Utils.bundle(forClass: type(of: self).classForCoder())
        let nib = UINib(nibName: cellIdentifier, bundle: bundle)
        paymentTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        paymentTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethodsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: type(of: self).cellIdentifier,
            for: indexPath
            ) as! PaymentMethodTableViewCell
        let paymentMethod = paymentMethodsToDisplay[indexPath.row]
        cell.paymentMethodNameLabel.text = paymentMethod.name
        if let imageUrl = URL(string: paymentMethod.secureThumbnail) {
            cell.paymentImageView.af_setImage(
                withURL: imageUrl,
                placeholderImage: MainAsset.noImage.image,
                imageTransition: .flipFromBottom(0.5)
            )
        } else {
            cell.paymentImageView.image = MainAsset.noImage.image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = PaymentMethodClean.PaymentMethodsDetails.Request(indexPath: indexPath.row)
        interactor?.handleDidSelectRow(request: request)
    }

    // MARK: - GettersSetters
    var titleText: String? { self.title }
    var getPaymentTableView: UITableView { paymentTableView }
}
