//
//  CuotasModuleStubs.swift
//  CuotasModule
//
//  Created by Jon Olivet on 8/28/18.
//

import BasicCommons
import OHHTTPStubs

public class CuotasModuleStubs: NSObject {
    private var registeredDescriptors: [String: OHHTTPStubsDescriptor] = [:]

    public var loggingEnabled: Bool // If false, no logging will be printed
    public var loggingVerbose: Bool // If false, will only log stub activations

    public required init(logging: Bool = true, verbose: Bool = false) {
        loggingEnabled = logging
        loggingVerbose = verbose
        super.init()
    }

    public func enableStubs() {
        // Called when a stub gets activated
        enableStubsLogging()

        // Stubs for microservices
        // MARK: - CuotasModule
        registerStub(
            for: Configuration.Api.paymentMethods,
            jsonFile: "GET_payment_methods_200.json",
            stubName: "Payment methods"
        )

        registerStub(
            for: Configuration.Api.bankSelect,
            jsonFile: "GET_bank_select_200.json",
            stubName: "Bank select"
        )

        registerStub(
            for: Configuration.Api.cuotas,
            jsonFile: "GET_cuotas_200.json",
            stubName: "Cuotas"
        )
    }

    // MARK: - Logging
    private func log(_ message: String, isActivationLogging: Bool = false) {
        guard loggingEnabled else {
            return
        }
        guard loggingVerbose || isActivationLogging else {
            return
        }

        let className = NSStringFromClass(type(of: self))
        debugPrint("[\(className)] \(message)")
    }

    func enableStubsLogging() {
        OHHTTPStubs.onStubActivation { request, descriptor, _ in
            self.log("--- Stub activation ---", isActivationLogging: true)
            self.log("NAME: \(descriptor.name ?? "Unknown name")", isActivationLogging: true)
            self.log("URL: \(String(describing: request.url?.absoluteString))", isActivationLogging: true)
        }
    }

    func disableStubsLogging() {
        OHHTTPStubs.onStubActivation { _, _, _ in }
    }

    // MARK: - Helper methods
    func registerStub(for url: String,
                      jsonFile: String,
                      stubName: String,
                      downloadSpeed: Double = OHHTTPStubsDownloadSpeedWifi,
                      responseTime: TimeInterval = 1,
                      replaceIfExists: Bool = false,
                      failWithInternetError: Bool = false) {

        guard let stubUrl = URL(string: url) else {
            self.log("registerStub() - The URL specified for \(stubName) is invalid.")
            return
        }

         if registeredDescriptors[stubName] != nil {
            self.log("registerStub() - Already registered stub name: \(stubName)")

            guard replaceIfExists else {
                return
            }

            removeStub(stubName: stubName)
        }

        let newDescriptor: OHHTTPStubsDescriptor
        if failWithInternetError {
            newDescriptor = stub(condition: isPath(stubUrl.path)) { _ in
                let notConnectedError = NSError(
                    domain: NSURLErrorDomain,
                    code: URLError.notConnectedToInternet.rawValue
                )

                return OHHTTPStubsResponse(error: notConnectedError)
            }
        } else {
            newDescriptor = stub(condition: isPath(stubUrl.path)) { _ in
                let jsonFilePath = OHPathForFile(
                    jsonFile,
                    type(of: self).classForCoder()
                    ) ?? ""

                let stubsFixture = fixture(
                    filePath: jsonFilePath,
                    status: 200,
                    headers: ["Content-Type": "application/json"]
                )

                return stubsFixture.requestTime(
                    downloadSpeed,
                    responseTime: responseTime
                )
            }
        }

        newDescriptor.name = stubName
        registeredDescriptors[stubName] = newDescriptor
    }

    func removeStub(stubName: String) {
        guard let descriptor = registeredDescriptors.removeValue(forKey: stubName) else {
            self.log("removeStub() - There's no stub registered with the name \(stubName).")
            return
        }

        if OHHTTPStubs.removeStub(descriptor) {
            self.log("removeStub() - Removed the stub with name: \(stubName).")
        } else {
            self.log("removeStub() - Couldn't remove the stub with name: \(stubName).")
            registeredDescriptors[stubName] = descriptor // Re-add it so we won't lose the reference to it
        }
    }

    func removeAllStubs() {
        self.log("removeAllStubs() - Removing all stubs...")
        registeredDescriptors.forEach { key, _ in registeredDescriptors.removeValue(forKey: key) }
        self.log("removeAllStubs() - All stubs removed.")
    }
}
