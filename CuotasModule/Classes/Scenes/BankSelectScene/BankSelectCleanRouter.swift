//
//  BankSelectCleanRouter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons

@objc protocol BankSelectCleanRoutingLogic {
    func closeToDashboard()
    func routeToCuotas()
}

protocol BankSelectCleanDataPassing {
  var dataStore: BankSelectCleanDataStore? { get }
}

class BankSelectCleanRouter: NSObject, BankSelectCleanRoutingLogic, BankSelectCleanDataPassing {
  weak var viewController: BankSelectCleanViewController?
  var dataStore: BankSelectCleanDataStore?
  
  // MARK: Routing
    func closeToDashboard() {
        viewController?.navigationController?.dismiss(animated: true)
    }
    
    func routeToCuotas() {
        let storyboard = UIStoryboard(name: "CuotasMain", bundle: Utils.bundle(forClass: CuotasCleanViewController.classForCoder()))
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "CuotasCleanViewController") as! CuotasCleanViewController
        var destinationDS = destinationVC.router!.dataStore!
        
        passDataToCuotas(source: dataStore!, destination: &destinationDS)
        navigateToCuotas(source: viewController!, destination: destinationVC)
    }

  // MARK: Navigation
  
  func navigateToCuotas(source: BankSelectCleanViewController, destination: CuotasCleanViewController) {
    viewController?.navigationController?.pushViewController(destination, animated: true)
  }
  
  // MARK: Passing data
  
  func passDataToCuotas(source: BankSelectCleanDataStore, destination: inout CuotasCleanDataStore) {
    destination.amountEntered = source.amountEntered
    destination.selectedPaymentMethod = source.selectedPaymentMethod
    destination.bankSelected = source.selectedBankSelect
  }
}
