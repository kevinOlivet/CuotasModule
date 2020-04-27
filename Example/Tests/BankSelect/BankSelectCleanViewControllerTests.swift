//
//  BankSelectCleanViewControllerTests.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable force_cast
// swiftlint:disable identifier_name
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length
import BasicCommons
import BasicUIElements
@testable import CuotasModule
import XCTest

class BankSelectCleanViewControllerTests: XCTestCase {
    // MARK: Subject under test
    var sut: BankSelectCleanViewController!
    var spyInteractor: BankSelectCleanBusinessLogicSpy!
    var spyRouter: BankSelectCleanRoutingLogicSpy!
    var window: UIWindow!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        window = UIWindow()
        setupBankSelectCleanViewController()
    }

    override  func tearDown() {
        spyInteractor = nil
        spyRouter = nil
        sut = nil
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupBankSelectCleanViewController() {

        let bundle = Utils.bundle(forClass: BankSelectCleanViewController.classForCoder())!
        let storyboard = UIStoryboard(name: "CuotasMain", bundle: bundle)
        sut = (
            storyboard.instantiateViewController(
                withIdentifier: "BankSelectCleanViewController"
                ) as! BankSelectCleanViewController
        )

        spyInteractor = BankSelectCleanBusinessLogicSpy()
        sut.interactor = spyInteractor

        spyRouter = BankSelectCleanRoutingLogicSpy()
        sut.router = spyRouter

        loadView()
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Tests

    func testViewDidLoad() {
        // Given
        // When
        // Then
        XCTAssertNotNil(
            sut,
            "the view should instantiate correctly"
        )
        XCTAssertTrue(
            spyInteractor.prepareSetUpUICalled,
            "viewDidLoad should call the interactor to setup the UI"
        )
        XCTAssertTrue(
            spyInteractor.prepareSetUpUICalled,
            "viewDidLoad should call the interactor to setup the UI"
        )
        XCTAssertTrue(
            spyInteractor.getBankSelectCalled,
            "viewDidLoad should call the interactor getBankSelect"
        )
    }
    func testRequiredInit() {
        // Given
        sut = nil
        XCTAssertNil(
            sut,
            "setting the sut to nil to test its other init"
        )
        // When
        let archiver = NSKeyedUnarchiver(forReadingWith: Data())
        sut = BankSelectCleanViewController(coder: archiver)
        // Then
        XCTAssertNotNil(
            sut,
            "sut instantiated using the overrideInit"
        )
        XCTAssertTrue(
            spyInteractor.prepareSetUpUICalled,
            "viewDidLoad should call the interactor to setup the UI"
        )
        XCTAssertTrue(
            spyInteractor.getBankSelectCalled,
            "viewDidLoad should call the interactor getBankSelect"
        )
    }
    func testDisplaySetupUI() {
        // Given
        let viewModel = BankSelectClean.Texts.ViewModel(title: "testTitle")
        // When
        sut.displaySetUpUI(viewModel: viewModel)
        // Then
        XCTAssertEqual(
            sut.titleText,
            "testTitle",
            "displaySetUpUI should set the title correctly"
        )
    }
    func testDisplayLoadingView() {
        // Given
        // When
        sut.displayLoadingView()
        // Then
        XCTAssertTrue(sut.view.subviews.last is MainActivityIndicator)
    }
    func testDisplayBankSelects() {
        // Given
        let bank = BankSelectClean.BankSelect.ViewModel.DisplayBankSelect(
            name: "testBankName",
            bankId: "testBankId",
            secureThumbnail: "testThumbnail"
        )
        let model = PaymentMethodModel(
            name: "testPaymentName",
            id: "testId",
            secureThumbnail: "testThumbnail",
            paymentTypeId: "testPaymentTypeId",
            minAllowedAmount: 123,
            maxAllowedAmount: 12345
        )
        let viewModel = BankSelectClean.BankSelect.ViewModel.Success(
            bankSelectArray: [bank],
            selectedPaymentMethod: model
        )
        // When
        sut.displayBankSelects(viewModel: viewModel)
        // Then
        XCTAssertEqual(
            sut.bankSelectModelArray.first!.name,
            "testBankName",
            "displayBankSelects should set the viewModel array before calling reloadData"
        )
        XCTAssertEqual(
            sut.selectedPaymentMethod.name,
            "testPaymentName",
            "displayBankSelects should set the viewModel array before calling reloadData"
        )
    }
    func testDisplayErrorAlert() {
        // Given
        let viewModel = BankSelectClean.BankSelect.ViewModel.Failure(errorType: .internet)
        // When
        sut.displayErrorAlert(viewModel: viewModel)
        // Then
        XCTAssertTrue(sut.view.subviews.last is FullScreenMessageErrorAnimated)
    }
    func testShowCuotas() {
        // Given
        // When
        sut.showCuotas()
        // Then
        XCTAssertTrue(
            spyRouter.routeToCuotasCalled,
            "presentCuotas should call the router routeToCuotas"
        )
    }
    func testCellForRowBank() {
        // Given
        let bank = BankSelectClean.BankSelect.ViewModel.DisplayBankSelect(
            name: "testBankName",
            bankId: "testBankId",
            secureThumbnail: "testThumbnail"
        )
        sut.bankSelectModelArray = [bank]

        sut.getBankCollectionView.reloadData()
        let indexPathToUse = IndexPath(row: 0, section: 0)
        // When
        let cell = sut.collectionView(sut.getBankCollectionView, cellForItemAt: indexPathToUse)
        XCTAssertTrue(
            cell is BankSelectCollectionViewCell,
            "cell should be BankSelectCollectionViewCell"
        )
        guard let paymentCell = cell as? BankSelectCollectionViewCell else {
            XCTFail("cell is not BankSelectCollectionViewCell")
            return
        }
        XCTAssertEqual(
            paymentCell.bankNameLabel.text,
            "testBankName",
            "should equal the name passed to the cell"
        )
    }
    func testCellForRowPayment() {
        // Given
        let model = PaymentMethodModel(
            name: "testPaymentName",
            id: "testId",
            secureThumbnail: "testThumbnail",
            paymentTypeId: "testPaymentTypeId",
            minAllowedAmount: 123,
            maxAllowedAmount: 12345
        )
        sut.selectedPaymentMethod = model
        sut.getBankCollectionView.reloadData()
        let indexPathToUse = IndexPath(row: 0, section: 0)
        // When
        let cell = sut.collectionView(sut.getBankCollectionView, cellForItemAt: indexPathToUse)
        XCTAssertTrue(
            cell is BankSelectCollectionViewCell,
            "cell should be BankSelectCollectionViewCell"
        )
        guard let paymentCell = cell as? BankSelectCollectionViewCell else {
            XCTFail("cell is not BankSelectCollectionViewCell")
            return
        }
        XCTAssertEqual(
            paymentCell.bankNameLabel.text,
            "testPaymentName",
            "should equal the name passed to the cell"
        )
    }
    func testCloseButtonTapped() {
        // Given
        // When
        sut.closeButtonTapped()
        // Then
        XCTAssertTrue(spyRouter.closeToDashboardCalled)
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
