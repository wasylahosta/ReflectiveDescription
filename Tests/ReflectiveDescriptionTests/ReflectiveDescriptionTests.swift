import XCTest
import ReflectiveDescription

final class ReflectiveDescriptionTests: XCTestCase {
    
    func testWithString() {
        let string = "String Value"
        let expectedDescription = "String = \(string)"
        assert(descriptionOf: string, isEqualTo: expectedDescription)
    }
    
    func testWithInteger() {
        assert(descriptionOf: 1, isEqualTo: "Int = 1")
    }
    
    func testWithDouble() {
        assert(descriptionOf: 1.2, isEqualTo: "Double = 1.2")
    }
    
    func testWithOptionalIntWithSomeValue() {
        let optionalInt: Int? = 1
        assert(descriptionOf: optionalInt, isEqualTo: "Int? = 1")
    }
    
    func testWithOptionalNilInt() {
        let optionalInt: Int? = nil
        assert(descriptionOf: optionalInt, isEqualTo: "Int? = nil")
    }
    
    func testWithArrayOfStrings() {
        let strings = ["Str 0", "Str 1", "Str 2"]
        assert(descriptionOf: strings, isEqualTo: "[String] = [Str 0; Str 1; Str 2]")
    }
    
    private func assert<T>(descriptionOf subject: T, isEqualTo expectedDescription: String, file: StaticString = #filePath, line: UInt = #line) {
        let actualDescription = reflectiveDescription(of: subject)
        XCTAssertEqual(expectedDescription, actualDescription, file: file, line: line)
    }
    
    private func assert<T>(descriptionOf subject: T?, isEqualTo expectedDescription: String, file: StaticString = #filePath, line: UInt = #line) {
        let actualDescription = reflectiveDescription(of: subject)
        XCTAssertEqual(expectedDescription, actualDescription, file: file, line: line)
    }
}
