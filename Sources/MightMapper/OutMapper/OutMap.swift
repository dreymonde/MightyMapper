/// Data type to which strongly-typed instances can be mapped.
public protocol OutMap {
        
    /// Blank state of the map.
    static var blank: Self { get }

    /// Sets value to given index path.
    ///
    /// - parameter map:       value to be set.
    /// - parameter indexPath: path to set value to.
    ///
    /// - throws: throw if value cannot be set for some reason.
    mutating func set(_ map: Self?, at index: MappingIndex) throws
    
    /// Sets value to given index path.
    ///
    /// - parameter map:       value to be set.
    /// - parameter indexPath: path to set value to.
    ///
    /// - throws: throw if value cannot be set for some reason.
    mutating func set(_ map: Self?, at indexPath: MappingIndexPath) throws
    
    /// Creates instance from array of instances of the same type.
    ///
    /// - returns: instance of the same type as array element. `nil` if such conversion cannot be done.
    static func fromArray(_ array: [Self]) -> Self?
    
    /// Creates instance from any given type.
    ///
    /// - parameter value: input value.
    ///
    /// - returns: instance from the given value. `nil` if conversion cannot be done.
    static func from<T>(_ value: T) -> Self?
    
    /// Creates instance of `Self` from `Int`.
    ///
    /// - parameter int: input value.
    ///
    /// - returns: instance from the given `Int`. `nil` if conversion cannot be done.
    static func fromInt(_ int: Int) -> Self?
    
    /// Creates instance of `Self` from `Double`.
    ///
    /// - parameter double: input value.
    ///
    /// - returns: instance from the given `Double`. `nil` if conversion cannot be done.
    static func fromDouble(_ double: Double) -> Self?
    
    /// Creates instance of `Self` from `Bool`.
    ///
    /// - parameter bool: input value.
    ///
    /// - returns: instance from the given `Bool`. `nil` if conversion cannot be done.
    static func fromBool(_ bool: Bool) -> Self?
    
    /// Creates instance of `Self` from `String`.
    ///
    /// - parameter string: input value.
    ///
    /// - returns: instance from the given `String`. `nil` if conversion cannot be done.
    static func fromString(_ string: String) -> Self?
    
    // MARK: - Optional
    
    static func fromFloat(_ float: Float) -> Self?
    static func fromInt8(_ int8: Int8) -> Self?
    static func fromInt16(_ int16: Int16) -> Self?
    static func fromInt32(_ int32: Int32) -> Self?
    static func fromInt64(_ int64: Int64) -> Self?
    static func fromUInt(_ uint: UInt) -> Self?
    static func fromUInt8(_ uint8: UInt8) -> Self?
    static func fromUInt16(_ uint16: UInt16) -> Self?
    static func fromUInt32(_ uint32: UInt32) -> Self?
    static func fromUInt64(_ uint64: UInt64) -> Self?

}

public enum OutMapError : Error {
    case deepSetIsNotImplementedYet
    case tryingToSetNilAtTheTopLevel
}

extension OutMap {
    mutating public func set(_ map: Self?, at indexPath: MappingIndexPath) throws {
        let count = indexPath.count
        switch count {
        case 0:
            self = map ?? .blank
        case 1:
            try set(map, at: indexPath[0])
        default:
            throw OutMapError.deepSetIsNotImplementedYet
        }
    }
    
    public static func fromFloat(_ float: Float) -> Self? {
        return fromDouble(Double(float))
    }
    public static func fromInt8(_ int8: Int8) -> Self? {
        return fromInt(Int(int8))
    }
    public static func fromInt16(_ int16: Int16) -> Self? {
        return fromInt(Int(int16))
    }
    public static func fromInt32(_ int32: Int32) -> Self? {
        return fromInt(Int(int32))
    }
    public static func fromInt64(_ int64: Int64) -> Self? {
        return fromInt(Int(int64))
    }
    public static func fromUInt(_ uint: UInt) -> Self? {
        return fromInt(Int(uint))
    }
    public static func fromUInt8(_ uint8: UInt8) -> Self? {
        return fromInt(Int(uint8))
    }
    public static func fromUInt16(_ uint16: UInt16) -> Self? {
        return fromInt(Int(uint16))
    }
    public static func fromUInt32(_ uint32: UInt32) -> Self? {
        return fromInt(Int(uint32))
    }
    public static func fromUInt64(_ uint64: UInt64) -> Self? {
        return fromInt(Int(uint64))
    }
    
}
