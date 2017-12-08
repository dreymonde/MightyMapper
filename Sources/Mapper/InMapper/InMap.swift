
/// Data type from which strongly-typed instances can be mapped.
public protocol InMap {

    
    /// Returns instance of the same type for given index path.
    ///
    /// - parameter indexPath: path to desired value.
    ///
    /// - returns: `Self` instance if available; `nil` otherwise.
    func get(at index: MappingIndex) -> Self?
    
    
    /// Returns instance of the same type for given index path.
    ///
    /// - parameter indexPath: path to desired value.
    ///
    /// - returns: `Self` instance if available; `nil` otherwise.
    func get(at indexPath: MappingIndexPath) -> Self?

    
    /// The representation of `self` as an array of `Self`; `nil` if `self` is not an array.
    func asArray() -> [Self]?
    
    /// Returns representation of `self` as desired `T`, if possible.
    func get<T>() -> T?
    
    /// Returns representation of `self` as `Int`, if possible.
    var int: Int? { get }
    
    /// Returns representation of `self` as `Double`, if possible.
    var double: Double? { get }
    
    /// Returns representation of `self` as `Bool`, if possible.
    var bool: Bool? { get }
    
    /// Returns representation of `self` as `String`, if possible.
    var string: String? { get }
    
    // MARK: - Optional
    
    var float: Float? { get }
    var int8: Int8? { get }
    var int16: Int16? { get }
    var int32: Int32? { get }
    var int64: Int64? { get }
    var uint: UInt? { get }
    var uint8: UInt8? { get }
    var uint16: UInt16? { get }
    var uint32: UInt32? { get }
    var uint64: UInt64? { get }

}

extension InMap {

    /// Returns instance of the same type for given index path.
    ///
    /// - parameter indexPath: path to desired value.
    ///
    /// - returns: `Self` instance if available; `nil` otherwise.
    public func get(at indexPath: MappingIndexPath) -> Self? {
        var result = self
        for index in indexPath {
            if let deeped = result.get(at: index) {
                result = deeped
            } else {
                return nil
            }
        }
        return result
    }
    
    public var float: Float? { return double.map(Float.init) }
    public var int8: Int8? { return int.map(Int8.init) }
    public var int16: Int16? { return int.map(Int16.init) }
    public var int32: Int32? { return int.map(Int32.init) }
    public var int64: Int64? { return int.map(Int64.init) }
    public var uint: UInt? { return int.map(UInt.init) }
    public var uint8: UInt8? { return int.map(UInt8.init) }
    public var uint16: UInt16? { return int.map(UInt16.init) }
    public var uint32: UInt32? { return int.map(UInt32.init) }
    public var uint64: UInt64? { return int.map(UInt64.init) }

}
