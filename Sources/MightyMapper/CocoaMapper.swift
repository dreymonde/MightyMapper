
struct CocoaAny {
    var value: Any
}

extension CocoaAny : InMap {
    
    func get<T>() -> T? {
        return value as? T
    }
    
    func get(at index: MappingIndex) -> CocoaAny? {
        let key = index.rawValue
        if let dict = value as? [String: Any] {
            return dict[key].map(CocoaAny.init)
        }
        return nil
    }
    
    var int: Int? {
        return value as? Int
    }
    
    var string: String? {
        return value as? String
    }
    
    var double: Double? {
        return value as? Double
    }
    
    var bool: Bool? {
        return value as? Bool
    }
    
    var float: Float? {
        return value as? Float
    }
    
    var int8: Int8? {
        return value as? Int8
    }
    
    var int16: Int16? {
        return value as? Int16
    }
    
    var int32: Int32? {
        return value as? Int32
    }
    
    var int64: Int64? {
        return value as? Int64
    }
    
    var uint: UInt? {
        return value as? UInt
    }
    
    var uint8: UInt8? {
        return value as? UInt8
    }
    
    var uint16: UInt16? {
        return value as? UInt16
    }
    
    var uint32: UInt32? {
        return value as? UInt32
    }
    
    var uint64: UInt64? {
        return value as? UInt64
    }
    
    func asArray() -> [CocoaAny]? {
        if let array = value as? [[String: Any]] {
            return array.map(CocoaAny.init)
        }
        if let array = value as? [Any] {
            return array.map(CocoaAny.init)
        }
        return nil
    }
    
}

public enum CocoaOutMappingError : Error {
    case notDictionary
    case notArray
}

extension CocoaAny : OutMap {
    
    mutating func set(_ map: CocoaAny?, at index: MappingIndex) throws {
        guard let map = map else { return }
        let newValue = map.value
        let key = index.rawValue
        if var dict = value as? [String: Any] {
            dict[key] = newValue
            self.value = dict
            return
        }
        throw CocoaOutMappingError.notDictionary
    }
    
    static func fromArray(_ array: [CocoaAny]) -> CocoaAny? {
        return CocoaAny(value: array.map({ $0.value }))
    }
    
    static func from<T>(_ value: T) -> CocoaAny? {
        return CocoaAny(value: value)
    }
    
    static func fromInt(_ int: Int) -> CocoaAny? {
        return CocoaAny(value: int)
    }
    
    static func fromDouble(_ double: Double) -> CocoaAny? {
        return CocoaAny(value: double)
    }
    
    static func fromString(_ string: String) -> CocoaAny? {
        return CocoaAny(value: string)
    }
    
    static func fromBool(_ bool: Bool) -> CocoaAny? {
        return CocoaAny(value: bool)
    }
    
    static var blank: CocoaAny {
        return CocoaAny(value: [String: Any]())
    }
    
}

extension InMappable {
    
    /// Creates instance from `dict`.
    public init(from dict: [String: Any]) throws {
        let mapper = InMapper<CocoaAny, MappingKeys>(of: .init(value: dict))
        try self.init(mapper: mapper)
    }
    
}

extension BasicInMappable {
    
    /// Creates instance from `dict`.
    public init(from dict: [String: Any]) throws {
        let mapper = BasicInMapper<CocoaAny>(of: .init(value: dict))
        try self.init(mapper: mapper)
    }
    
}

extension InMappableWithContext {
    
    /// Creates instance from `dict` using given context.
    public init(from dict: [String: Any], withContext context: MappingContext) throws {
        let mapper = ContextualInMapper<CocoaAny, MappingKeys, MappingContext>(of: .init(value: dict), context: context)
        try self.init(mapper: mapper)
    }
    
}

extension OutMappable {
    
    /// Maps `self` to `[String: Any]` dictionary.
    ///
    /// - parameter destination: instance to map to. Leave it .blank if you want to create your instance from scratch.
    ///
    /// - throws: `OutMapperError`.
    ///
    /// - returns: `[String: Any]` dictionary created from `self`.
    public func map() throws -> [String: Any] {
        var mapper = OutMapper<CocoaAny, MappingKeys>()
        try outMap(mapper: &mapper)
        if let dict = mapper.destination.value as? [String: Any] {
            return dict
        }
        throw CocoaOutMappingError.notDictionary
    }
    
}

extension BasicOutMappable {
    
    /// Maps `self` to `[String: Any]` dictionary.
    ///
    /// - parameter destination: instance to map to. Leave it .blank if you want to create your instance from scratch.
    ///
    /// - throws: `OutMapperError`.
    ///
    /// - returns: `[String: Any]` dictionary created from `self`.
    public func map() throws -> [String: Any] {
        var mapper = BasicOutMapper<CocoaAny>()
        try outMap(mapper: &mapper)
        if let dict = mapper.destination.value as? [String: Any] {
            return dict
        }
        throw CocoaOutMappingError.notDictionary
    }
    
}

extension OutMappableWithContext {
    
    /// Maps `self` to `[String: Any]` dictionary using `context`.
    ///
    /// - parameter destination: instance to map to. Leave it .blank if you want to create your instance from scratch.
    /// - parameter context:     use `context` to describe the way of mapping.
    ///
    /// - throws: `OutMapperError`.
    ///
    /// - returns: `[String: Any]` dictionary created from `self`.
    public func outMap(withContext context: MappingContext) throws -> [String: Any] {
        var mapper = ContextualOutMapper<CocoaAny, MappingKeys, MappingContext>(context: context)
        try outMap(mapper: &mapper)
        if let dict = mapper.destination.value as? [String: Any] {
            return dict
        }
        throw CocoaOutMappingError.notDictionary
    }
    
}
