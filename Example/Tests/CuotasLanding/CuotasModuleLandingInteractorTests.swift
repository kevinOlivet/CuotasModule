//
//  CuotasModuleLandingInteractorTests.swift
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

class CuotasModuleLandingInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: CuotasModuleLandingInteractor!
    var spyPresenter: CuotasModuleLandingPresentationLogicSpy!
    var spyWorker: CuotasModuleLandingWorkerSpy!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupCuotasModuleLandingInteractor()
    }

    override  func tearDown() {
        spyPresenter = nil
        spyWorker = nil
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupCuotasModuleLandingInteractor() {
        sut = CuotasModuleLandingInteractor()

        spyPresenter = CuotasModuleLandingPresentationLogicSpy()
        sut.presenter = spyPresenter

        spyWorker = CuotasModuleLandingWorkerSpy()
        sut.worker = spyWorker
    }

    // MARK: Test doubles

    class CuotasModuleLandingWorkerSpy: CuotasModuleLandingWorker {}

    // MARK: Tests

     func testSetupUI() {
        // Given
        let request = CuotasModuleLanding.Basic.Request()
        // When
        sut.setupUI(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentSetupUICalled,
            "setupUI should ask the presenter to format the result"
        )
        XCTAssertEqual(
            spyPresenter.presentSetupUIResponse?.title,
            "WELCOME_TITLE",
            "setupUI should pass the title to the presenter"
        )
        XCTAssertEqual(
            spyPresenter.presentSetupUIResponse?.subtitle,
            "WELCOME_SUBTITLE",
            "setupUI should pass the subtitle to the presenter"
        )
    }

}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
