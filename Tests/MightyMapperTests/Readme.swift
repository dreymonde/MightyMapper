import MightyMapper

// MARK: - Context

enum SuperContext {
    case json
    case mongo
    case gordon
}

struct SuperheroHelper {
    
    let name: String
    let id: Int
    
    enum MappingKeys : String, MappingKey {
        case name
        case id, identifier, g_id
    }
        
}

extension SuperheroHelper : InMappableWithContext {
    init<Source>(mapper: ContextualInMapper<Source, MappingKeys, SuperContext>) throws {
        self.name = try mapper.map(from: .name)
        switch mapper.context {
        case .json:
            self.id = try mapper.map(from: .id)
        case .mongo:
            self.id = try mapper.map(from: .identifier)
        case .gordon:
            self.id = try mapper.map(from: .g_id)
        }
    }
}

extension SuperheroHelper : OutMappableWithContext {
    func outMap<Destination>(mapper: inout ContextualOutMapper<Destination, SuperheroHelper.MappingKeys, SuperContext>) throws {
        try mapper.map(self.name, to: .name)
        switch mapper.context {
        case .json:
            try mapper.map(self.id, to: .id)
        case .mongo:
            try mapper.map(self.id, to: .identifier)
        case .gordon:
            try mapper.map(self.id, to: .g_id)
        }
    }
}

struct Superhero {
    
    let name: String
    let helper: SuperheroHelper
    
    enum MappingKeys : String, MappingKey {
        case name, helper
    }
    
    typealias Context = SuperContext
    
}

extension Superhero : InMappableWithContext {
    init<Source>(mapper: ContextualInMapper<Source, MappingKeys, Context>) throws {
        self.name = try mapper.map(from: .name)
        self.helper = try mapper.map(from: .helper)
    }
}

extension Superhero : OutMappableWithContext {
    func outMap<Destination>(mapper: inout ContextualOutMapper<Destination, Superhero.MappingKeys, SuperContext>) throws {
        try mapper.map(self.name, to: .name)
        try mapper.map(self.helper, to: .helper)
    }
}

// MARK: - Adoption

public enum MapperMap {
    case int(Int)
    case double(Double)
    case string(String)
    case bool(Bool)
    case array([MapperMap])
    case dictionary([String: MapperMap])
}

extension MapperMap : InMap {
    
    public func get(at index: MappingIndex) -> MapperMap? {
        let key = index.rawValue
        switch self {
        case .dictionary(let dict):
            return dict[key]
        default:
            return nil
        }
    }
    
    public func get<T>() -> T? {
        switch self {
        case .int(let int as T):
            return int
        case .double(let double as T):
            return double
        case .string(let string as T):
            return string
        case .bool(let bool as T):
            return bool
        case .array(let array as T):
            return array
        case .dictionary(let dict as T):
            return dict
        default:
            return nil
        }
    }
    
    public var int: Int? {
        if case .int(let value) = self {
            return value
        }
        return nil
    }
    
    public var double: Double? {
        if case .double(let value) = self {
            return value
        }
        return nil
    }
    
    public var bool: Bool? {
        if case .bool(let value) = self {
            return value
        }
        return nil
    }
    
    public var string: String? {
        if case .string(let value) = self {
            return value
        }
        return nil
    }
    
    public func asArray() -> [MapperMap]? {
        if case .array(let array) = self {
            return array
        }
        return nil
    }
    
}

public enum MapperNeomap {
    case bool(Bool)
    case int32(Int32)
    case uint(UInt)
    case uint8(UInt8)
    case string(String)
    case float(Float)
    case array([MapperNeomap])
    case dictionary([String: MapperNeomap])
}

extension MapperNeomap : InMap {
    
    public func get(at index: MappingIndex) -> MapperNeomap? {
        let key = index.rawValue
        switch self {
        case .dictionary(let dict):
            return dict[key]
        default:
            return nil
        }
    }
    
    public func get<T>() -> T? {
        switch self {
        case .bool(let value as T):         return value
        case .int32(let value as T):        return value
        case .uint(let value as T):         return value
        case .uint8(let value as T):        return value
        case .string(let value as T):       return value
        case .float(let value as T):        return value
        case .array(let value as T):        return value
        case .dictionary(let value as T):   return value
        default:
            return nil
        }
    }
    
    public var int: Int? {
        switch self {
        case .int32(let value):     return Int(value)
        case .uint(let value):      return Int(value)
        case .uint8(let value):     return Int(value)
        default:
            return nil
        }
    }
    
    public var double: Double? {
        if case .float(let value) = self {
            return Double(value)
        }
        return nil
    }
    
