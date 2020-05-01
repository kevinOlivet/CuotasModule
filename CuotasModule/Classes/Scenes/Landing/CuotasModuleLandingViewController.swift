//
//  CuotasModuleLandingViewController.swift
//  Pods
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

import BasicCommons
import BasicUIElements
import Lottie

protocol CuotasModuleLandingDisplayLogic: AnyObject {
    func displaySetupUI(viewModel: CuotasModuleLanding.Basic.ViewModel)
}

class CuotasModuleLandingViewController: BaseViewController, CuotasModuleLandingDisplayLogic {
    var interactor: CuotasModuleLandingBusinessLogic?
    var router: (NSObjectProtocol & CuotasModuleLandingRoutingLogic & CuotasModuleLandingDataPassing)?

    var animation: MainAnimationView?

    @IBOutlet private weak var welcomeView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    // MARK: Object lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    init() {
        let bundleToUse = Utils.bundle(forClass: CuotasModuleLandingViewController.classForCoder())
        super.init(nibName: "CuotasModuleLandingViewController", bundle: bundleToUse)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = CuotasModuleLandingInteractor()
        let presenter = CuotasModuleLandingPresenter()
        let router = CuotasModuleLandingRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle
    override  func viewDidLoad() {
        super.viewDidLoad()
        interactor?.setupUI(request: CuotasModuleLanding.Basic.Request())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animation?.play()
    }

    // MARK: Methods
    func displaySetupUI(viewModel: CuotasModuleLanding.Basic.ViewModel) {
        view.addTapAction(target: self, action: #selector(goToCuotasModule))
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        animation = WelcomeAnimation(
            width: welcomeView.frame.size.width,
            height: welcomeView.frame.size.height
        )
        welcomeView.addSubview(animation!)
    }

    @objc
    func goToCuotasModule() {
        router?.routeToCuotasModule()
    }

    // Getters
    var titleLabelText: String? { titleLabel.text }
    var subtitleLabelText: String? { subtitleLabel.text }
}
