//
//  EnterAmountCleanViewControllerTests.swift
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

class EnterAmountCleanViewControllerTests: XCTestCase {
    // MARK: Subject under test
    var sut: EnterAmountCleanViewController!
    var spyInteractor: EnterAmountCleanBusinessLogicSpy!
    var spyRouter: EnterAmountCleanRoutingLogicSpy!
    var window: UIWindow!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        window = UIWindow()
        setupEnterAmountCleanViewController()
    }

    override  func tearDown() {
        spyInteractor = nil
        spyRouter = nil
        sut = nil
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupEnterAmountCleanViewController() {
        let bundle = Utils.bundle(forClass: EnterAmountCleanViewController.classForCoder())!
        let storyboard = UIStoryboard(name: "CuotasMain", bundle: bundle)
        sut = (
            storyboard.instantiateViewController(
                withIdentifier: "EnterAmountCleanViewController"
                ) as! EnterAmountCleanViewController
        )

        spyInteractor = EnterAmountCleanBusinessLogicSpy()
        sut.interactor = spyInteractor

        spyRouter = EnterAmountCleanRoutingLogicSpy()
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
        sut = EnterAmountCleanViewController(coder: archiver)
        // Then
        XCTAssertNotNil(
            sut,
            "sut instantiated using the overrideInit"
        )
        XCTAssertTrue(
            spyInteractor.prepareSetUpUICalled,
            "viewDidLoad should call the interactor to setup the UI"
        )
    }
    func testDisplaySetupUI() {
        // Given
        let viewModel = EnterAmountClean.Texts.ViewModel(
            title: "testTitle",
            enterAmountLabel: "1234",
            nextButton: "testNextButton"
        )
        // When
        sut.displaySetUpUI(viewModel: viewModel)
        // Then
        XCTAssertEqual(
            sut.titleText,
            "testTitle",
            "displaySetUpUI should set the title correctly"
        )
        XCTAssertEqual(
            sut.enterAmountLabelText,
            "1234",
            "displaySetUpUI should set the enterAmountLabelText correctly"
        )
        XCTAssertEqual(
            sut.nextButtonText,
            "testNextButton",
            "displaySetUpUI should set the enterAmountLabelText correctly"
        )
    }
    func testCatchCuota() {
        // Given
        let notificationName = Notification.Name(rawValue: "test")
        let notification = Notification(name: notificationName)
        // When
        sut.catchCuota(notification: notification)
        // Then
        XCTAssertTrue(
            spyInteractor.catchCuotaCalled,
            "catchCuota should call interactor catchCuota"
        )
    }
    func testDisplayTextFieldWithRegexNumber() {
        // Given
        let viewModel = EnterAmountClean.Regex.ViewModel(numberToUse: "4321")
        // When
        sut.displayTextFieldWithRegexNumber(viewModel: viewModel)
        // Then
        XCTAssertEqual(
            sut.enterAmountTextFieldText,
            "4321",
            "displayTextFieldWithRegexNumber should set the enterAmountLabelText correctly"
        )
    }
    func testShowPaymentMethod() {
        // Given
        // When
        sut.showPaymentMethod()
        // Then
        XCTAssertTrue(
            spyRouter.routeToPaymentMethodCalled,
            "showPaymentMethod should call router routeToPaymentMethod"
        )
    }
    func testDisplayCatchCuotaAlert() {
        // Given
        let viewModel = EnterAmountClean.CatchNotification.ViewModel(
            successTitle: "testSuccessTitle",
            successMessage: "testSuccessMessage",
            buttonTitle: "testButtonTitle"
        )
        // When
        sut.displayCatchCuotaAlert(viewModel: viewModel)
        // Then
        XCTAssertTrue(
            sut.presentedViewController is UIAlertController,
            "displayCatchCuotaAlert should present an alert"
        )
        guard let alert = sut.presentedViewController as? UIAlertController else {
            XCTFail("The alert didn't get presented")
            return
        }
        XCTAssertEqual(
            alert.title,
            "testSuccessTitle",
            "should be the title"
        )
        XCTAssertEqual(
            alert.message,
            "testSuccessMessage",
            "should be the message"
        )
    }
    func testDisplayInputAlert() {
        // Given
        let viewModel = EnterAmountClean.Errors.ViewModel(
            errorTitle: "testErrorTitle",
            errorMessage: "testErrorMessage",
            buttonTitle: "testButtonTitle"
        )
        // When
        sut.displayInputAlert(viewModel: viewModel)
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
    func testNextButtonTapped() {
        // Given
        sut.enterAmountTextFieldText = "12345"
        // When
        sut.nextButtonTapped()
        // Then
        XCTAssertTrue(
            spyInteractor.handleNextButtonTappedCalled,
            "nextButtonTapped should call interactor handleNextButtonTappedCalled"
        )
        XCTAssertEqual(
            spyInteractor.handleNextButtonTappedRequst?.amountEntered,
            "12345",
            "should pass the text to the interactor"
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
