
public struct MappingIndex : RawRepresentable {
    
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
}

public typealias MappingIndexPath = [MappingIndex]

extension RawRepresentable where RawValue == String {
    
    internal var index: MappingIndex {
        return MappingIndex(rawValue: self.rawValue)
    }
    
}

public protocol MapperKey {
    
    var index: MappingIndex { get }
    
}

extension String : MapperKey {
    
    public var index: MappingIndex {
        return MappingIndex(rawValue: self)
    }
    
}

extension MapperKey where Self : RawRepresentable, Self.RawValue == String {
    
    public var index: MappingIndex {
        return MappingIndex(rawValue: self.rawValue)
    }
    
}

//extension MappingIndex : ExpressibleByStringLiteral {
//    public typealias StringLiteralType = String
//    public typealias UnicodeScalarLiteralType = String
//    public typealias ExtendedGraphemeClusterLiteralType = String
//    public init(stringLiteral value: StringLiteralType) {
//        self.init(rawValue: value)
//    }
//    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
//        self
//    }
//    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
//        self = .key(value)
//    }
//}
//
//extension IndexPathElement where Self : RawRepresentable, Self.RawValue : IndexPathElement {
//    public var indexPathValue: IndexPathValue {
//        return rawValue.indexPathValue
//    }
//}
//
public enum NoKeys : MapperKey {
    public var index: MappingIndex {
        return MappingIndex(rawValue: "")
    }
}


