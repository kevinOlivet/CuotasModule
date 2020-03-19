//
//  CuotasCleanRouter.swift
//  MercadoLibreTest
//
//  Created by Jon Olivet on 9/28/18.
//  Copyright (c) 2018 Jon Olivet. All rights reserved.
//

import UIKit

@objc protocol CuotasCleanRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol CuotasCleanDataPassing
{
  var dataStore: CuotasCleanDataStore? { get }
}

class CuotasCleanRouter: NSObject, CuotasCleanRoutingLogic, CuotasCleanDataPassing
{
  weak var viewController: CuotasCleanViewController?
  var dataStore: CuotasCleanDataStore?
  
  // MARK: Routing
  
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
  
  //func navigateToSomewhere(source: CuotasCleanViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: CuotasCleanDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
