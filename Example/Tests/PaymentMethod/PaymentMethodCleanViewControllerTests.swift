//
//  PaymentMethodCleanViewControllerTests.swift
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
@testable import CuotasModule
import XCTest

class PaymentMethodCleanViewControllerTests: XCTestCase {
    // MARK: Subject under test
    var sut: PaymentMethodCleanViewController!
    var spyInteractor: PaymentMethodCleanBusinessLogicSpy!
    var spyRouter: PaymentMethodCleanRoutingLogicSpy!
    var window: UIWindow!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        window = UIWindow()
        setupPaymentMethodCleanViewController()
    }

    override  func tearDown() {
        spyInteractor = nil
        spyRouter = nil
        sut = nil
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupPaymentMethodCleanViewController() {
        let bundle = Utils.bundle(forClass: PaymentMethodCleanViewController.classForCoder())!
        let storyboard = UIStoryboard(name: "CuotasMain", bundle: bundle)
        sut = (
            storyboard.instantiateViewController(
                withIdentifier: "PaymentMethodCleanViewController"
                ) as! PaymentMethodCleanViewController
        )

        spyInteractor = PaymentMethodCleanBusinessLogicSpy()
        sut.interactor = spyInteractor

        spyRouter = PaymentMethodCleanRoutingLogicSpy()
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
            spyInteractor.fetchPaymentMethodsCalled,
            "viewDidLoad should call the interactor to fetch PaymentMethods"
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
        sut = PaymentMethodCleanViewController(coder: archiver)
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
            spyInteractor.fetchPaymentMethodsCalled,
            "viewDidLoad should call the interactor to fetch PaymentMethods"
        )
    }
    func testDisplaySetupUI() {
        // Given
        let viewModel = PaymentMethodClean.Texts.ViewModel(title: "testTitle")
        // When
        sut.displaySetupUI(viewModel: viewModel)
        // Then
        XCTAssertEqual(
            sut.titleText,
            "testTitle",
            "displaySetUpUI should set the title correctly"
        )
    }
    func testDisplaySpinner() {
        // Given
        // When
        sut.displaySpinner()
        // Then
        XCTAssertNotNil(
            sut.spinner,
            "display spinner should instantiate the spinner"
        )
        XCTAssertFalse(
            sut.spinner.isHidden,
            "spinner should show"
        )
    }
    func testHideSpinner() {
        // Given
        sut.displaySpinner()
        XCTAssertNotNil(
            sut.spinner,
            "display spinner should instantiate the spinner"
        )
        XCTAssertFalse(
            sut.spinner.isHidden,
            "spinner should show"
        )
        // When
        sut.hideSpinner()
        // Then
        XCTAssertTrue(
            sut.spinner.isHidden,
            "spinner should hide when told to do so"
        )
    }
    func testDisplayPaymentMethodArray() {
        // Given
        let item = PaymentMethodClean.PaymentMethods.ViewModel.DisplayPaymentMethodViewModelSuccess(
            name: "testName",
            paymentId: "testPaymentID",
            secureThumbnail: "testThumbnail",
            paymentTypeId: "testPaymentTypeId",
            minAllowedAmount: 123,
            maxAllowedAmount: 12345
        )
        let viewModel = PaymentMethodClean.PaymentMethods.ViewModel(
            displayPaymentMethodViewModelArray: [item]
        )
        // When
        sut.displayPaymentMethodArray(viewModel: viewModel)
        // Then
        XCTAssertEqual(
            sut.paymentMethodsToDisplay,
            viewModel.displayPaymentMethodViewModelArray, "should equal what is passed."
        )
    }
    func testDisplayErrorAlert() {
        // Given
        let viewModel = PaymentMethodClean.PaymentMethodsDetails.ViewModel.Failure(
            errorTitle: "testErrorTitle",
            errorMessage: "testErrorMessage",
            buttonTitle: "testButtonTitle"
        )
        // When
        sut.displayErrorAlert(viewModel: viewModel)
        // Then
        XCTAssertTrue(
            sut.presentedViewController is UIAlertController,
            "displayInputAlert should present an alert"
        )
        guard let alert = sut.presentedViewController as? UIAlertController else {
            XCTFail("The alert didn't get presented")
            return
        }
        XCTAssertEqual(
            alert.title,
            "testErrorTitle",
            "should be the title"
        )
        XCTAssertEqual(
            alert.message,
            "testErrorMessage",
            "should be the message"
        )
    }
    func testShowBankSelect() {
        // Given
        let model = PaymentMethodModel(
            name: "testName",
            id: "testId",
            secureThumbnail: "testThumbnail",
            paymentTypeId: "testPaymentTypeId",
            minAllowedAmount: 123,
            maxAllowedAmount: 12334
        )
        let viewModel = PaymentMethodClean.PaymentMethodsDetails.ViewModel.Success(
            amountEntered: 1234,
            selectedPaymentMethod: model
        )
        // When
        sut.showBankSelect(viewModel: viewModel)
        // Then
        XCTAssertTrue(
            spyRouter.routeToBankSelectCalled,
            "showBankSelect should call the router routeToBankSelect"
        )
    }
    func testCellForRow() {
        // Given
        let item = PaymentMethodClean.PaymentMethods.ViewModel.DisplayPaymentMethodViewModelSuccess(
            name: "testName",
            paymentId: "testPaymentID",
            secureThumbnail: "testThumbnail",
            paymentTypeId: "testPaymentTypeId",
            minAllowedAmount: 123,
            maxAllowedAmount: 12345
        )
        let paymentMethodsArray = PaymentMethodClean.PaymentMethods.ViewModel(
            displayPaymentMethodViewModelArray: [item]
        )
        sut.paymentMethodsToDisplay = paymentMethodsArray.displayPaymentMethodViewModelArray
        sut.tableView.reloadData()
        let indexPathToUse = IndexPath(row: 0, section: 0)
        // When
        let cell = sut.tableView(sut.tableView, cellForRowAt: indexPathToUse)
        XCTAssertTrue(cell is PaymentMethodTableViewCell, "cell should be PaymentMethodTableViewCell")
        guard let paymentCell = cell as? PaymentMethodTableViewCell else {
            XCTFail("cell is not PaymentMethodTableViewCell")
            return
        }
        XCTAssertEqual(
            paymentCell.paymentMethodNameLabel.text,
            "testName",
            "should equal the name passed to the cell"
        )
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
