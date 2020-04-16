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
}
