//
//  PaymentMethodCleanPresenterTests.swift
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
@testable import CuotasModule
import XCTest

class PaymentMethodCleanPresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: PaymentMethodCleanPresenter!
    var spyViewController: PaymentMethodCleanDisplayLogicSpy!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupPaymentMethodCleanPresenter()
    }

    override  func tearDown() {
        spyViewController = nil
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupPaymentMethodCleanPresenter() {
        sut = PaymentMethodCleanPresenter()

        spyViewController = PaymentMethodCleanDisplayLogicSpy()
        sut.viewController = spyViewController
    }

    // MARK: Tests
     func testPresentSetupUI() {
        // Given
        let response = PaymentMethodClean.Texts.Response(title: 1234)
        // When
        sut.presentSetupUI(response: response)
        // Then
        XCTAssertTrue(
            spyViewController.displaySetupUICalled,
            "presentSetupUI should ask the view controller to display the result"
        )
        XCTAssertEqual(
            spyViewController.displaySetupUIViewModel?.title,
            "$1234",
            "presentSetupUI should add the $ sign"
        )
    }
    func testPresentLoadingView() {
        // Given
        // When
        sut.presentLoadingView()
        // Then
        XCTAssertTrue(
            spyViewController.displayLoadingViewCalled,
            "presentLoadingView should ask the view controller to displayLoadingView"
        )
    }
    func testHideLoadingView() {
        // Given
        // When
        sut.hideLoadingView()
        // Then
        XCTAssertTrue(
            spyViewController.hideLoadingViewCalled,
            "hideLoadingView should ask the view controller to hideLoadingView"
        )
    }
    func testPresentErrorAlert() {
        // Given
        let response = PaymentMethodClean.PaymentMethodsDetails.Response.Failure(errorType: .internet)
        // When
        sut.presentErrorAlert(response: response)
        // Then
        XCTAssertTrue(
            spyViewController.displayErrorAlertCalled,
            "presentErrorAlert should ask the view controller to displayErrorAlert"
        )
        XCTAssertEqual(
            spyViewController.displayErrorAlertViewModel?.errorType,
            .internet,
            "the presenter should pass the response"
        )
    }
    func testPresentAmountErrorAlert() {
        // Given
        let response = PaymentMethodClean.PaymentMethodsDetails.Response.AmountFailure(
            errorTitle: "Error",
            errorMessage: "Service Error",
            buttonTitle: "Cancel"
        )
        // When
        sut.presentAmountErrorAlert(response: response)
        // Then
        XCTAssertTrue(
            spyViewController.displayAmountErrorAlertCalled,
            "presentErrorAlert should ask the view controller to displayErrorAlert"
        )
        XCTAssertEqual(
            spyViewController.displayAmountErrorAlertViewModel?.errorTitle,
            "Error".localized,
            "the presenter should format the response"
        )
        XCTAssertEqual(
            spyViewController.displayAmountErrorAlertViewModel?.errorMessage,
            "Service Error".localized,
            "the presenter should format the response"
        )
        XCTAssertEqual(
            spyViewController.displayAmountErrorAlertViewModel?.buttonTitle,
            "Cancel".localized,
            "the presenter should format the response"
        )
    }
    func testPresentPaymentMethods() {
        // Given
        let model = PaymentMethodModel(
            name: "testName",
            id: "testId",
            secureThumbnail: "testThumbnail",
            paymentTypeId: "testPaymentTypeId",
            minAllowedAmount: 123,
            maxAllowedAmount: 12345
        )
        let response = PaymentMethodClean.PaymentMethods.Response(paymentMethodArray: [model])
        // When
        sut.presentPaymentMethods(response: response)
        // Then
        XCTAssertTrue(
            spyViewController.displayPaymentMethodArrayCalled,
            "presentPaymentMethods should ask the view controller to displayPaymentMethodArray"
        )
        XCTAssertEqual(
            spyViewController.displayPaymentMethodArrayViewModel?.displayPaymentMethodViewModelArray.first?.name,
            "testName",
            "the data should match what is passed"
        )
        XCTAssertEqual(
            spyViewController.displayPaymentMethodArrayViewModel?.displayPaymentMethodViewModelArray.first?.paymentId,
            "testId",
            "the data should match what is passed"
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
            maxAllowedAmount: 12345
        )
        let response = PaymentMethodClean.PaymentMethodsDetails.Response.Success(
            amountEntered: 1234,
            selectedPaymentMethod: model
        )
        // When
        sut.showBankSelect(response: response)
        // Then
        XCTAssertTrue(
            spyViewController.showBankSelectCalled,
            "showBankSelect should ask the view controller to showBankSelect"
        )
        XCTAssertEqual(
            spyViewController.showBankSelectViewModel?.amountEntered,
            1234,
            "should match the amount in the response"
        )
        XCTAssertEqual(
            spyViewController.showBankSelectViewModel?.selectedPaymentMethod.name,
            model.name,
            "should match the model in the response"
        )
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
