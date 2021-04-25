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
    
    func testWithEmptyStruct() {
        let aStruct = EmptyStruct()
        assert(descriptionOf: aStruct, isEqualTo: """
                                                  EmptyStruct {
                                                  }
                                                  """
        )
    }
    
    func testWithEmptyClass() {
        let aClass = EmptyClass()
        assert(descriptionOf: aClass, isEqualTo: """
                                                  EmptyClass {
                                                  }
                                                  """
        )
    }
    
    func testWithStructWithSimpleFields() {
        let aStruct = StructA(int: 1, string: "str")
        assert(descriptionOf: aStruct, isEqualTo: """
                                                  StructA {
                                                    int: Int = 1
                                                    string: String = str
                                                  }
                                                  """
        )
    }
    
    func testWithClassWithEmbeddedStructAndIntField() {
        let aClass = ClassA(int: 1, struct: StructA(int: 2, string: "Str"))
        assert(descriptionOf: aClass, isEqualTo: """
                                                  ClassA {
                                                    int: Int = 1
                                                    struct: StructA {
                                                      int: Int = 2
                                                      string: String = Str
                                                    }
                                                  }
                                                  """
        )
    }
    
    func _testWithArrayOfStrings() {
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

struct EmptyStruct {
}

class EmptyClass {
}

struct StructA {
    
    let int: Int
    let string: String
}

class ClassA {
    
    let int: Int
    let `struct`: StructA
    
    init(int: Int, struct: StructA) {
        self.int = int
        self.struct = `struct`
    }
}
