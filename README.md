# MightyMapper

[![Swift][swift-badge]][swift-url]
[![License][mit-badge]][mit-url]

**MightyMapper** is a tiny yet very powerful library which allows you to create custom strongly-typed instances from *any* kind of structured data (**JSON** and other data interchange formats, for example) with only a single initializer. And vice versa - with only a single method.

**MightyMapper** extensively uses power of Swift generics and protocols, dramatically reducing the boilerplate you have to write. With **MightyMapper**, mapping is a breeze.

The maing advantage of **MightyMapper** is that you don't need to write multiple initializers to support mapping from different formats (if you've done it before - you know what I mean), thus eliminating the boilerplate and leaving only the core logic you need. With **MightyMapper** your code is safe and expressive.

And while reducing boilerplate, **MightyMapper** is also amazingly fast. It doesn't use reflection, and generics allows the compiler to optimize code in the most effective way.

**MightyMapper** itself is just a core mapping logic without any implementations. To actually use **MightyMapper**, you also have to import one of Mapper-conforming libraries. You can find a current list of them [here](#mapper-compatible-libraries). If you want to support **MightyMapper** for your data types, checkout [Adopting Mapper](#adopting-mapper) short guide.

**MightyMapper** is deeply inspired by Lyft's [Mapper](https://github.com/lyft/mapper). You can learn more about the concept behind their idea in [this talk](https://realm.io/news/slug-keith-smiley-embrace-immutability/).

## Showcase

```swift
struct City : InMappable, OutMappable {
    
    let name: String
    let population: Int
    
    enum MappingKeys : String, Key {
        case name, population
    }
    
    init<Source>(mapper: InMapper<Source, MappingKeys>) throws {
        self.name = try mapper.map(from: .name)
        self.population = try mapper.map(from: .population)
    }
    
    func outMap<Destination>(mapper: inout OutMapper<Destination, MappingKeys>) throws {
        try mapper.map(self.name, to: .name)
        try mapper.map(self.population, to: .population)
    }
    
}

enum Gender : String {
    case male
    case female
}

// Mappable = InMappable & OutMappable
struct Person : Mappable {
    
    let name: String
    let gender: Gender
    let city: City
    let identifier: Int
    let isRegistered: Bool
    let biographyPoints: [String]
    
    enum MappingKeys : String, Key {
        case name, gender, city, identifier, registered, biographyPoints
    }
    
    init<Source>(mapper: InMapper<Source, MappingKeys>) throws {
        self.name = try mapper.map(from: .name)
        self.gender = try mapper.map(from: .gender)
        self.city = try mapper.map(from: .city)
        self.identifier = try mapper.map(from: .identifier)
        self.isRegistered = try mapper.map(from: .registered)
        self.biographyPoints = try mapper.map(from: .biographyPoints)
    }
    
    func outMap<Destination>(mapper: inout OutMapper<Destination, Person.MappingKeys>) throws {
        try mapper.map(self.name, to: .name)
        try mapper.map(self.gender, to: .gender)
        try mapper.map(self.city, to: .city)
        try mapper.map(self.identifier, to: .identifier)
        try mapper.map(self.isRegistered, to: .registered)
        try mapper.map(self.biographyPoints, to: .biographyPoints)
    }
    
}

// in-mapping
let jessy = Person(from: json)
let messi = Person(from: messagePack)
let michael = Person(from: mongoBSON)

// out-mapping
let json: JSON = try jessy.outMap()
let messi: MessagePack = try messi.outMap()

// and so on...
```

## Installation

- Add `Mapper` to your `Package.swift`

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/Zewo/Mapper.git", majorVersion: 0, minor: 14),
    ]
)
```

## Usage

#### Basics

**MightyMapper** allows you to map data in both ways, and so it has two major parts: **in** mapping (for example, *JSON -> your model*) and **out** mapping (*your model -> JSON*). So the two main protocols of **MightyMapper** is `InMappable` and `OutMappable`.

To use **MightyMapper** in it's full glory, first you need to define nested `MappingKeys` enum. `MappingKeys` are needed to represent keys from/to which your properties will be mapped. Using nested `MappingKeys` is a win for type-safety and can save you from some painful typos:

```swift
struct City {
    
