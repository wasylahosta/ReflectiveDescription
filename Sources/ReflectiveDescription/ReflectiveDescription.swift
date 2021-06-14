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
        return reflectiveDescription(ofNonOptionalOrUnwrapped: subject, mirror, level, optionals, parentMirror)
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

private func reflectiveDescription(ofNonOptionalOrUnwrapped subject: Any, _ mirror: Mirror, _ level: Int, _ optionals: Int = 0, _ parentMirror: Mirror?) -> String {
    var printableTypeName = (0..<optionals).reduce(mirror.typeName) { (name, _) in name + "?" }
    if mirror.isSimpleType {
        if mirror.isString {
            return "(\(printableTypeName)) \"\(subject)\""
        } else {
            return "(\(printableTypeName)) \(subject)"
        }
    } else if mirror.isEnum {
        return reflectiveDescription(ofEnum: subject, mirror, level, printableTypeName)
    } else {
        if mirror.isTuple {
            printableTypeName = "Tuple"
        }
        if mirror.children.isEmpty {
            return printableTypeName + " {}"
        } else {
            if let parentMirror = parentMirror, parentMirror.isDictionary {
                return reflectiveDescription(ofDictionaryMembers: mirror, level)
            } else if let parentMirror = parentMirror, parentMirror.isEnum {
                return reflectiveDescription(ofEnumAssociatedValues: mirror, level)
            } else {
                let indent = indent(for: level)
                let header = "\(printableTypeName) {"
                var childrenDescription = ""
                if let children = mirror.superclassMirror?.children, !children.isEmpty {
                    childrenDescription += reflectiveDescription(of: children, indent, level, mirror)
                }
                childrenDescription += reflectiveDescription(of: mirror.children, indent, level, mirror)
                return header + childrenDescription + footer(for: level)
            }
        }
    }
}

private func reflectiveDescription(ofEnum subject: Any, _ mirror: Mirror, _ level: Int, _ printableTypeName: String) -> String {
    if let child = mirror.children.first {
        return "(\(printableTypeName)) \(child.label!) {\n" +
            reflectiveDescription(of: child.value, level: level + 1, mirror) +
            footer(for: level)
    } else {
        return "(\(printableTypeName)) \(subject)"
    }
}

private func reflectiveDescription(ofEnumAssociatedValues mirror: Mirror, _ level: Int) -> String {
    let indent = indent(for: level)
    return mirror.children.map {
        "\(indent)\($0.label!): \(reflectiveDescription(of: $0.value, level: level, mirror))"
    }.joined(separator: "\n")
}

private func reflectiveDescription(ofDictionaryMembers mirror: Mirror, _ level: Int) -> String {
    return mirror.children.map {
        "\(reflectiveDescription(of: $0.value, level: level, mirror))"
    }.joined(separator: " : ")
}

private func indent(for level: Int) -> String {
    Array(repeating: singleIndent, count: level).joined()
}

private func footer(for level: Int) -> String {
    "\n\(indent(for: level))}"
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
    
    var isString: Bool {
        typeName.contains("String")
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
    
    var isEnum: Bool {
        displayStyle == .enum
    }
    
    var isTuple: Bool {
        displayStyle == .tuple
    }
}
