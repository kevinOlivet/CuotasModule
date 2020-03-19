//
//  BankSelectCleanRouter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import Commons

@objc protocol BankSelectCleanRoutingLogic {
  //func routeToSomewhere(segue: UIStoryboardSegue?)
    func routeToCuotas()
}

protocol BankSelectCleanDataPassing {
  var dataStore: BankSelectCleanDataStore? { get }
}

class BankSelectCleanRouter: NSObject, BankSelectCleanRoutingLogic, BankSelectCleanDataPassing {
  weak var viewController: BankSelectCleanViewController?
  var dataStore: BankSelectCleanDataStore?
  
  // MARK: Routing
    
    func routeToCuotas() {
        let storyboard = UIStoryboard(name: "CuotasMain", bundle: Utils.bundle(forClass: CuotasCleanViewController.classForCoder()))
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "CuotasCleanViewController") as! CuotasCleanViewController
        var destinationDS = destinationVC.router!.dataStore!
        
        passDataToCuotas(source: dataStore!, destination: &destinationDS)
        navigateToCuotas(source: viewController!, destination: destinationVC)
    }
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

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
