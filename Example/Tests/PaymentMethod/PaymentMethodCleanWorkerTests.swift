//
//  PaymentMethodCleanWorkerTests.swift
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

class PaymentMethodCleanWorkerTests: XCTestCase {
    // MARK: Subject under test

    var sut: PaymentMethodCleanWorker!
    var reachabilitySpy: ReachabilityCheckingProtocol?
    let stubs = CuotasModuleStubs(logging: true, verbose: true)

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupPaymentMethodCleanWorker()
    }

    override  func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupPaymentMethodCleanWorker() {
        sut = PaymentMethodCleanWorker()
        stubs.removeAllStubs()
        OHHTTPStubs.removeAllStubs()
    }

    // MARK: Tests

    func testGetPaymentMethodsSuccess() {
        // Given
        stubs.registerStub(
            for: Configuration.Api.paymentMethods,
            jsonFile: "GET_payment_methods_200.json",
            stubName: "Payment methods stub",
            downloadSpeed: OHHTTPStubsDownloadSpeedWifi,
            responseTime: 0,
            replaceIfExists: false
        )

        let expectation = self.expectation(description: "calls the callback with a resource object")
        // When
        sut.getPaymentMethods(successCompletion: { paymentMethodResult in
            // Then
            XCTAssertEqual(
                paymentMethodResult?.first?.name,
                "Visa Débito",
                "should match the JSON file"
            )
            XCTAssertEqual(
                paymentMethodResult?.first?.id,
                "debvisa",
                "should match the JSON file"
            )
            XCTAssertEqual(
                paymentMethodResult?.first?.paymentTypeId,
                "debit_card",
                "should match the JSON file"
            )
            XCTAssertEqual(
                paymentMethodResult?.first?.secureThumbnail,
                "https://www.mercadopago.com/org-img/MP3/API/logos/debvisa.gif",
                "should match the JSON file"
            )
            expectation.fulfill()
        }) { _ in
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
        stubs.removeStub(stubName: "Payment methods Stub")
        OHHTTPStubs.removeAllStubs()
    }

    func testGetPaymentMethodsFail() {
        // Given
        stubs.registerStub(
            for: Configuration.Api.paymentMethods,
            jsonFile: "GET_payment_methods_200.json",
            stubName: "Payment methods Stub (general error)",
            responseTime: 1,
            failWithInternetError: true
        )

        let expectation = self.expectation(description: "network down")

        // When
        sut.getPaymentMethods(successCompletion: { _ in
        }) { error in
            // Then
            XCTAssertNotNil(
                error,
                "no internet error returns an error"
            )
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
        stubs.removeStub(stubName: "Payment methods Stub (general error)")
        OHHTTPStubs.removeAllStubs()
    }

    func testGetPaymentMethodsNoInternet() {
        // Given
        let reachabilitySpy = ReachabilitySpy()
        reachabilitySpy.isConnectedToNetworkReturnValue = false
        sut.reachability = reachabilitySpy

        let expectation = self.expectation(description: "network is down!")

        // When
        sut.getPaymentMethods(successCompletion: { _ in
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