    let name: String
    let population: Int
    
    enum MappingKeys : String, Key {
        case name, population
    }
    
}
```

Make sure to declare `MappingKeys` as `Key`!

Now we're going to write mapping code. Let's start with *in mapping*:

```swift
extension City : InMappable {
    init<Source>(mapper: InMapper<Source, MappingKeys>) throws {
        self.name = try mapper.map(from: .name)
        self.population = try mapper.map(from: .population)
    }
}

let city = try City(from: json)
```

Actually, that's it! Now your `City` can be created from JSON, BSON, MessagePack and a whole range of other data formats. And that's all thanks to the amazing power of generics. As you see, that's why your initializer is generic. And `from: .name` is actually where your `MappingKeys` are used.

Each call to `mapper` is marked with `try` because, obviously, it can fail. In this case initializer will throw with `InMapperError`. If one of your properties is optional, you can just write `try?`.

Let's continue with *out mapping*:

```swift
extension City : OutMappable {
    func outMap<Destination>(mapper: inout OutMapper<Destination, MappingKeys>) throws {
        try mapper.map(self.name, to: .name)
        try mapper.map(self.population, to: .population)
    }
}

let json: JSON = city.outMap()
```

As you see, the code is pretty similar, easy to reason about, and very expressive.

As you see, both mappers have two generic arguments: `Source`/`Destination`, which is the structured data format, and `MappingKeys`, which is specific `MappingKeys` defined for your model. 

Actually, if you don't want to write that `MappingKeys`, we made `BasicInMappable`/`BasicOutMappable` just for you.

```swift
struct Planet : BasicInMappable, BasicOutMappable {
    
    let radius: Int
    
    init<Source>(mapper: BasicInMapper<Source>) throws {
        self.radius = try mapper.map(from: "radius")
    }
    
    func outMap<Destination>(mapper: inout BasicOutMapper<Destination>) throws {
        try mapper.map(radius, to: "radius")
    }
    
}
```

#### Mapping arrays

You can map array just like anything else -- simply by using `.map`.

```swift
struct Album : Mappable {
    
    let songs: [String]
    
    enum MappingKeys : String, Key {
        case songs
    }
    
    init<Source>(mapper: InMapper<Source, MappingKeys>) throws {
        self.songs = try mapper.map(from: .songs)
    }
    
    func outMap<Destination>(mapper: inout OutMapper<Destination, Album.MappingKeys>) throws {
        try mapper.map(self.songs, to: .songs)
    }
    
}
```

#### Mapping enums
**MightyMapper** can also automatically map enums with raw values, which is neat.

```swift
enum Wood : String {
    case mahogany
    case koa
    case cedar
    case spruce
}

enum Strings : Int {
    case four = 4
    case six = 6
    case seven = 7
}

struct Guitar : Mappable {
    
    let wood: Wood
    let strings: Strings
    
    enum MappingKeys : String, Key {
        case wood, strings
    }
    
    init<Source>(mapper: InMapper<Source, MappingKeys>) throws {
        self.wood = try mapper.map(from: .wood)
        self.strings = try mapper.map(from: .strings)
    }
    
    func outMap<Destination>(mapper: inout OutMapper<Destination, Guitar.MappingKeys>) throws {
        try mapper.map(self.wood, to: .wood)
        try mapper.map(self.strings, to: .strings)
    }
    
}
```

#### Nesting `Mappable`s

Cool thing about **MightyMapper** is that you can easily map instances which are itself `Mappable`:

```swift
struct Sport : Mappable {
    
    let name: String
    
    enum MappingKeys : String, Key {
        case name
    }
    
    init<Source>(mapper: InMapper<Source, MappingKeys>) throws {
        self.name = try mapper.map(from: .name)
    }
    
