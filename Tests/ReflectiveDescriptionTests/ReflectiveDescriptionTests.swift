import XCTest
import ReflectiveDescription

final class ReflectiveDescriptionTests: XCTestCase {
    
    func testWithString() {
        let string = "String Value"
        let expectedDescription = "(String) \(string)"
        assert(descriptionOf: string, isEqualTo: expectedDescription)
    }
    
    func testWithInteger() {
        assert(descriptionOf: 1, isEqualTo: "(Int) 1")
    }
    
    func testWithDouble() {
        assert(descriptionOf: 1.2, isEqualTo: "(Double) 1.2")
    }
    
    func testWithOptionalIntWithSomeValue() {
        let optionalInt: Int? = 1
        assert(descriptionOf: optionalInt as Any, isEqualTo: "(Int?) 1")
    }
    
    func testWithOptionalNilInt() {
        let optionalInt: Int? = nil
        assert(descriptionOf: optionalInt as Any, isEqualTo: "(Int?) nil")
    }
    
    func testWithDoubleOptionalIntWithSomeValue() {
        let optionalInt: Int?? = 4
        assert(descriptionOf: optionalInt as Any, isEqualTo: "(Int??) 4")
    }
    
    func testWithTripleOptionalNilInt() {
        let optionalInt: Int??? = nil
        assert(descriptionOf: optionalInt as Any, isEqualTo: "(Int???) nil")
    }
    
    func testWithEmptyStruct() {
        let aStruct = EmptyStruct()
        assert(descriptionOf: aStruct, isEqualTo: """
                                                  EmptyStruct {
                                                  }
                                                  """
        )
    }
    
    func testWithOptionalNilStruct() {
        let aStruct: EmptyStruct? = nil
        assert(descriptionOf: aStruct as Any, isEqualTo: "(EmptyStruct?) nil")
    }
    
    func testWithOptionalEmptyStructWithSomeValue() {
        let aStruct: EmptyStruct? = EmptyStruct()
        assert(descriptionOf: aStruct as Any, isEqualTo: """
                                                  EmptyStruct? {
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
        let aStruct = StructA(intVar: 1, stringVar: "str")
        assert(descriptionOf: aStruct, isEqualTo: """
                                                  StructA {
                                                    intVar: (Int) 1
                                                    stringVar: (String) str
                                                  }
                                                  """
        )
    }
    
    func testWithOptionalStructWithSimpleFields() {
        let aStruct: StructA? = StructA(intVar: 1, stringVar: "str")
        assert(descriptionOf: aStruct as Any, isEqualTo: """
                                                  StructA? {
                                                    intVar: (Int) 1
                                                    stringVar: (String) str
                                                  }
                                                  """
        )
    }
    
    func testWithClassWithEmbeddedStructAndIntField() {
        let aClass = ClassA(intVar: 1, structVar: StructA(intVar: 2, stringVar: "Str"))
        assert(descriptionOf: aClass, isEqualTo: """
                                                  ClassA {
                                                    intVar: (Int) 1
                                                    structVar: StructA {
                                                      intVar: (Int) 2
                                                      stringVar: (String) Str
                                                    }
                                                  }
                                                  """
        )
    }
    
    func testWithArrayOfStrings() {
        let strings = ["Str 0", "Str 1", "Str 2"]
        assert(descriptionOf: strings, isEqualTo: """
                                                  Array<String> {
                                                    (String) Str 0
                                                    (String) Str 1
                                                    (String) Str 2
                                                  }
                                                  """
        )
    }
    
    func testWithOptionalArrayOfAny() {
        let array: [Any]? = [1, "Str", 1.2]
        assert(descriptionOf: array as Any, isEqualTo: """
                                                       Array<Any>? {
                                                         (Int) 1
                                                         (String) Str
                                                         (Double) 1.2
                                                       }
                                                       """
        )
    }
    
    func testWithArrayOfOptionalInt() {
        let array: [Int?] = [1, nil, 3]
        assert(descriptionOf: array, isEqualTo: """
                                                Array<Optional<Int>> {
                                                  (Int?) 1
                                                  (Int?) nil
                                                  (Int?) 3
                                                }
                                                """
        )
    }
    
    func testWithDictionary() {
        let dict: [String: Any] = ["intValue": 1, "stringValue": "Str"]
        assert(descriptionOf: dict, isEqualTo: """
                                               Dictionary<String, Any> {
                                                 (String) intValue : (Int) 1
                                                 (String) stringValue : (String) Str
                                               }
                                               """
        )
    }
    
    func testWithDictionaryWithDictionary() {
        let dict: [String: Any] = ["intValue": 1,
                                   "dictValue": ["stringValue": "Str"]]
        assert(descriptionOf: dict, isEqualTo: """
                                               Dictionary<String, Any> {
                                                 (String) dictValue : Dictionary<String, String> {
                                                   (String) stringValue : (String) Str
                                                 }
                                                 (String) intValue : (Int) 1
                                               }
                                               """
        )
    }
    
    func testWithDictionaryWithStruct() {
        let dict: [String: Any] = ["structValue": StructA(intVar: 1, stringVar: "str")]
        assert(descriptionOf: dict, isEqualTo: """
                                               Dictionary<String, Any> {
                                                 (String) structValue : StructA {
                                                   intVar: (Int) 1
                                                   stringVar: (String) str
                                                 }
                                               }
                                               """
        )
    }
    
    
    func testWithSubClass() {
        let aClass = ClassB(stringVar: "Str 0", intVar: 1, structVar: StructA(intVar: 2, stringVar: "Str"))
        assert(descriptionOf: aClass, isEqualTo: """
                                                  ClassB {
                                                    intVar: (Int) 1
                                                    structVar: StructA {
                                                      intVar: (Int) 2
                                                      stringVar: (String) Str
                                                    }
                                                    stringVar: (String) Str 0
                                                  }
                                                  """
        )
    }
    
    private func assert(descriptionOf subject: Any, isEqualTo expectedDescription: String, file: StaticString = #filePath, line: UInt = #line) {
        let actualDescription = reflectiveDescription(of: subject)
        XCTAssertEqual(expectedDescription, actualDescription, file: file, line: line)
    }
}

struct EmptyStruct {
}

class EmptyClass {
}

struct StructA {
    
    let intVar: Int
    let stringVar: String
}

class ClassA {
    
    let intVar: Int
    let structVar: StructA
    
    init(intVar: Int, structVar: StructA) {
        self.intVar = intVar
        self.structVar = structVar
    }
}

class ClassB: ClassA {

    let stringVar: String

    init(stringVar: String, intVar: Int, structVar: StructA) {
        self.stringVar = stringVar
        super.init(intVar: intVar, structVar: structVar)
    }
}
