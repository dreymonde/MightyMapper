
public protocol ToOutMapMappable {
    
    func outMap<Destination : OutMap>(to destination: Destination) throws -> Destination
    
}

extension ToOutMapMappable {
    
    func outMap<Destination : OutMap>() throws -> Destination {
        return try outMap(to: .blank)
    }
    
}

/// Entity which can be mapped to any structured data type.
public protocol OutMappable : ToOutMapMappable {
    
    associatedtype MappingKeys : MapperKey
    
    /// Maps instance data to `mapper`.
    ///
    /// - parameter mapper: wraps the actual structured data instance.
    ///
    /// - throws: `OutMapperError`.
    func outMap<Destination>(mapper: inout OutMapper<Destination, MappingKeys>) throws
    
}

extension OutMappable {
    
    public func outMap<Destination : OutMap>(to destination: Destination) throws -> Destination {
        var mapper = OutMapper<Destination, MappingKeys>(of: destination)
        try outMap(mapper: &mapper)
        return mapper.destination
    }
    
}

public protocol BasicOutMappable : ToOutMapMappable {
    
    func outMap<Destination>(mapper: inout BasicOutMapper<Destination>) throws
    
}

extension BasicOutMappable {
    
    /// Maps `self` to `Destination` structured data instance.
    ///
    /// - parameter destination: instance to map to. Leave it .blank if you want to create your instance from scratch.
    ///
    /// - throws: `OutMapperError`.
    ///
    /// - returns: structured data instance created from `self`.
    public func outMap<Destination : OutMap>(to destination: Destination) throws -> Destination {
        var mapper = BasicOutMapper<Destination>(of: destination)
        try outMap(mapper: &mapper)
        return mapper.destination
    }
    
}

/// Entity which can be mapped to any structured data type in multiple ways using user-determined context instance.
public protocol OutMappableWithContext {
    
    associatedtype MappingKeys : MapperKey
    
    /// Context allows user to map data in different ways.
    associatedtype MappingContext
    
    
    /// Maps instance data to contextual `mapper`.
    ///
    /// - parameter mapper: wraps the actual structured data instance.
    ///
    /// - throws: `OutMapperError`
    func outMap<Destination>(mapper: inout ContextualOutMapper<Destination, MappingKeys, MappingContext>) throws
    
}

extension OutMappableWithContext {
    
    /// Maps `self` to `Destination` structured data instance using `context`.
    ///
    /// - parameter destination: instance to map to. Leave it .blank if you want to create your instance from scratch.
    /// - parameter context:     use `context` to describe the way of mapping.
    ///
    /// - throws: `OutMapperError`.
    ///
    /// - returns: structured data instance created from `self`.
    public func outMap<Destination : OutMap>(to destination: Destination = .blank, withContext context: MappingContext) throws -> Destination {
        var mapper = ContextualOutMapper<Destination, MappingKeys, MappingContext>(of: destination, context: context)
        try outMap(mapper: &mapper)
        return mapper.destination
    }
        
}

extension Optional {
    
    fileprivate func outmap_unwrapped() throws -> Wrapped {
        guard let val = self else {
            throw OutMapperError.wrongType(Wrapped.self)
        }
        return val
    }
    
}

extension Int : ToOutMapMappable {
    
    public func outMap<Destination>(to destination: Destination) throws -> Destination where Destination : OutMap {
        var copy = destination
        try copy.set(try Destination.fromInt(self).outmap_unwrapped(), at: [])
        return copy
    }
    
}

extension Double : ToOutMapMappable {
    
    public func outMap<Destination>(to destination: Destination) throws -> Destination where Destination : OutMap {
        var copy = destination
        try copy.set(try Destination.fromDouble(self).outmap_unwrapped(), at: [])
        return copy
    }
    
}

extension Bool : ToOutMapMappable {
    
    public func outMap<Destination>(to destination: Destination) throws -> Destination where Destination : OutMap {
        var copy = destination
        try copy.set(try Destination.fromBool(self).outmap_unwrapped(), at: [])
        return copy
    }
    
}

extension String : ToOutMapMappable {
    
    public func outMap<Destination>(to destination: Destination) throws -> Destination where Destination : OutMap {
        var copy = destination
        try copy.set(try Destination.fromString(self).outmap_unwrapped(), at: [])
        return copy
    }
    
}

extension Float : ToOutMapMappable {
    
    public func outMap<Destination>(to destination: Destination) throws -> Destination where Destination : OutMap {
        var copy = destination
        try copy.set(try Destination.fromFloat(self).outmap_unwrapped(), at: [])
        return copy
    }
    
}

extension Int8 : ToOutMapMappable {
    
    public func outMap<Destination>(to destination: Destination) throws -> Destination where Destination : OutMap {
        var copy = destination
        try copy.set(try Destination.fromInt8(self).outmap_unwrapped(), at: [])
        return copy
    }
    
}

extension Int16 : ToOutMapMappable {
    
    public func outMap<Destination>(to destination: Destination) throws -> Destination where Destination : OutMap {
        var copy = destination
        try copy.set(try Destination.fromInt16(self).outmap_unwrapped(), at: [])
        return copy
    }
    
}

extension Int32 : ToOutMapMappable {
    
    public func outMap<Destination>(to destination: Destination) throws -> Destination where Destination : OutMap {
        var copy = destination
        try copy.set(try Destination.fromInt32(self).outmap_unwrapped(), at: [])
        return copy
    }
    
}

extension Int64 : ToOutMapMappable {
    
    public func outMap<Destination>(to destination: Destination) throws -> Destination where Destination : OutMap {
        var copy = destination
        try copy.set(try Destination.fromInt64(self).outmap_unwrapped(), at: [])
        return copy
    }
    
}

extension UInt : ToOutMapMappable {
    
    public func outMap<Destination>(to destination: Destination) throws -> Destination where Destination : OutMap {
        var copy = destination
        try copy.set(try Destination.fromUInt(self).outmap_unwrapped(), at: [])
        return copy
    }
    
}

extension UInt8 : ToOutMapMappable {
    
    public func outMap<Destination>(to destination: Destination) throws -> Destination where Destination : OutMap {
        var copy = destination
        try copy.set(try Destination.fromUInt8(self).outmap_unwrapped(), at: [])
        return copy
    }
    
}

extension UInt16 : ToOutMapMappable {
    
    public func outMap<Destination>(to destination: Destination) throws -> Destination where Destination : OutMap {
        var copy = destination
        try copy.set(try Destination.fromUInt16(self).outmap_unwrapped(), at: [])
        return copy
    }
    
}

extension UInt32 : ToOutMapMappable {
    
    public func outMap<Destination>(to destination: Destination) throws -> Destination where Destination : OutMap {
        var copy = destination
        try copy.set(try Destination.fromUInt32(self).outmap_unwrapped(), at: [])
        return copy
    }
    
}

extension UInt64 : ToOutMapMappable {
    
    public func outMap<Destination>(to destination: Destination) throws -> Destination where Destination : OutMap {
        var copy = destination
        try copy.set(try Destination.fromUInt64(self).outmap_unwrapped(), at: [])
        return copy
    }
    
}
