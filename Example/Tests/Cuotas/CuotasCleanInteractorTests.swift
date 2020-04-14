//
//  CuotasCleanInteractorTests.swift
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

class CuotasCleanInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: CuotasCleanInteractor!
    var spyPresenter: CuotasCleanPresentationLogicSpy!
    var spyWorker: CuotasCleanWorkerSpy!

    let paymentModel = PaymentMethodModel(
        name: "testPaymentName",
        id: "testId",
        secureThumbnail: "testThumbnail",
        paymentTypeId: "testPaymentTypeId",
        minAllowedAmount: 123,
        maxAllowedAmount: 12345
    )
    let bankModel = BankSelectModel(
        name: "testBankName",
        id: "testBankId",
        secureThumbnail: "testBankThumbnail"
    )
    let amountEntered = 1234

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupCuotasCleanInteractor()
    }

    override  func tearDown() {
        spyPresenter = nil
        spyWorker = nil
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupCuotasCleanInteractor() {
        sut = CuotasCleanInteractor()
        sut.selectedPaymentMethod = paymentModel
        sut.bankSelected = bankModel
        sut.amountEntered = amountEntered

        spyPresenter = CuotasCleanPresentationLogicSpy()
        sut.presenter = spyPresenter

        spyWorker = CuotasCleanWorkerSpy()
        sut.worker = spyWorker
    }

    // MARK: Test doubles

    enum PossibleResults {
        case success
        case parsingFail
        case failure
    }

    class CuotasCleanWorkerSpy: CuotasCleanWorker {

        var theResult: PossibleResults = .success

        override func getCuotas(
            request: CuotasClean.Cuotas.Request,
            successCompletion: @escaping ([CuotasResult]?) -> Void,
            failureCompletion: @escaping (NTError) -> Void
        ) {
            switch theResult {
            case .success:
                let item = CuotasResult.PayerCost(
                    installments: 12,
                    recommendedMessage: "testRecommendedMessage"
                )
                let result = CuotasResult(payerCosts: [item])
                successCompletion([result])
            case .parsingFail:
                successCompletion(nil)
            case .failure:
                let error = NTError.noInternetConection
                failureCompletion(error)
            }
        }
    }

    // MARK: - Tests
    func testPrepareSetUpUI() {
        // Given
        sut.selectedPaymentMethod = paymentModel
        let request = CuotasClean.Texts.Request()
        // When
        sut.prepareSetUpUI(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentSetUpUICalled,
            "prepareSetUpUI should ask the presenter to presentSetUpUI"
        )
        XCTAssertEqual(
            spyPresenter.presentSetUpUIResponse?.title,
            "testBankName",
            "should pass the amount entered to the presenter to setup the UI"
        )
    }
    func testGetCuotasSuccess() {
        // Given
        spyWorker.theResult = .success
        // When
        sut.getCuotas()
        // Then
        XCTAssertTrue(
            spyPresenter.presentCuotasCalled,
            "getBankSelect with success should call presenter presentBankSelects"
        )
    }
    func testGetCuotasParsingFail() {
        // Given
        spyWorker.theResult = .parsingFail
        // When
        sut.getCuotas()
        // Then
        XCTAssertTrue(
            spyPresenter.presentErrorAlertCalled,
            "getBankSelect with failure parsing should call presenter presentErrorAlert"
        )
        XCTAssertEqual(
            spyPresenter.presentErrorAlertResponse?.errorTitle,
            "Error",
            "Error parsing should have a title Error"
        )
        XCTAssertEqual(
            spyPresenter.presentErrorAlertResponse?.errorMessage,
            "Error Parsing",
            "Error parsing should have a message Error Parsing"
        )
        XCTAssertEqual(
            spyPresenter.presentErrorAlertResponse?.buttonTitle,
            "Cancel",
            "Error parsing should have a button Cancel"
        )
    }
    func testGetCuotasGeneralFail() {
        // Given
        spyWorker.theResult = .failure
        // When
        sut.getCuotas()
        // Then
        XCTAssertTrue(
            spyPresenter.presentErrorAlertCalled,
            "getBankSelect with failure should call presenter presentErrorAlert"
        )
        XCTAssertEqual(
            spyPresenter.presentErrorAlertResponse?.errorTitle,
            "Error",
            "Error in general should have a title Error"
        )
        XCTAssertEqual(
            spyPresenter.presentErrorAlertResponse?.errorMessage,
            "Service Error",
            "Error in general should have a message Service Error"
        )
        XCTAssertEqual(
            spyPresenter.presentErrorAlertResponse?.buttonTitle,
            "Cancel",
            "Error in general should have a button Cancel"
        )
    }

}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
