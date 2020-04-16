//
//  BankSelectCleanViewController.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons
import Alamofire
import AlamofireImage

protocol BankSelectCleanDisplayLogic: class {
    func displaySetUpUI(viewModel: BankSelectClean.Texts.ViewModel)
    func displaySpinner()
    func hideSpinner()
    func fetchBankSelect()
    func displayBankSelects(viewModel: BankSelectClean.BankSelect.ViewModel.Success)
    func displayErrorAlert(viewModel: BankSelectClean.BankSelect.ViewModel.Failure)
    func showCuotas()
}

class BankSelectCleanViewController: UIViewController, BankSelectCleanDisplayLogic {
    var interactor: (BankSelectCleanBusinessLogic & BankSelectCleanDataStore)?
    var router: (NSObjectProtocol & BankSelectCleanRoutingLogic & BankSelectCleanDataPassing)?
    
    var spinner: UIActivityIndicatorView!
    var bankSelectModelArray = [BankSelectClean.BankSelect.ViewModel.DisplayBankSelect]()
    var selectedPaymentMethod: PaymentMethodModel!

    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Object lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = BankSelectCleanInteractor()
        let presenter = BankSelectCleanPresenter()
        let router = BankSelectCleanRouter()
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
        setupCollectionView()
        interactor?.prepareSetUpUI(request: BankSelectClean.Texts.Request())
        fetchBankSelect()
    }
    
    // MARK: Methods
    
    func displaySetUpUI(viewModel: BankSelectClean.Texts.ViewModel) {
        self.title = viewModel.title
    }
    
    func fetchBankSelect() {
        let request = BankSelectClean.BankSelect.Request()
        interactor?.getBankSelect(request: request)
    }
    
    func displaySpinner() {
        spinner = self.showModalSpinner()
    }
    
    func hideSpinner() {
        self.hideModalSpinner(indicator: spinner)
    }
    
    func displayBankSelects(viewModel: BankSelectClean.BankSelect.ViewModel.Success) {
        bankSelectModelArray = viewModel.bankSelectArray
        selectedPaymentMethod = viewModel.selectedPaymentMethod
        collectionView.reloadData()
    }
    
    func displayErrorAlert(viewModel: BankSelectClean.BankSelect.ViewModel.Failure) {
        Alerts.dismissableAlert(
            title: viewModel.errorTitle,
            message: viewModel.errorMessage,
            vc: self,
            actionBtnText: viewModel.buttonTitle
        )
    }
    
    func showCuotas() {
        router?.routeToCuotas()
    }
}

extension BankSelectCleanViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    private static let cellIdentifier = "BankSelectCell"
    private func setupCollectionView() {
        let cellIdentifier = type(of: self).cellIdentifier
        let bundle = Utils.bundle(forClass: type(of: self).classForCoder())
        let nib = UINib(nibName: cellIdentifier, bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return !bankSelectModelArray.isEmpty ? bankSelectModelArray.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BankSelectCell", for: indexPath) as! BankSelectCollectionViewCell

        if !bankSelectModelArray.isEmpty {
            let bankSelectModel = bankSelectModelArray[indexPath.row]
            cell.bankNameLabel.text = bankSelectModel.name
            cell.bankSelectImageView.af_setImage(withURL: URL(string: bankSelectModel.secureThumbnail)!)
        } else {
            if let selectedPaymentMethod = selectedPaymentMethod {
                cell.bankNameLabel.text = selectedPaymentMethod.name
                cell.bankSelectImageView.af_setImage(withURL: URL(string: selectedPaymentMethod.secureThumbnail)!)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let request = BankSelectClean.BankSelectDetails.Request(indexPath: indexPath)
        interactor?.handleDidSelectItem(request: request)
    }

    // MARK: - Getters
    var titleText: String? { self.title }
}
