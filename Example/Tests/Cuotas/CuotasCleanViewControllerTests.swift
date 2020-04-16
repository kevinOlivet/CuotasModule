//
//  CuotasCleanViewControllerTests.swift
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

class CuotasCleanViewControllerTests: XCTestCase {
    // MARK: Subject under test
    var sut: CuotasCleanViewController!
    var spyInteractor: CuotasCleanBusinessLogicSpy!
    var spyRouter: CuotasCleanRoutingLogicSpy!
    var window: UIWindow!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        window = UIWindow()
        setupCuotasCleanViewController()
    }

    override  func tearDown() {
        spyInteractor = nil
        spyRouter = nil
        sut = nil
        window = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupCuotasCleanViewController() {
        let bundle = Utils.bundle(forClass: CuotasCleanViewController.classForCoder())!
        let storyboard = UIStoryboard(name: "CuotasMain", bundle: bundle)
        sut = (
            storyboard.instantiateViewController(
                withIdentifier: "CuotasCleanViewController"
                ) as! CuotasCleanViewController
        )

        spyInteractor = CuotasCleanBusinessLogicSpy()
        sut.interactor = spyInteractor

        spyRouter = CuotasCleanRoutingLogicSpy()
        sut.router = spyRouter

        loadView()
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Tests

    func testViewDidLoad() {
        // Given
        // When
        // Then
        XCTAssertNotNil(
            sut,
            "the view should instantiate correctly"
        )
        XCTAssertTrue(
            spyInteractor.prepareSetUpUICalled,
            "viewDidLoad should call the interactor to setup the UI"
        )
        XCTAssertTrue(
            spyInteractor.prepareSetUpUICalled,
            "viewDidLoad should call the interactor to setup the UI"
        )
        XCTAssertTrue(
            spyInteractor.getCuotasCalled,
            "viewDidLoad should call the interactor getCuotas"
        )
    }
    func testRequiredInit() {
        // Given
        sut = nil
        XCTAssertNil(
            sut,
            "setting the sut to nil to test its other init"
        )
        // When
        let archiver = NSKeyedUnarchiver(forReadingWith: Data())
        sut = CuotasCleanViewController(coder: archiver)
        // Then
        XCTAssertNotNil(
            sut,
            "sut instantiated using the overrideInit"
        )
        XCTAssertTrue(
            spyInteractor.prepareSetUpUICalled,
            "viewDidLoad should call the interactor to setup the UI"
        )
        XCTAssertTrue(
            spyInteractor.getCuotasCalled,
            "viewDidLoad should call the interactor getCuotas"
        )
    }
    func testDisplaySetupUI() {
        // Given
        let viewModel = CuotasClean.Texts.ViewModel(title: "testTitle")
        // When
        sut.displaySetUpUI(viewModel: viewModel)
        // Then
        XCTAssertEqual(
            sut.titleText,
            "testTitle",
            "displaySetUpUI should set the title correctly"
        )
    }
    func testDisplaySpinner() {
        // Given
        // When
        sut.displaySpinner()
        // Then
        XCTAssertNotNil(
            sut.spinner,
            "display spinner should instantiate the spinner"
        )
        XCTAssertFalse(
            sut.spinner.isHidden,
            "spinner should show"
        )
    }
    func testHideSpinner() {
        // Given
        sut.displaySpinner()
        XCTAssertNotNil(
            sut.spinner,
            "display spinner should instantiate the spinner"
        )
        XCTAssertFalse(
            sut.spinner.isHidden,
            "spinner should show"
        )
        // When
        sut.hideSpinner()
        // Then
        XCTAssertTrue(
            sut.spinner.isHidden,
            "spinner should hide when told to do so"
        )
    }
    func testDisplayErrorAlert() {
           // Given
           let viewModel = CuotasClean.Cuotas.ViewModel.Failure(
               errorTitle: "testErrorTitle",
               errorMessage: "testErrorMessage",
               buttonTitle: "testButtonTitle"
           )
           // When
           sut.displayErrorAlert(viewModel: viewModel)
           // Then
           XCTAssertTrue(
               sut.presentedViewController is UIAlertController,
               "displayInputAlert should present an alert"
           )
           guard let alert = sut.presentedViewController as? UIAlertController else {
               XCTFail("The alert didn't get presented")
               return
           }
           XCTAssertEqual(
               alert.title,
               "testErrorTitle",
               "should be the title"
           )
           XCTAssertEqual(
               alert.message,
               "testErrorMessage",
               "should be the message"
           )
       }
    func testDisplayCuotasArray() {
        // Given
        let item = CuotasClean.Cuotas.ViewModel.DisplayCuota(
            installments: "testInstallments",
            recommendedMessage: "testRecommendedMessage"
        )
        let viewModel = CuotasClean.Cuotas.ViewModel.Success(cuotasModelArray: [item])
        // When
        sut.displayCuotasArray(viewModel: viewModel)
        // Then
        XCTAssertEqual(
            sut.cuotasArrayDisplay.first!.installments,
            "testInstallments",
            "should equal what is passed."
        )
    }
    func testCellForRow() {
        // Given
        let item = CuotasClean.Cuotas.ViewModel.DisplayCuota(
            installments: "testInstallments",
            recommendedMessage: "testRecommendedMessage"
        )
        let cuotasArrayDisplay = [item]
        sut.cuotasArrayDisplay = cuotasArrayDisplay
        sut.tableView.reloadData()
        let indexPathToUse = IndexPath(row: 0, section: 0)
        // When
        let cell = sut.tableView(sut.tableView, cellForRowAt: indexPathToUse)
        XCTAssertTrue(cell is CuotasTableViewCell, "cell should be CuotasTableViewCell")
        guard let cuotaCell = cell as? CuotasTableViewCell else {
            XCTFail("cell is not CuotasTableViewCell")
            return
        }
        XCTAssertEqual(
            cuotaCell.numberOfInstallmentsLabel.text,
            "testInstallments",
            "should equal the name passed to the cell"
        )
        XCTAssertEqual(
            cuotaCell.recommendedMessageLabel.text,
            "testRecommendedMessage",
            "should equal the name passed to the cell"
        )
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
