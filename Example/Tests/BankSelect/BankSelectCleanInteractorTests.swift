//
//  BankSelectCleanInteractorTests.swift
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

class BankSelectCleanInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: BankSelectCleanInteractor!
    var spyPresenter: BankSelectCleanPresentationLogicSpy!
    var spyWorker: BankSelectCleanWorkerSpy!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupBankSelectCleanInteractor()
    }

    override  func tearDown() {
        spyPresenter = nil
        spyWorker = nil
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupBankSelectCleanInteractor() {
        sut = BankSelectCleanInteractor()
        let model = PaymentMethodModel(
            name: "testName",
            id: "testId",
            secureThumbnail: "testThumbnail",
            paymentTypeId: "testPaymentTypeId",
            minAllowedAmount: 123,
            maxAllowedAmount: 12345
        )
        sut.selectedPaymentMethod = model

        spyPresenter = BankSelectCleanPresentationLogicSpy()
        sut.presenter = spyPresenter

        spyWorker = BankSelectCleanWorkerSpy()
        sut.worker = spyWorker
    }

    // MARK: Test doubles

    enum PossibleResults {
        case success
        case parsingFail
        case failure
    }

    class BankSelectCleanWorkerSpy: BankSelectCleanWorker {

        var theResult: PossibleResults = .success

        override func getBankSelect(
            selectedPaymentMethodId: String,
            successCompletion: @escaping ([BankSelectModel]?) -> Void,
            failureCompletion: @escaping (NTError) -> Void
        ) {
            switch theResult {
            case .success:
                let bank = BankSelectModel(
                    name: "testBankName",
                    id: "testBankId",
                    secureThumbnail: "testBankThumbnail"
                )
                successCompletion([bank])
            case .parsingFail:
                successCompletion(nil)
            case .failure:
                let error = NTError.noInternetConection
                failureCompletion(error)
            }
        }
    }

    // MARK: Tests
    func testPrepareSetUpUI() {
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
        let request = BankSelectClean.Texts.Request()
        // When
        sut.prepareSetUpUI(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentSetUpUICalled,
            "prepareSetUpUI should ask the presenter to presentSetUpUI"
        )
        XCTAssertEqual(
            spyPresenter.presentSetUpUIResponse?.title,
            "testPaymentName",
            "should pass the amount entered to the presenter to setup the UI"
        )
    }
    func testFetchPaymentMethodsSuccess() {
        // Given
        spyWorker.theResult = .success
        let request = BankSelectClean.BankSelect.Request()
        // When
        sut.getBankSelect(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentBankSelectsCalled,
            "getBankSelect with success should call presenter presentBankSelects"
        )
    }
    func testFetchPaymentMethodsParsingFail() {
        // Given
        spyWorker.theResult = .parsingFail
        let request = BankSelectClean.BankSelect.Request()
        // When
        sut.getBankSelect(request: request)
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
    func testFetchPaymentMethodsGeneralFail() {
        // Given
        spyWorker.theResult = .failure
        let request = BankSelectClean.BankSelect.Request()
        // When
        sut.getBankSelect(request: request)
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
    func testHandleDidSelectItem() {
        // Given
        let request = BankSelectClean.BankSelectDetails.Request(
            indexPath: IndexPath(item: 0, section: 0)
        )
        // When
        sut.handleDidSelectItem(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentCuotasCalled,
            "handleDidSelectItem with failure should call presenter presentCuotas"
        )
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
