
public protocol FromInMapMappable {
    
    init<Source : InMap>(from source: Source) throws
    
}

/// Entity which can be mapped (initialized) from any structured data type.
public protocol InMappable : FromInMapMappable {
    
    associatedtype MappingKeys : Key
    
    /// Creates instance from instance of `Source` packed into mapper with type-specific `MappingKeys`.
    init<Source>(mapper: InMapper<Source, MappingKeys>) throws
    
}

extension InMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        let mapper = InMapper<Source, MappingKeys>(of: source)
        try self.init(mapper: mapper)
    }
    
}

public protocol BasicInMappable : FromInMapMappable {
    
    init<Source>(mapper: BasicInMapper<Source>) throws
    
}

extension BasicInMappable {
    
    /// Creates instance from `source`.
    public init<Source : InMap>(from source: Source) throws {
        let mapper = BasicInMapper<Source>(of: source)
        try self.init(mapper: mapper)
    }
    
}

/// Entity which can be mapped (initialized) from any structured data type in multiple ways using user-determined context instance.
public protocol InMappableWithContext {
    
    associatedtype MappingContext
    associatedtype MappingKeys: Key
    
    /// Creates instance from instance of `Source` packed into contextual mapper with type-specific `MappingKeys`.
    init<Source>(mapper: ContextualInMapper<Source, MappingKeys, MappingContext>) throws
    
}

extension InMappableWithContext {
    
    /// Creates instance from `source` using given context.
    public init<Source : InMap>(from source: Source, withContext context: MappingContext) throws {
        let mapper = ContextualInMapper<Source, MappingKeys, MappingContext>(of: source, context: context)
        try self.init(mapper: mapper)
    }
    
}

extension Optional {
    
    fileprivate func unwrapped() throws -> Wrapped {
        if let unwr = self {
            return unwr
        } else {
            throw InMapperError.wrongType(Wrapped.self)
        }
    }
    
}

extension Int : FromInMapMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        self = try source.int.unwrapped()
    }
    
}

extension Double : FromInMapMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        self = try source.double.unwrapped()
    }
    
}

extension Bool : FromInMapMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        self = try source.bool.unwrapped()
    }
    
}

extension String : FromInMapMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        self = try source.string.unwrapped()
    }
    
}

extension Int8 : FromInMapMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        self = try source.int8.unwrapped()
    }
    
}

extension Int16 : FromInMapMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        self = try source.int16.unwrapped()
    }
    
}

extension Int32 : FromInMapMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        self = try source.int32.unwrapped()
    }
    
}

extension Int64 : FromInMapMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        self = try source.int64.unwrapped()
    }
    
}

extension Float : FromInMapMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        self = try source.float.unwrapped()
    }
    
}

extension UInt : FromInMapMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        self = try source.uint.unwrapped()
    }
    
}

extension UInt8 : FromInMapMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        self = try source.uint8.unwrapped()
    }
    
}

extension UInt16 : FromInMapMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        self = try source.uint16.unwrapped()
    }
    
}

extension UInt32 : FromInMapMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        self = try source.uint32.unwrapped()
    }
    
}

extension UInt64 : FromInMapMappable {
    
    public init<Source>(from source: Source) throws where Source : InMap {
        self = try source.uint64.unwrapped()
    }
    
}
