//
//  PaymentMethodCleanRouter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons

@objc protocol PaymentMethodCleanRoutingLogic {
    func closeToDashboard()
    func routeToBankSelect()
}

protocol PaymentMethodCleanDataPassing {
  var dataStore: PaymentMethodCleanDataStore? { get }
}

class PaymentMethodCleanRouter: NSObject, PaymentMethodCleanRoutingLogic, PaymentMethodCleanDataPassing {
  weak var viewController: PaymentMethodCleanViewController?
  var dataStore: PaymentMethodCleanDataStore?
    
  // MARK: Routing

    func closeToDashboard() {
        viewController?.navigationController?.dismiss(animated: true)
    }
    
    func routeToBankSelect() {
        let storyboard = UIStoryboard(name: "CuotasMain", bundle: Utils.bundle(forClass: BankSelectCleanViewController.classForCoder()))
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "BankSelectCleanViewController") as! BankSelectCleanViewController
        var destinationDS = destinationVC.router!.dataStore!
        
        passDataToBankSelect(source: dataStore!, destination: &destinationDS)
        navigateToBankSelect(source: viewController!, destination: destinationVC)
    }

  // MARK: Navigation
  
  func navigateToBankSelect(source: PaymentMethodCleanViewController, destination: BankSelectCleanViewController) {
    viewController?.navigationController?.show(destination, sender: nil)
  }
  
  // MARK: Passing data
  
  func passDataToBankSelect(source: PaymentMethodCleanDataStore, destination: inout BankSelectCleanDataStore) {
    destination.amountEntered = source.amountEntered
    destination.selectedPaymentMethod = source.selectedPaymentMethod
  }
}
