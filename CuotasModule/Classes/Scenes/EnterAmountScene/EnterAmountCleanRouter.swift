//
//  EnterAmountCleanRouter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import Commons

@objc
public protocol EnterAmountCleanRoutingLogic {
//    func routeToSomewhere(segue: UIStoryboardSegue?)
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
    
//    func routeToPaymentMethod(segue: UIStoryboardSegue?) {
//        if let segue = segue {
//            let destinationVC = segue.destination as! PaymentMethodCleanViewController
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToPaymentMethod(source: dataStore!, destination: &destinationDS)
//        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let destinationVC = storyboard.instantiateViewController(withIdentifier: "PaymentMethodCleanViewController") as! PaymentMethodCleanViewController
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToPaymentMethod(source: dataStore!, destination: &destinationDS)
//            navigateToPaymentMethod(source: viewController!, destination: destinationVC)
//        }
//    }

  // MARK: Navigation

    func navigateToPaymentMethod(source: EnterAmountCleanViewController, destination: PaymentMethodCleanViewController) {
        // should change to show(destination, sender: nil)???
        // should use segue???
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
//    MARK: Passing data
    
    func passDataToPaymentMethod(source: EnterAmountCleanDataStore, destination: inout PaymentMethodCleanDataStore) {
        destination.amountEntered = source.amountEnteredDataStore
    }
}