    public var int32: Int32? {
        if case .int32(let value) = self {
            return value
        }
        return nil
    }
    
    public var uint: UInt? {
        if case .uint(let value) = self {
            return value
        }
        return nil
    }
    
    public var uint8: UInt8? {
        if case .uint8(let value) = self {
            return value
        }
        return nil
    }
    
    public var float: Float? {
        if case .float(let value) = self {
            return value
        }
        return nil
    }
    
    public var bool: Bool? {
        if case .bool(let value) = self {
            return value
        }
        return nil
    }
    
    public var string: String? {
        if case .string(let value) = self {
            return value
        }
        return nil
    }
    
    public func asArray() -> [MapperNeomap]? {
        if case .array(let array) = self {
            return array
        }
        return nil
    }
    
}

enum MapperMapOutMapError : Error {
    case incompatibleType
}

extension MapperMap : OutMap {
    
    public static var blank: MapperMap {
        return .dictionary([:])
    }
    
    public enum OutMappingError : Error {
        case incompatibleType
    }
    
    public mutating func set(_ map: MapperMap?, at index: MappingIndex) throws {
        guard let map = map else { return }
        let key = index.rawValue
        switch self {
        case .dictionary(var dict):
            dict[key] = map
            self = .dictionary(dict)
        default:
            throw OutMappingError.incompatibleType
        }
    }
    
    public static func fromArray(_ array: [MapperMap]) -> MapperMap? {
        return .array(array)
    }
    
    public static func from<T>(_ value: T) -> MapperMap? {
        if let int = value as? Int {
            return .int(int)
        }
        if let double = value as? Double {
            return .double(double)
        }
        if let string = value as? String {
            return .string(string)
        }
        if let bool = value as? Bool {
            return .bool(bool)
        }
        if let array = value as? [MapperMap] {
            return .array(array)
        }
        if let dict = value as? [String: MapperMap] {
            return .dictionary(dict)
        }
        return nil
    }
    
    public static func fromInt(_ int: Int) -> MapperMap? {
        return MapperMap.int(int)
    }
    
    public static func fromDouble(_ double: Double) -> MapperMap? {
        return MapperMap.double(double)
    }
    
    public static func fromBool(_ bool: Bool) -> MapperMap? {
        return MapperMap.bool(bool)
    }
    
    public static func fromString(_ string: String) -> MapperMap? {
        return MapperMap.string(string)
    }
    
}

extension MapperNeomap : OutMap {
    
    public static var blank: MapperNeomap {
        return .dictionary([:])
    }
    
    public enum OutMappingError : Error {
        case incompatibleType
    }
    
    public mutating func set(_ map: MapperNeomap?, at index: MappingIndex) throws {
        guard let map = map else { return }
        let key = index.rawValue
        switch self {
        case .dictionary(var dict):
            dict[key] = map
            self = .dictionary(dict)
        default:
            throw OutMappingError.incompatibleType
        }
    }
    
    public static func from<T>(_ value: T) -> MapperNeomap? {
        if let string = value as? String {
            return .string(string)
        }
        if let bool = value as? Bool {
            return .bool(bool)
        }
        if let i32 = value as? Int32 {
            return .int32(i32)
        }
        if let uint = value as? UInt {
            return .uint(uint)
        }
        if let uint8 = value as? UInt8 {
            return .uint8(uint8)
        }
        if let float = value as? Float {
            return .float(float)
        }
        if let array = value as? [MapperNeomap] {
            return .array(array)
        }
        if let dict = value as? [String: MapperNeomap] {
            return .dictionary(dict)
        }
        return nil
    }
    
    public static func fromInt(_ int: Int) -> MapperNeomap? {
        return .int32(Int32(int))
    }
    
    public static func fromDouble(_ double: Double) -> MapperNeomap? {
        return .float(Float(double))
    }
    
    public static func fromBool(_ bool: Bool) -> MapperNeomap? {
        return .bool(bool)
    }
    
    public static func fromString(_ string: String) -> MapperNeomap? {
        return .string(string)
    }
    
    public static func fromArray(_ array: [MapperNeomap]) -> MapperNeomap? {
        return .array(array)
    }
    
    public static func fromFloat(_ float: Float) -> MapperNeomap? {
        return .float(float)
    }
    
    public static func fromUInt(_ uint: UInt) -> MapperNeomap? {
        return .uint(uint)
    }
    
    public static func fromUInt8(_ uint8: UInt8) -> MapperNeomap? {
        return .uint8(uint8)
    }
    
    public static func fromInt32(_ int32: Int32) -> MapperNeomap? {
        return .int32(int32)
    }
    
}
