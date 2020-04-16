//
//  CuotasCleanPresenterTests.swift
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

class CuotasCleanPresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: CuotasCleanPresenter!
    var spyViewController: CuotasCleanDisplayLogicSpy!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupCuotasCleanPresenter()
    }

    override  func tearDown() {
        spyViewController = nil
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupCuotasCleanPresenter() {
        sut = CuotasCleanPresenter()

        spyViewController = CuotasCleanDisplayLogicSpy()
        sut.viewController = spyViewController
    }

    // MARK: Tests

    func testPresentSetupUI() {
        // Given
        let response = CuotasClean.Texts.Response(title: "testTitle")
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
    func testPresentErrorAlert() {
        // Given
        let response = CuotasClean.Cuotas.Response.Failure(
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
        let item = CuotasResult.PayerCost(
            installments: 12,
            recommendedMessage: "testRecommendedMessage"
        )
        let response = CuotasClean.Cuotas.Response.Success(cuotasModelArray: [item])
        // When
        sut.presentCuotas(response: response)
        // Then
        XCTAssertTrue(
            spyViewController.displayCuotasArrayCalled,
            "presentCuotas should call viewController displayCuotasArray"
        )
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
