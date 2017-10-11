import XCTest
import Foundation
@testable import MightyMapper

extension Test1: OutMappable {
    func outMap<Map>(mapper: inout OutMapper<Map, MappingKeys>) throws {
        try mapper.map(self.int, to: .int)
        try mapper.map(self.double, to: .double)
        try mapper.map(self.string, to: .string)
        try mapper.map(self.bool, to: .bool)
    }
}

extension Nest2: OutMappable {
    func outMap<Map>(mapper: inout OutMapper<Map, MappingKeys>) throws {
        try mapper.map(self.int, to: .int)
    }
}

extension Test2: OutMappable {
    func outMap<Map>(mapper: inout OutMapper<Map, MappingKeys>) throws {
        try mapper.map(self.string, to: .string)
        try mapper.map(self.ints, to: .ints)
        try mapper.map(self.nest, to: .nest)
    }
}

struct Test14: BasicOutMappable {
    let array: [Int]
    func outMap<Map>(mapper: inout BasicOutMapper<Map>) throws {
        try mapper.map(self.array, to: "array")
    }
}

extension Test5: OutMappable {
    func outMap<Map>(mapper: inout OutMapper<Map, MappingKeys>) throws {
        try mapper.map(self.nests, to: .nests)
    }
}

extension Test6: OutMappable {
    func outMap<Map>(mapper: inout OutMapper<Map, MappingKeys>) throws {
        try mapper.map(self.string, to: .string)
        try mapper.map(self.int, to: .int)
    }
}

extension Test7: OutMappable {
    func outMap<Map>(mapper: inout OutMapper<Map, MappingKeys>) throws {
        try mapper.map(self.strings, to: .strings)
        try mapper.map(self.ints, to: .ints)
    }
}

extension Nest3: OutMappableWithContext {
    func outMap<Map>(mapper: inout ContextualOutMapper<Map, String, TestContext>) throws {
        switch mapper.context {
        case .apple:
            try mapper.map(self.int, to: "apple-int")
        case .peach:
            try mapper.map(self.int, to: "peach-int")
        case .orange:
            try mapper.map(self.int, to: "orange-int")
        }
    }
}

extension Test9: OutMappableWithContext {
    func outMap<Map>(mapper: inout ContextualOutMapper<Map, String, TestContext>) throws {
        try mapper.map(self.nest, to: "nest")
    }
}

extension Test10: OutMappableWithContext {
    func outMap<Map>(mapper: inout ContextualOutMapper<Map, String, TestContext>) throws {
        try mapper.map(self.nests, to: "nests")
    }
}

extension Test11: BasicOutMappable {
    func outMap<Map>(mapper: inout BasicOutMapper<Map>) throws {
        try mapper.map(self.nest, to: "nest", withContext: .peach)
        try mapper.map(self.nests, to: "nests", withContext: .orange)
    }
}

struct NilTest1: BasicOutMappable {
    
    let int: Int?
    let string: String?
    
    func outMap<Destination>(mapper: inout BasicOutMapper<Destination>) throws {
        try mapper.map(self.int, to: "int")
        try mapper.map(self.string, to: "string")
    }
    
}

struct NilTest2: BasicOutMappable {
    
    let int: Int?
    let nest: NilTest1?
    
    func outMap<Destination>(mapper: inout BasicOutMapper<Destination>) throws {
        try mapper.map(self.int, to: "int")
        try mapper.map(self.nest, to: "nest")
    }
    
}

struct OutDictNest: BasicOutMappable {
    let int: Int
    func outMap<Map>(mapper: inout BasicOutMapper<Map>) throws {
        try mapper.map(self.int, to: "int")
    }
}

struct OutDictTest: BasicOutMappable {
    let int: Int
    let string: String
    let nest: OutDictNest
    let strings: [String]
    let nests: [OutDictNest]
    func outMap<Map>(mapper: inout BasicOutMapper<Map>) throws {
        try mapper.map(int, to: "int")
        try mapper.map(string, to: "string")
        try mapper.map(nest, to: "nest")
        try mapper.map(strings, to: "strings")
        try mapper.map(nests, to: "nests")
    }
}

#if os(macOS)
    extension BasicOutMappable where Self : NSDate {
        public func outMap<Destination>(mapper: inout BasicOutMapper<Destination>) throws {
            try mapper.map(self.timeIntervalSince1970)
        }
    }
    
    extension NSDate : BasicOutMappable { }
    
    extension Test15 : OutMappable {
        func outMap<Destination>(mapper: inout OutMapper<Destination, Test15.MappingKeys>) throws {
            try mapper.map(self.date, to: .date)
        }
    }
#endif

extension Date : OutMappableWithContext {
    public func outMap<Destination>(mapper: inout PlainContextualOutMapper<Destination, DateMappingContext>) throws {
        switch mapper.context {
        case .timeIntervalSince1970:
            try mapper.map(self.timeIntervalSince1970)
        case .timeIntervalSinceReferenceDate:
            try mapper.map(self.timeIntervalSinceReferenceDate)
        }
    }
}

class OutMapperTests: XCTestCase {
    
    func testPrimitiveTypesMapping() throws {
        let map: [String : Any] = ["int": 15, "double": 32.0, "string": "Hello", "bool": true]
        let test = try Test1(from: map)
        let unmap = try test.map() as [String : Any] as NSDictionary
        XCTAssertEqual(map as NSDictionary, unmap)
    }
    
