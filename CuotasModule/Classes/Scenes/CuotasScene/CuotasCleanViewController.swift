//
//  CuotasCleanViewController.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import Commons

protocol CuotasCleanDisplayLogic: class {
    func displaySpinner()
    func hideSpinner()
    func displayErrorAlert(viewModel: CuotasClean.Cuotas.ViewModel.Failure)
    func displayCuotasArray(viewModel: CuotasClean.Cuotas.ViewModel.Success)
}

class CuotasCleanViewController: UIViewController, CuotasCleanDisplayLogic {
    var interactor: (CuotasCleanBusinessLogic & CuotasCleanDataStore)?
    var router: (NSObjectProtocol & CuotasCleanRoutingLogic & CuotasCleanDataPassing)?
    
    var spinner: UIActivityIndicatorView!
    var cuotasArrayDisplay = [CuotasClean.Cuotas.ViewModel.DisplayCuota]()
    
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
        let interactor = CuotasCleanInteractor()
        let presenter = CuotasCleanPresenter()
        let router = CuotasCleanRouter()
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
        setUpUI()
        fetchCuotas()
    }
    
    func setUpUI() {
        let displayName = interactor?.bankSelected != nil ? interactor?.bankSelected!.name : interactor?.selectedPaymentMethod?.name
        self.title = displayName
    }
    
    // MARK: Do something
    func fetchCuotas() {
        let request = CuotasClean.Cuotas.Request(amountEntered: interactor!.amountEntered,
                                                 selectedPaymentMethodId: interactor!.selectedPaymentMethod,
                                                 bankSelectedId: interactor!.bankSelected)
        interactor?.getCuotas(request: request)
    }
    
    func displaySpinner() {
        spinner = self.showModalSpinner()
    }
    
    func hideSpinner() {
        self.hideModalSpinner(indicator: spinner)
    }
    
    func displayErrorAlert(viewModel: CuotasClean.Cuotas.ViewModel.Failure) {
        Alerts.dismissableAlert(title: viewModel.errorTitle,
                                message: viewModel.errorMessage,
                                vc: self,
                                actionBtnText: viewModel.buttonTitle)
    }
    
    func displayCuotasArray(viewModel: CuotasClean.Cuotas.ViewModel.Success) {
        cuotasArrayDisplay = viewModel.cuotasModelArray
        tableView.reloadData()
    }
}

extension CuotasCleanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cuotasArrayDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CuotasCell", for: indexPath) as! CuotasTableViewCell
        let cuota = cuotasArrayDisplay[indexPath.row]
        cell.numberOfInstallmentsLabel.text = cuota.installments
        cell.recommendedMessageLabel.text = cuota.recommendedMessage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = CuotasClean.CuotasDetails.Request(indexPath: indexPath)
        interactor?.handleDidSelectRow(request: request)
    }
    
}
