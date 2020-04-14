//
//  CuotasCleanViewController.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons

protocol CuotasCleanDisplayLogic: class {
    func displaySetUpUI(viewModel: CuotasClean.Texts.ViewModel)
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
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.prepareSetUpUI(request: CuotasClean.Texts.Request())
        fetchCuotas()
    }
    
    func displaySetUpUI(viewModel: CuotasClean.Texts.ViewModel) {
        self.title = viewModel.title
    }
    
    // MARK: Methods
    func fetchCuotas() {
        interactor?.getCuotas()
    }
    
    func displaySpinner() {
        spinner = self.showModalSpinner()
    }
    
    func hideSpinner() {
        self.hideModalSpinner(indicator: spinner)
    }
    
    func displayErrorAlert(viewModel: CuotasClean.Cuotas.ViewModel.Failure) {
        Alerts.dismissableAlert(
            title: viewModel.errorTitle,
            message: viewModel.errorMessage,
            vc: self,
            actionBtnText: viewModel.buttonTitle
        )
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

    // MARK: - Getters
    var titleText: String? { self.title }
}
