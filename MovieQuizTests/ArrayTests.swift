//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Кира on 25.05.2023.
//

import Foundation
import XCTest

@testable import MovieQuiz

class ArrayTests: XCTest {
    func testGetValueInRange() throws {
        //given
        let array = [1, 2, 3, 4, 5]
        
        //when
        let value = array[safe: 2]
        
        //then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        //given
        let array = [1, 2, 3, 4, 5]
        
        //when
        let value = array[safe: 2]
        
        //then
        XCTAssertNil(value)
        
    }
}
