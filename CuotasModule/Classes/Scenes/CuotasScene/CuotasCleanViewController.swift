//
//  CuotasCleanViewController.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons
import BasicUIElements

protocol CuotasCleanDisplayLogic: class {
    func displaySetUpUI(viewModel: CuotasClean.Texts.ViewModel)
    func displayLoadingView()
    func hideLoadingView()
    func displayErrorAlert(viewModel: CuotasClean.Cuotas.ViewModel.Failure)
    func displayCuotasArray(viewModel: CuotasClean.Cuotas.ViewModel.Success)
}

class CuotasCleanViewController: BaseViewController, CuotasCleanDisplayLogic {
    var interactor: (CuotasCleanBusinessLogic & CuotasCleanDataStore)?
    var router: (NSObjectProtocol & CuotasCleanRoutingLogic & CuotasCleanDataPassing)?
    
    var cuotasArrayDisplay = [CuotasClean.Cuotas.ViewModel.DisplayCuota]()
    
    @IBOutlet private weak var cuotasTableView: UITableView!
    
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
        setupTableView()
        interactor?.prepareSetUpUI(request: CuotasClean.Texts.Request())
        fetchCuotas()
    }
    
    func displaySetUpUI(viewModel: CuotasClean.Texts.ViewModel) {
        self.title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.stop,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }
    
    // MARK: Methods
    @objc
    func fetchCuotas() {
        genericHideErrorView()
        interactor?.getCuotas()
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
    
    func displayErrorAlert(viewModel: CuotasClean.Cuotas.ViewModel.Failure) {
        genericDisplayErrorView(
            typeOfError: viewModel.errorType,
            retryAction: #selector(fetchCuotas),
            closeAction: #selector(closeButtonTapped)
        )
    }
    
    func displayCuotasArray(viewModel: CuotasClean.Cuotas.ViewModel.Success) {
        cuotasArrayDisplay = viewModel.cuotasModelArray
        cuotasTableView.reloadData()
    }
}

extension CuotasCleanViewController: UITableViewDataSource, UITableViewDelegate {

    private static let cellIdentifier = "CuotasCell"
    private func setupTableView() {
        let cellIdentifier = type(of: self).cellIdentifier
        let bundle = Utils.bundle(forClass: type(of: self).classForCoder())
        let nib = UINib(nibName: cellIdentifier, bundle: bundle)
        cuotasTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        cuotasTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cuotasArrayDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: type(of: self).cellIdentifier, for: indexPath
            ) as! CuotasTableViewCell
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
    var getCuotasTableView: UITableView { cuotasTableView }
}
