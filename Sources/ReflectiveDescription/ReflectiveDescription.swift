import Foundation

public func reflectiveDescription(of subject: Any) -> String {
    return reflectiveDescription(of: subject, level: 0, nil)
}

private let optionalTypeNamePrefix = "Optional<"
private let singleIndent = "  "

private func reflectiveDescription(of subject: Any, level: Int, optionals: Int = 0, _ parentMirror: Mirror?) -> String {
    let mirror = Mirror(reflecting: subject)
    if mirror.isOptional {
        if let value = mirror.children.first?.value {
            return reflectiveDescription(of: value, level: level, optionals: optionals + 1, mirror)
        } else {
            return "(\(rewrap(mirror.typeName))) nil"
        }
    } else {
        return reflectiveDescription(ofNonOptional: subject, mirror, level, optionals, parentMirror)
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

private func reflectiveDescription(ofNonOptional subject: Any, _ mirror: Mirror, _ level: Int, _ optionals: Int = 0, _ parentMirror: Mirror?) -> String {
    let printableTypeName = (0..<optionals).reduce(mirror.typeName) { (name, _) in name + "?" }
    if mirror.isSimpleType {
        return "(\(printableTypeName)) \(subject)"
    } else {
        if mirror.children.isEmpty {
            return printableTypeName + " {\n}"
        } else {
            if let parentMirror = parentMirror, parentMirror.isDictionary {
                return mirror.children.map {
                    "\(reflectiveDescription(of: $0.value, level: level, mirror))"
                }.joined(separator: " : ")
            } else {
                let indent = Array(repeating: singleIndent, count: level).joined()
                let header = "\(printableTypeName) {"
                let footer = "\n\(indent)}"
                var childrenDescription = ""
                if let children = mirror.superclassMirror?.children, !children.isEmpty {
                    childrenDescription += reflectiveDescription(of: children, indent, level, mirror)
                }
                childrenDescription += reflectiveDescription(of: mirror.children, indent, level, mirror)
                return header + childrenDescription + footer
            }
        }
    }
}

private func reflectiveDescription(of children: Mirror.Children, _ indent: String, _ level: Int, _ parentMirror: Mirror?) -> String {
    var lines = children.map { child -> String in
        var line = "\n\(indent)\(singleIndent)"
        if let label = child.label {
            line += "\(label): "
        }
        line += "\(reflectiveDescription(of: child.value, level: level + 1, parentMirror))"
        return line
    }
    if let parentMirror = parentMirror, parentMirror.isDictionary {
        lines.sort()
    }
    return lines.joined()
}

extension Mirror {
    
    var typeName: String {
        "\(subjectType)"
    }
    
    var isOptional: Bool {
        displayStyle == .optional
    }
    
    var isSimpleType: Bool {
        displayStyle == nil
    }
    
    var isDictionary: Bool {
        displayStyle == .dictionary
    }
}
