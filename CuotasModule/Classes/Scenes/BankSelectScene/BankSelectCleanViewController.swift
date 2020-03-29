//
//  BankSelectCleanViewController.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import Commons

protocol BankSelectCleanDisplayLogic: class {
    //    func displaySomething(viewModel: BankSelectClean.Something.ViewModel)
    func displaySpinner()
    func hideSpinner()
    func fetchBankSelect()
    func displayBankSelects(viewModel: BankSelectClean.BankSelect.ViewModel.Success)
    func displayErrorAlert(viewModel: BankSelectClean.BankSelect.ViewModel.Failure)
    func showCuotas(viewModel: BankSelectClean.BankSelectDetails.ViewModel.Success)
}

class BankSelectCleanViewController: UIViewController, BankSelectCleanDisplayLogic {
    var interactor: (BankSelectCleanBusinessLogic & BankSelectCleanDataStore)?
    var router: (NSObjectProtocol & BankSelectCleanRoutingLogic & BankSelectCleanDataPassing)?
    
    var spinner: UIActivityIndicatorView!
    var bankSelectModelArray = [BankSelectClean.BankSelect.ViewModel.DisplayBankSelect]()
    let networker = APICuotasModule()

    @IBOutlet weak var collectionView: UICollectionView!
    
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
        fetchBankSelect()
    }
    
    // MARK: Do something
    
    func setUpUI() {
        if let selectedPaymentMethod = interactor?.selectedPaymentMethod {
            self.title = selectedPaymentMethod.name
        }
    }
    
    func fetchBankSelect() {
        let request = BankSelectClean.BankSelect.Request(selectedPaymentMethod: interactor!.selectedPaymentMethod!)
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
        collectionView.reloadData()
    }
    
    func displayErrorAlert(viewModel: BankSelectClean.BankSelect.ViewModel.Failure) {
        Alerts.dismissableAlert(title: viewModel.errorTitle,
                                message: viewModel.errorMessage,
                                vc: self,
                                actionBtnText: viewModel.buttonTitle)
    }
    
    func showCuotas(viewModel: BankSelectClean.BankSelectDetails.ViewModel.Success) {
        router?.routeToCuotas()
    }
}

extension BankSelectCleanViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bankSelectModelArray.count > 0 ? bankSelectModelArray.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BankSelectCell", for: indexPath) as! BankSelectCollectionViewCell

        if bankSelectModelArray.count > 0 {
            let bankSelectModel = bankSelectModelArray[indexPath.row]
            cell.bankNameLabel.text = bankSelectModel.name
            networker.downloadImage(urlString: bankSelectModel.secureThumbnail) { (data) in
                cell.bankSelectImageView.image = UIImage(data: data) ?? UIImage(named: "noImage")
            }
        } else {
            if let selectedPaymentMethod = interactor?.selectedPaymentMethod {
                cell.bankNameLabel.text = selectedPaymentMethod.name
                networker.downloadImage(urlString: selectedPaymentMethod.secureThumbnail) { (data) in
                    cell.bankSelectImageView.image = UIImage(data: data) ?? UIImage(named: "noImage")
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let request = BankSelectClean.BankSelectDetails.Request(indexPath: indexPath)
        interactor?.handleDidSelectItem(request: request)
    }
}
