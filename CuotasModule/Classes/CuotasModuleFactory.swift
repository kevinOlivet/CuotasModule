//
//  CuotasModuleFactory.swift
//  CuotasModule
//
//  Copyright © 2020 Jon Olivet. All rights reserved.
//

import Commons

/// Class for the CuotasModuleFactory
public class CuotasModuleFactory {
    /// Init for the CuotasModuleFactory
    public init() { }

    /// Func getRootViewController for the CuotasModuleFactory
    public func getRootViewController() -> UIViewController {
        CuotasModuleMainNavigationController()
    }

    /// Func getExampleRootViewController for the CuotasModuleDigitalFactory
    public func getExampleRootViewController() -> UIViewController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [CuotasModuleMainNavigationController()]
        tabBarController.tabBar.isTranslucent = false
        return tabBarController
    }
}

private class CuotasModuleMainNavigationController: UINavigationController {

    let viewController = CuotasModuleLandingViewController()

    init() {
        viewController.tabBarItem = UITabBarItem(
            title: "CuotasModule",
            image: .none,
            tag: 1
        )

        let bundleToUse = Utils.bundle(forClass: CuotasModuleLandingViewController.classForCoder())
        super.init(nibName: "CuotasModuleLandingViewController", bundle: bundleToUse)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        navigationBar.isHidden = true
        viewControllers = [viewController]
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        UIStatusBarStyle.lightContent
    }
}