    func testBasicNesting() throws {
        let dict: [String : Any] = ["string": "Rio-2016", "ints": [2, 5, 4], "nest": ["int": 11]]
        let test = try Test2(from: dict)
        let back = try test.map() as [String : Any] as NSDictionary
        XCTAssertEqual(dict as NSDictionary, back)
    }
    
//    func testFailWrongType() {
//        let test = Test14(array: [1, 2, 3, 4, 5])
//        XCTAssertThrowsError(try test.map() as Map) { error in
//            guard let error = error as? OutMapperError, case .wrongType = error else {
//                XCTFail("Wrong error thrown; must be .wrongType")
//                return
//            }
//        }
//    }
    
    func testArrayOfMappables() throws {
        let nests: [[String : Any]] = [3, 1, 4, 6, 19].map({ ["int": $0] })
        let dict: [String : Any] = ["nests": nests]
        let test = try Test5(from: dict)
        let back = try test.map() as [String : Any] as NSDictionary
        XCTAssertEqual(dict as NSDictionary, back)
    }
    
    func testEnumMappng() throws {
        let dict: [String : Any] = ["next-big-thing": "quark", "city": 1]
        let test = try Test6(from: dict)
        let back = try test.map() as [String : Any] as NSDictionary
        XCTAssertEqual(dict as NSDictionary, back)
    }
    
    func testEnumArrayMapping() throws {
        let dict: [String : Any] = ["zewo-projects": ["venice", "annecy", "quark"], "ukraine-capitals": [1, 2]]
        let test = try Test7(from: dict)
        let back = try test.map() as [String : Any] as NSDictionary
        XCTAssertEqual(dict as NSDictionary, back)
    }
    
    func testBasicMappingWithContext() throws {
        let appleDict: [String : Any] = ["apple-int": 1]
        let apple = try Nest3(from: appleDict, withContext: .apple)
        XCTAssertEqual(appleDict as NSDictionary, try apple.outMap(withContext: .apple) as [String : Any] as NSDictionary)
        let peachDict: [String : Any] = ["peach-int": 2]
        let peach = try Nest3(from: peachDict, withContext: .peach)
        XCTAssertEqual(peachDict as NSDictionary, try peach.outMap(withContext: .peach) as [String : Any] as NSDictionary)
        let orangeDict: [String : Any] = ["orange-int": 3]
        let orange = try Nest3(from: orangeDict, withContext: .orange)
        XCTAssertEqual(orangeDict as NSDictionary, try orange.outMap(withContext: .orange) as [String : Any] as NSDictionary)
    }
    
    func testContextInference() throws {
        let peachDict: [String : Any] = ["nest": ["peach-int": 207]]
        let peach = try Test9(from: peachDict, withContext: .peach)
        XCTAssertEqual(peachDict as NSDictionary, try peach.outMap(withContext: .peach) as [String : Any] as NSDictionary)
    }
    
    func testArrayMappingWithContext() throws {
        let orangesDict: [[String : Any]] = [2, 0, 1, 6].map({ ["orange-int": $0] })
        let dict: [String : Any] = ["nests": orangesDict]
        let oranges = try Test10(from: dict, withContext: .orange)
        let back = try oranges.outMap(withContext: .orange) as [String : Any] as NSDictionary
        XCTAssertEqual(dict as NSDictionary, back)
    }
    
    func testUsingContext() throws {
        let dict: [String : Any] = ["nest": ["peach-int": 10], "nests": [["orange-int": 15]]]
        let test = try Test11(from: dict)
        XCTAssertEqual(dict as NSDictionary, try test.map() as [String : Any] as NSDictionary)
    }
    
    func testExternalMappable() throws {
        #if os(macOS)
            let date = NSDate()
            let dict: [String : Any] = [
                "date": date.timeIntervalSince1970
            ]
            let test = try Test15(from: dict)
            let back = try test.map() as [String : Any]
            let backDate: TimeInterval = back["date"] as! Double
            XCTAssertEqual(date.timeIntervalSince1970, backDate)
        #endif
    }
    
//    func testDateMapping() throws {
//        let date1970 = Date.init(timeIntervalSince1970: 5.0)
//        let date1970Map: [String : Any] = try date1970.map(withContext: .timeIntervalSince1970)
//        XCTAssertEqual(date1970Map as! Double, 5.0)
//
//        let date2001 = Date.init(timeIntervalSinceReferenceDate: 5.0)
//        let date2001Map: [String : Any] = try date2001.map(withContext: .timeIntervalSinceReferenceDate)
//        XCTAssertEqual(date2001Map.double!, 5.0)
//    }
    
//    func testStringAnyExhaustive() throws {
//        // expected
//        let nestDict: [String: Any] = ["int": 3]
//        let nestsDictArray: [[String: Any]] = sequence(first: 1, next: { if $0 < 6 { return $0 + 1 } else { return nil } }).map({ ["int": $0] })
//        let stringsArray: [Any] = ["rope", "summit"]
//        let hugeDict: [String: Any] = [
//            "int": Int(5),
//            "string": "Quark",
//            "nest": nestDict,
//            "strings": stringsArray,
//            "nests": nestsDictArray,
//            ]
//        //
//        let nest = OutDictNest(int: 3)
//        let nests = sequence(first: 1, next: { if $0 < 6 { return $0 + 1 } else { return nil } }).map({ OutDictNest(int: $0) })
//        let test = OutDictTest(int: 5, string: "Quark", nest: nest, strings: ["rope", "summit"], nests: nests)
//        let back = try test.map() as [String: Any]
//        XCTAssertEqual(back as NSDictionary, hugeDict as NSDictionary)
//    }
    
}
