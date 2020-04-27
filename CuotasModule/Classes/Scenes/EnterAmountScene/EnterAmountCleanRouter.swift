//
//  EnterAmountCleanRouter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import BasicCommons

@objc
public protocol EnterAmountCleanRoutingLogic {
    func closeToDashboard()
    func routeToRootViewController()
    func routeToPaymentMethod()
}

public protocol EnterAmountCleanDataPassing {
  var dataStore: EnterAmountCleanDataStore? { get }
}

class EnterAmountCleanRouter: NSObject, EnterAmountCleanRoutingLogic, EnterAmountCleanDataPassing {
  weak var viewController: EnterAmountCleanViewController?
  var dataStore: EnterAmountCleanDataStore?
  
  // MARK: Routing
    func closeToDashboard() {
        viewController?.navigationController?.dismiss(animated: true)
    }

    func routeToRootViewController() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
    
    func routeToPaymentMethod() {
        let storyboard = UIStoryboard(name: "CuotasMain", bundle: Utils.bundle(forClass: PaymentMethodCleanViewController.classForCoder()))
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "PaymentMethodCleanViewController") as! PaymentMethodCleanViewController
        var destinationDS = destinationVC.router!.dataStore!
        
        passDataToPaymentMethod(source: dataStore!, destination: &destinationDS)
        navigateToPaymentMethod(source: viewController!, destination: destinationVC)
    }

  // MARK: Navigation
    func navigateToPaymentMethod(source: EnterAmountCleanViewController, destination: PaymentMethodCleanViewController) {
        source.navigationController?.show(destination, sender: nil)
    }
    
//    MARK: Passing data
    func passDataToPaymentMethod(source: EnterAmountCleanDataStore, destination: inout PaymentMethodCleanDataStore) {
        destination.amountEntered = source.amountEnteredDataStore
    }
}
