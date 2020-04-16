//
//  CuotasCleanWorkerTests.swift
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
import OHHTTPStubs
import XCTest

class CuotasCleanWorkerTests: XCTestCase {
    // MARK: Subject under test

    var sut: CuotasCleanWorker!
    var reachabilitySpy: ReachabilityCheckingProtocol?
    let stubs = CuotasModuleStubs(logging: true, verbose: true)

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
        setupCuotasCleanWorker()
    }

    override  func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupCuotasCleanWorker() {
        sut = CuotasCleanWorker()
        stubs.removeAllStubs()
        OHHTTPStubs.removeAllStubs()
    }

    // MARK: Tests
    func testGetCuotasSuccess() {
        // Given
        stubs.registerStub(
            for: Configuration.Api.cuotas,
            jsonFile: "GET_cuotas_200.json",
            stubName: "Cuotas stub",
            downloadSpeed: OHHTTPStubsDownloadSpeedWifi,
            responseTime: 1,
            replaceIfExists: false
        )
        let requestObject = CuotasClean.Cuotas.Request(
            amountEntered: amountEntered,
            selectedPaymentMethodId: paymentModel,
            bankSelectedId: bankModel
        )
        let expectation = self.expectation(description: "calls the callback with a resource object")
        // When
        sut.getCuotas(
            request: requestObject,
            successCompletion: { result in
                // Then
                XCTAssertEqual(
                    result?.first!.payerCosts.first!.installments,
                    1,
                    "should match the JSON file"
                )
                XCTAssertEqual(
                    result?.first!.payerCosts.first!.recommendedMessage,
                    "1 cuota de $ 44.444,00 ($ 44.444,00)",
                    "should match the JSON file"
                )
                expectation.fulfill()
        }) { _ in
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
        stubs.removeStub(stubName: "Cuotas Stub")
        OHHTTPStubs.removeAllStubs()
    }

    func testGetCuotasFail() {
        // Given
        stubs.registerStub(
            for: Configuration.Api.cuotas,
            jsonFile: "GET_cuotas_200.json",
            stubName: "Cuotas Stub (general error)",
            responseTime: 1,
            failWithInternetError: true
        )
        let requestObject = CuotasClean.Cuotas.Request(
            amountEntered: amountEntered,
            selectedPaymentMethodId: paymentModel,
            bankSelectedId: bankModel
        )
        let expectation = self.expectation(description: "network down")

        // When
        sut.getCuotas(
            request: requestObject,
            successCompletion: { _ in
        }) { error in
            XCTAssertNotNil(
                error,
                "no internet error returns an error"
            )
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
        stubs.removeStub(stubName: "Cuotas Stub (general error)")
        OHHTTPStubs.removeAllStubs()
    }

    func testGetCuotasNoInternet() {
        // Given
        let reachabilitySpy = ReachabilitySpy()
        reachabilitySpy.isConnectedToNetworkReturnValue = false
        sut.reachability = reachabilitySpy

        let requestObject = CuotasClean.Cuotas.Request(
            amountEntered: amountEntered,
            selectedPaymentMethodId: paymentModel,
            bankSelectedId: bankModel
        )
        let expectation = self.expectation(description: "network is down!")

        // When
        sut.getCuotas(
            request: requestObject,
            successCompletion: { _ in
        }) { error in
            switch error {
            case NTError.noInternetConection:
                expectation.fulfill()
                return

            default:
                return
            }
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
        OHHTTPStubs.removeAllStubs()
       }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
