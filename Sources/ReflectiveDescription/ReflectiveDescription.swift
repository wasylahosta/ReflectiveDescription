import Foundation

public func reflectiveDescription<T>(of subject: T, level: Int = 0) -> String {
    let mirror = Mirror(reflecting: subject)
    let typeName = "\(mirror.subjectType)"
    if mirror.children.isEmpty {
        let value = "\(subject)"
        if value.contains(typeName) && !typeName.contains("String") {
            return typeName + " {\n}"
        } else {
            return typeName + " = " + value
        }
    } else {
        let singleIndent = "  "
        let indent = Array(repeating: singleIndent, count: level).joined()
        return mirror.children.reduce("\(typeName) {") { result, child in
            result + "\n\(indent)\(singleIndent)\(child.label!): \(reflectiveDescription(of: child.value, level: level + 1))"
        } + "\n\(indent)}"
    }
}

public func reflectiveDescription<T>(of subject: T?) -> String {
    let value = subject.flatMap { "\($0)" } ?? "nil"
    return "\(T.self)? = \(value)"
}
