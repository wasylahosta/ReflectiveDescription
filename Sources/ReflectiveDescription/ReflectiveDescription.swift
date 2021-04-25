
public func reflectiveDescription<T>(of subject: T) -> String {
    return "\(type(of: subject)) = \(subject)"
}

public func reflectiveDescription<T>(of subject: T?) -> String {
    let value = subject.flatMap { "\($0)" } ?? "nil"
    return "\(T.self)? = \(value)"
}
