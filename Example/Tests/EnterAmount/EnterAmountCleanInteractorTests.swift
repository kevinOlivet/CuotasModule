//
//  EnterAmountCleanInteractorTests.swift
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

class EnterAmountCleanInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: EnterAmountCleanInteractor!
    var spyPresenter: EnterAmountCleanPresentationLogicSpy!
    var spyWorker: EnterAmountCleanWorkerSpy!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupEnterAmountCleanInteractor()
    }

    override  func tearDown() {
        spyPresenter = nil
        spyWorker = nil
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupEnterAmountCleanInteractor() {
        sut = EnterAmountCleanInteractor()

        spyPresenter = EnterAmountCleanPresentationLogicSpy()
        sut.presenter = spyPresenter

        spyWorker = EnterAmountCleanWorkerSpy()
        sut.worker = spyWorker
    }

    // MARK: Test doubles

    class EnterAmountCleanWorkerSpy: EnterAmountCleanWorker {}

    // MARK: Tests

     func testPrepareSetUpUI() {
        // Given
        let request = EnterAmountClean.Texts.Request()
        // When
        sut.prepareSetUpUI(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentSetUpUICalled,
            "prepareSetUpUI should ask presenter presentSetUpUI"
        )
        XCTAssertEqual(
            spyPresenter.presentSetUpUIResponse?.title,
            "Amount",
            "prepareSetUpUI should ask the presenter to format the result"
        )
        XCTAssertEqual(
            spyPresenter.presentSetUpUIResponse?.enterAmountLabel,
            "Enter amount in Chilean Pesos",
            "prepareSetUpUI should ask the presenter to format the result"
        )
        XCTAssertEqual(
            spyPresenter.presentSetUpUIResponse?.nextButton,
            "Next",
            "prepareSetUpUI should ask the presenter to format the result"
        )
    }
    func testHandleNextButtonTappedSuccess() {
        // Given
        let request = EnterAmountClean.EnterAmount.Request(amountEntered: "12345")
        // When
        sut.handleNextButtonTapped(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentPaymentMethodCalled,
            "handleNextButtonTapped should ask presenter presentPaymentMethod"
        )
    }
    func testHandleNextButtonTappedTextEmpty() {
        // Given
        let request = EnterAmountClean.EnterAmount.Request(amountEntered: "")
        // When
        sut.handleNextButtonTapped(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentInputAlertCalled,
            "handleNextButtonTapped with no text should ask presenter presentInputAlert"
        )
        XCTAssertEqual(
            spyPresenter.presentInputAlertResponse?.errorTitle,
            "Enter amount",
            "handleNextButtonTapped with an invalid number gets an invalid title"
        )
        XCTAssertEqual(
            spyPresenter.presentInputAlertResponse?.errorMessage,
            "You need to enter an amount",
            "handleNextButtonTapped with an invalid number gets an invalid message"
        )
        XCTAssertEqual(
            spyPresenter.presentInputAlertResponse?.buttonTitle,
            "Ok",
            "handleNextButtonTapped with an invalid number gets an invalid button"
        )
    }
    func testHandleNextButtonTappedTextEmptyBadText() {
        // Given
        let request = EnterAmountClean.EnterAmount.Request(amountEntered: "1234567890")
        // When
        sut.handleNextButtonTapped(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentInputAlertCalled,
            "handleNextButtonTapped with no text should ask presenter presentInputAlert"
        )
        XCTAssertEqual(
            spyPresenter.presentInputAlertResponse?.errorTitle,
            "Invalid number",
            "handleNextButtonTapped with an invalid number gets an invalid title"
        )
        XCTAssertEqual(
            spyPresenter.presentInputAlertResponse?.errorMessage,
            "You've exceeded the limit",
            "handleNextButtonTapped with an invalid number gets an invalid message"
        )
        XCTAssertEqual(
            spyPresenter.presentInputAlertResponse?.buttonTitle,
            "Ok",
            "handleNextButtonTapped with an invalid number gets an invalid button"
        )
    }
    func testCatchCuota() {
        // Given
        let notificationName = Notification.Name(rawValue: "test")
        var notification = Notification(name: notificationName)
        notification.userInfo = ["finalMessage": "testFinalMessage"]
        let request = EnterAmountClean.CatchNotification.Request(notification: notification)
        // When
        sut.catchCuota(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentCatchCuotaAlertCalled,
            "handleNextButtonTapped with no text should ask presenter presentInputAlert"
        )
        XCTAssertEqual(
            spyPresenter.presentCatchCuotaAlertResponse?.successTitle,
            "Finished",
            "handleNextButtonTapped with an invalid number gets an invalid title"
        )
        XCTAssertEqual(
            spyPresenter.presentCatchCuotaAlertResponse?.successMessage,
            "testFinalMessage",
            "handleNextButtonTapped with an invalid number gets an invalid message"
        )
        XCTAssertEqual(
            spyPresenter.presentCatchCuotaAlertResponse?.buttonTitle,
            "Ok",
            "handleNextButtonTapped with an invalid number gets an invalid button"
        )
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
