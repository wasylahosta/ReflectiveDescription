import Foundation

public func reflectiveDescription(of subject: Any) -> String {
    return reflectiveDescription(of: subject, level: 0)
}

private let optionalTypeNamePrefix = "Optional<"
private let singleIndent = "  "

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
        let isDictionary = typeName.hasPrefix("Dictionary<")
        if !isDictionaryElement {
            let indent = Array(repeating: singleIndent, count: level).joined()
            let header = "\(printableTypeName) {"
            let footer = "\n\(indent)}"
            var childrenDescription = ""
            if let children = mirror.superclassMirror?.children, !children.isEmpty {
                childrenDescription += reflectiveDescription(of: children, indent, level, isDictionary)
            }
            childrenDescription += reflectiveDescription(of: mirror.children, indent, level, isDictionary)
            return header + childrenDescription + footer
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

private func reflectiveDescription(of children: Mirror.Children, _ indent: String, _ level: Int, _ isDictionary: Bool) -> String {
    var lines = children.map { child -> String in
        var line = "\n\(indent)\(singleIndent)"
        if let label = child.label {
            line += "\(label): "
        }
        line += "\(reflectiveDescription(of: child.value, level: level + 1, isDictionaryElement: isDictionary))"
        return line
    }
    if isDictionary {
        lines.sort()
    }
    return lines.joined()
}
