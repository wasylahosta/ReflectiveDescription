import Foundation

public func reflectiveDescription(of subject: Any) -> String {
    return reflectiveDescription(of: subject, level: 0)
}

private let optionalTypeNamePrefix = "Optional<"

private func reflectiveDescription(of subject: Any, level: Int, optionals: Int = 0, isDictionaryElement: Bool = false) -> String {
    let mirror = Mirror(reflecting: subject)
    let typeName = "\(mirror.subjectType)"
    let printableTypeName = (0..<optionals).reduce(typeName) { (name, _) in name + "?" }
    if typeName.hasPrefix(optionalTypeNamePrefix) {
        if let value = mirror.children.first?.value {
            return reflectiveDescription(of: value, level: level, optionals: optionals + 1)
        } else {
            return "(\(rewrap(typeName))) nil"
        }
    }
    if mirror.children.isEmpty {
        let value = "\(subject)"
        if value.contains(typeName) && !typeName.contains("String") {
            return printableTypeName + " {\n}"
        } else {
            return "(\(printableTypeName)) \(value)"
        }
    } else {
        let singleIndent = "  "
        let isDictionary = typeName.hasPrefix("Dictionary<")
        if !isDictionaryElement {
            let indent = Array(repeating: singleIndent, count: level).joined()
            return mirror.children.reduce("\(printableTypeName) {") { result, child in
                var line = "\n\(indent)\(singleIndent)"
                if let label = child.label {
                    line += "\(label): "
                }
                line += "\(reflectiveDescription(of: child.value, level: level + 1, isDictionaryElement: isDictionary))"
                return result + line
            } + "\n\(indent)}"
        } else {
            return mirror.children.map {
                "\(reflectiveDescription(of: $0.value, level: level, isDictionaryElement: isDictionary))"
            }.joined(separator: " : ")
        }
    }
}

private func rewrap(_ typeName: String) -> String {
    let wrappedType = unwrap(typeName)
    if wrappedType.hasPrefix(optionalTypeNamePrefix) {
        return rewrap(wrappedType) + "?"
    } else {
        return wrappedType + "?"
    }
}

private func unwrap(_ typeName: String) -> String {
    return String(typeName.dropFirst(optionalTypeNamePrefix.count).dropLast())
}
