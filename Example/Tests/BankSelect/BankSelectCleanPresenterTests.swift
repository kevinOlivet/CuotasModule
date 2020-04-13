//
//  BankSelectCleanPresenterTests.swift
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

class BankSelectCleanPresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: BankSelectCleanPresenter!
    var spyViewController: BankSelectCleanDisplayLogicSpy!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupBankSelectCleanPresenter()
    }

    override  func tearDown() {
        spyViewController = nil
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupBankSelectCleanPresenter() {
        sut = BankSelectCleanPresenter()

        spyViewController = BankSelectCleanDisplayLogicSpy()
        sut.viewController = spyViewController
    }

    // MARK: Tests

    func testPresentSetupUI() {
        // Given
        let response = BankSelectClean.Texts.Response(title: "testTitle")
        // When
        sut.presentSetUpUI(response: response)
        // Then
        XCTAssertTrue(
            spyViewController.displaySetUpUICalled,
            "presentSetupUI should ask the view controller to display the result"
        )
        XCTAssertEqual(
            spyViewController.displaySetUpUIViewModel?.title,
            "testTitle",
            "presentSetupUI should pass and format the text"
        )
    }
    func testPresentSpinner() {
        // Given
        // When
        sut.presentSpinner()
        // Then
        XCTAssertTrue(
            spyViewController.displaySpinnerCalled,
            "presentSpinner should ask the view controller to displaySpinner"
        )
    }
    func testHideSpinner() {
        // Given
        // When
        sut.hideSpinner()
        // Then
        XCTAssertTrue(
            spyViewController.hideSpinnerCalled,
            "hideSpinner should ask the view controller to hideSpinner"
        )
    }
    func testPresentBankSelects() {
        // Given
        let bank = BankSelectModel(
            name: "testBankName",
            id: "testBankId",
            secureThumbnail: "testBankThumbnail"
        )
        let model = PaymentMethodModel(
            name: "testName",
            id: "testId",
            secureThumbnail: "testThumbnail",
            paymentTypeId: "testPaymentTypeId",
            minAllowedAmount: 123,
            maxAllowedAmount: 12345
        )
        let response = BankSelectClean.BankSelect.Response.Success(
            bankSelectArray: [bank],
            selectedPaymentMethod: model
        )
        // When
        sut.presentBankSelects(response: response)
        // Then
        XCTAssertTrue(
            spyViewController.displayBankSelectsCalled,
            "presentBankSelects should call viewController displayBankSelects"
        )
    }
    func testPresentErrorAlert() {
        // Given
        let response = BankSelectClean.BankSelect.Response.Failure(
            errorTitle: "Error",
            errorMessage: "Service Error",
            buttonTitle: "Cancel"
        )
        // When
        sut.presentErrorAlert(response: response)
        // Then
        XCTAssertTrue(
            spyViewController.displayErrorAlertCalled,
            "presentErrorAlert should ask the view controller to displayErrorAlert"
        )
        XCTAssertEqual(
            spyViewController.displayErrorAlertViewModel?.errorTitle,
            "Error".localized,
            "the presenter should format the response"
        )
        XCTAssertEqual(
            spyViewController.displayErrorAlertViewModel?.errorMessage,
            "Service Error".localized,
            "the presenter should format the response"
        )
        XCTAssertEqual(
            spyViewController.displayErrorAlertViewModel?.buttonTitle,
            "Cancel".localized,
            "the presenter should format the response"
        )
    }
    func testPresentCuotas() {
        // Given
        // When
        sut.presentCuotas()
        // Then
        XCTAssertTrue(
            spyViewController.showCuotasCalled,
            "presentCuotas should call viewController showCuotas"
        )
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
