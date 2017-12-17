//
//  BalanceIncreaseBalanceIncreasePresenterTests.swift
//  TinkoffApp
//
//  Created by MukhinAlexey on 14/12/2017.
//  Copyright © 2017 Tinkoff. All rights reserved.
//

import XCTest

class BalanceIncreasePresenterTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    class MockInteractor: BalanceIncreaseInteractorInput {

    }

    class MockRouter: BalanceIncreaseRouterInput {

    }

    class MockViewController: BalanceIncreaseViewInput {

        func setupInitialState() {

        }
    }
}
