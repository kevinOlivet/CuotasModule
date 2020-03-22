//
//  ViewController.swift
//  CuotasModule
//
//  Created by Jon Olivet on 03/17/2020.
//  Copyright (c) 2020 Jon Olivet. All rights reserved.
//

import CuotasModule
import Commons

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addTapAction(target: self, action: #selector(goToCuotasModule))
    }

    @objc
    func goToCuotasModule() {
        let storyboard = UIStoryboard(
            name: "CuotasMain",
            bundle: Utils.bundle(forClass: EnterAmountCleanViewController.classForCoder())
        )
        let destinationNVC = storyboard.instantiateInitialViewController() as! UINavigationController
        self.present(destinationNVC, animated: true, completion: nil)
    }
}