    func outMap<Destination>(mapper: inout OutMapper<Destination, Sport.MappingKeys>) throws {
        try mapper.map(self.name, to: .name)
    }
    
}

struct Team : Mappable {
    
    let sport: Sport
    let name: String
    let foundationYear: Int
    
    enum MappingKeys : String, Key {
        case sport
        case name
        case foundationYear = "foundation-year"
    }
    
    init<Source>(mapper: InMapper<Source, MappingKeys>) throws {
        self.sport = try mapper.map(from: .sport)
        self.name = try mapper.map(from: .name)
        self.foundationYear = try mapper.map(from: .foundationYear)
    }
    
    func outMap<Destination>(mapper: inout OutMapper<Destination, Team.MappingKeys>) throws {
        try mapper.map(self.sport, to: .sport)
        try mapper.map(self.name, to: .name)
        try mapper.map(self.foundationYear, to: .foundationYear)
    }
    
}
```

#### Mapping with context
*(Advanced topic)*

There are some situations when you need to describe more than one way of mappings. It can be for several reasons - different sources/destinations of data, architectural restrictions and so on. For this situation we have "contextual mapping".

Let's start with something called `InMappableWithContext`:

```swift
enum SuperContext {
    case json
    case mongo
    case gordon
}

struct SuperheroHelper {
    
    let name: String
    let id: Int
    
    enum MappingKeys : String, Key {
        case name
        case id, identifier, g_id
    }
    
    typealias MappingContext = SuperContext
    
}

