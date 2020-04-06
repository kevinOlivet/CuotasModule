//
//  PaymentMethodCleanViewController.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons
import Alamofire
import AlamofireImage

protocol PaymentMethodCleanDisplayLogic: class {
    func displaySetupUI(viewModel: PaymentMethodClean.Texts.ViewModel)
    func displaySpinner()
    func hideSpinner()
    func displayErrorAlert(viewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.Failure)
    func displayPaymentMethodArray(viewModel: PaymentMethodClean.PaymentMethods.ViewModel)
    func showBankSelect(viewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.Success)
    func displayWrongAmountAlert(viewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.Failure)
}

class PaymentMethodCleanViewController: UIViewController, PaymentMethodCleanDisplayLogic {
    
    var interactor: (PaymentMethodCleanBusinessLogic & PaymentMethodCleanDataStore)?
    var router: (NSObjectProtocol & PaymentMethodCleanRoutingLogic & PaymentMethodCleanDataPassing)?
    
    var spinner: UIActivityIndicatorView!
    var paymentMethodsToDisplay: [PaymentMethodClean.PaymentMethods.ViewModel.DisplayPaymentMethodViewModelSuccess] = []

    @IBOutlet weak var tableView: UITableView!
    
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
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageCache = AutoPurgingImageCache()
        imageCache.removeAllImages()
        interactor?.prepareSetUpUI(request: PaymentMethodClean.Texts.Request())
        interactor?.fetchPaymentMethods(request: PaymentMethodClean.PaymentMethods.Request())
    }
    
    // MARK: Methods
    
    func displaySetupUI(viewModel: PaymentMethodClean.Texts.ViewModel) {
        self.title = viewModel.title
    }
    
    func displaySpinner() {
        spinner = self.showModalSpinner()
    }
    
    func hideSpinner() {
        self.hideModalSpinner(indicator: spinner)
    }
    
    func displayPaymentMethodArray(viewModel: PaymentMethodClean.PaymentMethods.ViewModel) {
        paymentMethodsToDisplay = viewModel.displayPaymentMethodViewModelArray
        tableView.reloadData()
    }
    
    func displayErrorAlert(viewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.Failure) {
        Alerts.dismissableAlert(
            title: viewModel.errorTitle,
            message: viewModel.errorMessage,
            vc: self,
            actionBtnText: viewModel.buttonTitle
        )
    }
    
    func displayWrongAmountAlert(viewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.Failure) {
        Alerts.dismissableAlert(
            title: viewModel.errorTitle,
            message: viewModel.errorMessage,
            vc: self,
            actionBtnText: viewModel.buttonTitle
        )
    }
    
    func showBankSelect(viewModel: PaymentMethodClean.PaymentMethodsDetails.ViewModel.Success) {
        router?.routeToBankSelect()
    }
}

extension PaymentMethodCleanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethodsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PaymentMethodCell",
            for: indexPath
            ) as! PaymentMethodTableViewCell
        
        // Change to ViewModel
        let paymentMethod = paymentMethodsToDisplay[indexPath.row]
        cell.paymentMethodNameLabel.text = paymentMethod.name
        
        cell.paymentImageView.af_setImage(withURL: URL(string: paymentMethod.secureThumbnail)!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = PaymentMethodClean.PaymentMethodsDetails.Request(indexPath: indexPath.row)
        interactor?.handleDidSelectRow(request: request)
    }
}
