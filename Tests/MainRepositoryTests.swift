//
//  Module_11_practicumTests.swift
//  Module_11_practicumTests
//
//  Created by Mikhail Borisov on 27.11.2023.
//

import XCTest
@testable import MultithreadingiOSCase

final class MainRepositoryTests: XCTestCase {

    func test_mainRepository_in_concurrence_way() {
        // Arrange
        let repository = MainRepository()

        // Act
        DispatchQueue.concurrentPerform(iterations: 100_000) { _ in
            repository.currentAmount += 1
        }

        XCTAssertEqual(repository.currentAmount, 100_000)
    }
}