extension SuperheroHelper : InMappableWithContext {
    init<Source>(mapper: ContextualInMapper<Source, MappingKeys, MappingContext>) throws {
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
    func outMap<Destination>(mapper: inout ContextualOutMapper<Destination, SuperheroHelper.MappingKeys, MappingContext>) throws {
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

// now we can do
let robin = try BatmanHelper(from: robinJSON, withContext: .json)
// or
let robin = try BatmanHelper(from: robinMongo, withContext: .mongo)
// or whatever that is
let robin = try BatmanHelper(from: robinGordon, withContext: .gordon)

// And also
let robinJSON: JSON = try robin.outMap(withContext: .json)
```

Now let's get to something even more cool:

```swift
struct Superhero {
    
    let name: String
    let helper: SuperheroHelper
    
    enum MappingKeys : String, Key {
        case name, helper
    }
    
    typealias MappingContext = SuperContext
    
}

extension Superhero : InMappableWithContext {
    init<Source>(mapper: ContextualInMapper<Source, MappingKeys, MappingContext>) throws {
        self.name = try mapper.map(from: .name)
        self.helper = try mapper.map(from: .helper)
    }
}

extension Superhero : OutMappableWithContext {
    func outMap<Destination>(mapper: inout ContextualOutMapper<Destination, MappingKeys, MappingContext>) throws {
        try mapper.map(self.name, to: .name)
        try mapper.map(self.helper, to: .helper)
    }
}

let batman = try Superhero(from: batJSON, withContext: .json)
```

Noticed something strange? Yes, `self.helper` is mapped even though we didn't specify the context! That's because `Superhero` has, actually, the same context as `SuperheroHelper`, and is also `InMappableWithContext`/`OutMappableWithContext`, and so the right context is passed to `SuperheroHelper` *automatically*. This is *context infering*.

If you don't want that, you can specify the context manually:

```swift
// in
self.helper = try mapper.map(from: .helper, withContext: .json)
// out
try mapper.map(self.helper, to: .helper, withContext: .json)
```

#### Plain mapping

Tutorial by example: making **Foundation**'s `Date` conform to `Mappable`.

```swift
extension Date : Mappable {
    
    public init<Source>(mapper: PlainInMapper<Source>) throws {
        let interval: TimeInterval = try mapper.map()
        self.init(timeIntervalSince1970: interval)
    }
    
    public func outMap<Destination>(mapper: inout PlainOutMapper<Destination>) throws {
        try mapper.map(self.timeIntervalSince1970)
    }
    
}
```

Mappers take variadic parameter as index path, so it's possible to pass no index path at all. We call it "plain mapping".

And using `MappableWithContext`, we can even do something like that:

```swift
public enum DateMappingContext {
    case timeIntervalSince1970
    case timeIntervalSinceReferenceDate
}

extension Date : InMappableWithContext {
    public init<Source>(mapper: PlainContextualInMapper<Source, DateMappingContext>) throws {
        let interval: TimeInterval = try mapper.map()
        switch mapper.context {
        case .timeIntervalSince1970:
            self.init(timeIntervalSince1970: interval)
        case .timeIntervalSinceReferenceDate:
            self.init(timeIntervalSinceReferenceDate: interval)
        }
    }
}

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
```

#### "Unguaranteed" mapping

**MightyMapper** can work only with four basic "primitive" types: `Int`, `Double`, `Bool`, `String` (these four are expected to work with any **MightyMapper**-conforming type). But, of course, you can map other, more specific primitive types that your format supports. In order to do that, you should use `.unguaranteedMap` and `.unguaranteedMapArray` methods:

```swift
struct TeamStat : Mappable {

    let rate: Int32
    let goals: [Int32]
    
    enum MappingKeys : String, Key {
        case rate, goals
    }
    
    init<Source>(mapper: InMapper<Source, MappingKeys>) throws {
        self.rate = try mapper.unguaranteedMap(from: .rate)
        self.goals = try mapper.unguaranteedMapArray(from: .goals)
    }
    
    func outMap<Destination>(mapper: inout OutMapper<Destination, TeamStat.MappingKeys>) throws {
        try mapper.unguaranteedMap(self.rate, to: .rate)
        try mapper.unguaranteedMapArray(self.goals, to: .goals)
    }

}

// `BSON` supports `Int32` directly, so
let stat = try TeamStat(from: mongoDocument)
```

#### Mapping of external classes

If you have some classes that you don't have direct access to (for example, **Cocoa** classes), and you want to make them `Mappable` for some reason, you should use `BasicInMappable `/`BasicOutMappable ` with this approach:

```swift
extension BasicInMappable where Self : NSDate {
    public init<Source>(mapper: BasicInMapper<Source>) throws {
        let interval: TimeInterval = try mapper.map()
        self.init(timeIntervalSince1970: interval)
    }
}

extension NSDate : BasicInMappable { }

extension BasicOutMappable where Self : NSDate {
    public func outMap<Destination>(mapper: inout BasicOutMapper<Destination>) throws {
        try mapper.map(self.timeIntervalSince1970)
    }
}

extension NSDate : BasicOutMappable { }
```

Now `NSDate` can be mapped as usual.

## Mapper-compatible libraries

*Soon*

## License

This project is released under the MIT license. See [LICENSE](LICENSE) for details.

[swift-badge]: https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat
[swift-url]: https://swift.org
[zewo-badge]: https://img.shields.io/badge/Zewo-0.14-FF7565.svg?style=flat
[zewo-url]: http://zewo.io
[platform-badge]: https://img.shields.io/badge/Platforms-OS%20X%20--%20Linux-lightgray.svg?style=flat
[platform-url]: https://swift.org
[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[mit-url]: https://tldrlegal.com/license/mit-license
[slack-image]: http://s13.postimg.org/ybwy92ktf/Slack.png
[slack-badge]: https://zewo-slackin.herokuapp.com/badge.svg
[slack-url]: http://slack.zewo.io
[travis-badge]: https://travis-ci.org/Zewo/Mapper.svg?branch=master
[travis-url]: https://travis-ci.org/Zewo/Mapper
[codebeat-badge]: https://codebeat.co/badges/d08bad48-c72e-49e3-a184-68a23063d461
[codebeat-url]: https://codebeat.co/projects/github-com-zewo-mapper
