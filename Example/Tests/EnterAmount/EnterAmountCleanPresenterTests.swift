//
//  EnterAmountCleanPresenterTests.swift
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

class EnterAmountCleanPresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: EnterAmountCleanPresenter!
    var spyViewController: EnterAmountCleanDisplayLogicSpy!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupEnterAmountCleanPresenter()
    }

    override  func tearDown() {
        spyViewController = nil
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupEnterAmountCleanPresenter() {
        sut = EnterAmountCleanPresenter()

        spyViewController = EnterAmountCleanDisplayLogicSpy()
        sut.viewController = spyViewController
    }

    // MARK: Tests

     func testPresentSetUpUI() {
        // Given
        let response = EnterAmountClean.Texts.Response(
            title: "Amount",
            enterAmountLabel: "Enter amount in Chilean Pesos",
            nextButton: "Next"
        )
        // When
        sut.presentSetUpUI(response: response)
        // Then
        XCTAssertTrue(
            spyViewController.displaySetUpUICalled,
            "presentSetUpUI should ask viewController to display the UI"
        )
        XCTAssertEqual(
            spyViewController.displaySetUpUIViewModel?.title,
            "Amount",
            "presentSetUpUI should change the value to the correct format"
        )
        XCTAssertEqual(
            spyViewController.displaySetUpUIViewModel?.enterAmountLabel,
            "Enter amount in Chilean Pesos",
            "presentSetUpUI should change the value to the correct format"
        )
        XCTAssertEqual(
            spyViewController.displaySetUpUIViewModel?.nextButton,
            "Next",
            "presentSetUpUI should change the value to the correct format"
        )
    }
    func testPresentTextFieldWithRegexNumber() {
        // Given
        let response = EnterAmountClean.Regex.Response(numberToUse: "12345")
        // When
        sut.presentTextFieldWithRegexNumber(response: response)
        // Then
        XCTAssertTrue(
            spyViewController.displayTextFieldWithRegexNumberCalled,
            "presentTextFieldWithRegexNumber should ask viewController to display the textField"
        )
        XCTAssertEqual(
            spyViewController.displayTextFieldWithRegexNumberViewModel?.numberToUse,
            "12345",
            "presentSetUpUI should change the value to the correct format"
        )
    }
    func testPresentPaymentMethod() {
        // Given
        // When
        sut.presentPaymentMethod()
        // Then
        XCTAssertTrue(
            spyViewController.showPaymentMethodCalled,
            "presentPaymentMethod should ask viewController to showPaymentMethod"
        )
    }
    func testPresentCatchCuotaAlert() {
        // Given
        let response = EnterAmountClean.CatchNotification.Response(
            successTitle: "Finished",
            successMessage: "testSuccessMessage",
            buttonTitle: "Ok"
        )
        // When
        sut.presentCatchCuotaAlert(response: response)
        // Then
        XCTAssertTrue(
            spyViewController.displayCatchCuotaAlertCalled,
            "presentCatchCuotaAlert should ask viewController to displayCatchCuotaAlert"
        )
        XCTAssertEqual(
            spyViewController.displayCatchCuotaAlertViewModel?.successTitle,
            "Finished",
            "presentCatchCuotaAlert should ask viewController to displayCatchCuotaAlert title"
        )
        XCTAssertEqual(
            spyViewController.displayCatchCuotaAlertViewModel?.successMessage,
            "testSuccessMessage",
            "presentCatchCuotaAlert should ask viewController to displayCatchCuotaAlert message"
        )
        XCTAssertEqual(
            spyViewController.displayCatchCuotaAlertViewModel?.buttonTitle,
            "Ok",
            "presentCatchCuotaAlert should ask viewController to displayCatchCuotaAlert button"
        )
    }
    func testPresentInputAlert() {
        // Given
        let response = EnterAmountClean.Errors.Response(
            errorTitle: "Finished",
            errorMessage: "You need to enter an amount",
            buttonTitle: "Ok"
        )
        // When
        sut.presentInputAlert(response: response)
        // Then
        XCTAssertTrue(
            spyViewController.displayInputAlertCalled, 
            "presentInputAlert should ask viewController to displayCatchCuotaAlert"
        )
        XCTAssertEqual(
            spyViewController.displayInputAlertViewModel?.errorTitle,
            "Finished",
            "presentInputAlert should ask viewController to displayInputAlert title"
        )
        XCTAssertEqual(
            spyViewController.displayInputAlertViewModel?.errorMessage,
            "You need to enter an amount",
            "presentCatchCuotaAlert should ask viewController to displayInputAlert message"
        )
        XCTAssertEqual(
            spyViewController.displayInputAlertViewModel?.buttonTitle,
            "Ok",
            "presentCatchCuotaAlert should ask viewController to displayInputAlert button"
        )
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
