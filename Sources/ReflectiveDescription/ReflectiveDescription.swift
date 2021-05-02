import Foundation

public func reflectiveDescription(of subject: Any) -> String {
    return reflectiveDescription(of: subject, level: 0)
}

private func reflectiveDescription(of subject: Any, level: Int, optionals: Int = 0) -> String {
    let mirror = Mirror(reflecting: subject)
    let typeName = "\(mirror.subjectType)"
    let printableTypeName = (0..<optionals).reduce(typeName) { (name, _) in name + "?" }
    let optionalTypeNamePrefix = "Optional<"
    if typeName.hasPrefix(optionalTypeNamePrefix) {
        if let value = mirror.children.first?.value {
            return reflectiveDescription(of: value, level: level, optionals: optionals + 1)
        } else {
            let wrappedType = typeName.dropFirst(optionalTypeNamePrefix.count).dropLast()
            return "(\(wrappedType)?) nil"
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
        let indent = Array(repeating: singleIndent, count: level).joined()
        return mirror.children.reduce("\(printableTypeName) {") { result, child in
            var line = "\n\(indent)\(singleIndent)"
            if let label = child.label {
                line += "\(label): "
            }
            line += "\(reflectiveDescription(of: child.value, level: level + 1))"                
            return result + line
        } + "\n\(indent)}"
    }
}
