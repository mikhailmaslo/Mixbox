import XCTest
import MixboxGenerators

final class GeneratorFacadeTests: BaseGeneratorTestCase {
    private let unstubbedInt = 1234567890
    private let unstubbedString = "1234567890"
    
    func test___generate___is_stateless() {
        stubConstants()
        
        var book: Book
            
        book = generator.generate {
            $0.id = 1
            $0.title = "Hamlet"
        }
        
        XCTAssertEqual(book.id, 1)
        XCTAssertEqual(book.title, "Hamlet")
        
        // Generation in this case should be stateless
        // Generation should give an ability to fill fields partially.
        
        book = generator.generate {
            $0.title = "War and Peace"
        }
        
        XCTAssertEqual(book.id, unstubbedInt)
        XCTAssertEqual(book.title, "War and Peace")
    }
    
    // Values generated by default should be constant all the time.
    // This is done by seeding random generator with a constant.
    // This is done to make test failures reproduceable.
    func test___generate___is_reporducable() {
        let book: Book = generator.generate()
        
        XCTAssertEqual(book.id, 2947667278772165694)
        XCTAssertEqual(book.title, "")
        XCTAssertEqual(book.author.id, -144895307711186549)
        XCTAssertEqual(book.author.name, "NJA8GJGRxnuC1")
    }
    
    func test___generate___can_stub_nested_types() {
        stubConstants()
        
        let book: Book = generator.generate {
            $0.author.stub {
                $0.id = 2
                $0.name = "William Shakespeare"
            }
        }
        
        XCTAssertEqual(book.id, unstubbedInt)
        XCTAssertEqual(book.title, unstubbedString)
        XCTAssertEqual(book.author.id, 2)
        XCTAssertEqual(book.author.name, "William Shakespeare")
    }
    
    func test___generate___can_generate_non_final_classes() {
        mocks.register(type: ByFieldsGenerator<TitledEntity>.self) { _ in
            ByFieldsGenerator<TitledEntity> { fields in
                try TitledEntity(
                    title: fields.title.get()
                )
            }
        }
        
        let entity: TitledEntity = generator.generate {
            $0.title = "How to title a book for dummies."
        }
        
        XCTAssertEqual(entity.title, "How to title a book for dummies.")
    }
    
    func test___stub() {
        stubConstants()
        
        generator.stub(type: Book.self) {
            $0.id = 1
        }
        
        let book: Book = generator.generate()
        
        XCTAssertEqual(book.id, 1)
    }
    
    func test___generate___can_generate_CaseIterable_enums() {
        // High-level check. Checks that it works
        
        let value = generator.generate() as CaseIterableEnum
        
        XCTAssert(CaseIterableEnum.allCases.contains(value))
        
        // Low-level check. Checks that it is random. Relies on implementation.
        
        mocks.register(type: RandomNumberProvider.self) { _ in
            ConstantRandomNumberProvider(0)
        }
        
        XCTAssertEqual(
            generator.generate() as CaseIterableEnum,
            CaseIterableEnum.allCases[0]
        )
        
        mocks.register(type: RandomNumberProvider.self) { _ in
            ConstantRandomNumberProvider(1)
        }
        
        XCTAssertEqual(
            generator.generate() as CaseIterableEnum,
            CaseIterableEnum.allCases[1]
        )
    }

    private func stubConstants() {
        mocks.register(type: Generator<Int>.self) { [unstubbedInt] _ in
            ConstantGenerator(unstubbedInt)
        }
        mocks.register(type: Generator<String>.self) { [unstubbedString] _ in
            ConstantGenerator(unstubbedString)
        }
    }
}

private enum CaseIterableEnum: String, Equatable, CaseIterable, DefaultGeneratorProvider {
    case case0
    case case1
}

// To check how generators work with classes
private final class Book: TitledEntity, Equatable, InitializableWithFields {
    let id: Int
    let author: Author
    
    init(fields: Fields<Book>) throws {
        id = try fields.id.get()
        author = try fields.author.get()
        
        super.init(
            title: try fields.title.get()
        )
    }
    
    static func ==(lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.author == rhs.author
    }
}

// To check how generators work with non-final classes
private class TitledEntity {
    let title: String
    
    init(title: String) {
        self.title = title
    }
}

// To check how generators work with structs
private struct Author: Equatable, InitializableWithFields {
    let id: Int
    let name: String
    
    init(fields: Fields<Author>) throws {
        id = try fields.id.get()
        name = try fields.name.get()
    }
}
