//
//  BankSelectCleanViewController.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons
import BasicUIElements
import Alamofire
import AlamofireImage

protocol BankSelectCleanDisplayLogic: class {
    func displaySetUpUI(viewModel: BankSelectClean.Texts.ViewModel)
    func displayLoadingView()
    func hideLoadingView()
    func fetchBankSelect()
    func displayBankSelects(viewModel: BankSelectClean.BankSelect.ViewModel.Success)
    func displayErrorAlert(viewModel: BankSelectClean.BankSelect.ViewModel.Failure)
    func showCuotas()
}

class BankSelectCleanViewController: BaseViewController, BankSelectCleanDisplayLogic {
    var interactor: (BankSelectCleanBusinessLogic & BankSelectCleanDataStore)?
    var router: (NSObjectProtocol & BankSelectCleanRoutingLogic & BankSelectCleanDataPassing)?
    
    var bankSelectModelArray = [BankSelectClean.BankSelect.ViewModel.DisplayBankSelect]()
    var selectedPaymentMethod: PaymentMethodModel!

    @IBOutlet private weak var bankCollectionView: UICollectionView!
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.stop,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }

    @objc
    func fetchBankSelect() {
        let request = BankSelectClean.BankSelect.Request()
        interactor?.getBankSelect(request: request)
    }
    @objc
    func closeButtonTapped() {
        genericHideErrorView()
        router?.closeToDashboard()
    }
    
    func displayLoadingView() {
        genericHideErrorView()
        genericDisplayLoadingView()
    }
    
    func hideLoadingView() {
        genericHideLoadingView()
    }
    
    func displayBankSelects(viewModel: BankSelectClean.BankSelect.ViewModel.Success) {
        bankSelectModelArray = viewModel.bankSelectArray
        selectedPaymentMethod = viewModel.selectedPaymentMethod
        bankCollectionView.reloadData()
    }
    
    func displayErrorAlert(viewModel: BankSelectClean.BankSelect.ViewModel.Failure) {
        genericDisplayErrorView(
            typeOfError: viewModel.errorType,
            retryAction: #selector(fetchBankSelect),
            closeAction: #selector(closeButtonTapped)
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
        bankCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        bankCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return !bankSelectModelArray.isEmpty ? bankSelectModelArray.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: type(of: self).cellIdentifier, for: indexPath
            ) as! BankSelectCollectionViewCell

        if !bankSelectModelArray.isEmpty {
            let bankSelectModel = bankSelectModelArray[indexPath.row]
            cell.bankNameLabel.text = bankSelectModel.name
            if let imageUrl = URL(string: bankSelectModel.secureThumbnail) {
                cell.bankSelectImageView.af_setImage(
                    withURL: imageUrl,
                    placeholderImage: MainAsset.noImage.image,
                    imageTransition: .flipFromBottom(0.5)
                )
            } else {
                cell.bankSelectImageView.image = MainAsset.noImage.image
            }
        } else {
            if let selectedPaymentMethod = selectedPaymentMethod {
                cell.bankNameLabel.text = selectedPaymentMethod.name
                if let imageUrl = URL(string: selectedPaymentMethod.secureThumbnail) {
                    cell.bankSelectImageView.af_setImage(
                        withURL: imageUrl,
                        placeholderImage: MainAsset.noImage.image,
                        imageTransition: .flipFromBottom(0.5)
                    )
                } else {
                    cell.bankSelectImageView.image = MainAsset.noImage.image
                }
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
    var getBankCollectionView: UICollectionView { bankCollectionView }
}
