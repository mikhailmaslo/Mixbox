import MixboxGenerators

open class BaseTestFailingGenerator: TestFailingGenerator {
    private let testFailingAnyGenerator: TestFailingAnyGenerator
    private let testFailingObjectGenerator: TestFailingObjectGenerator
    private let testFailingArrayGenerator: TestFailingArrayGenerator
    private let testFailingDictionaryGenerator: TestFailingDictionaryGenerator
    private let testFailingOptionalGenerator: TestFailingOptionalGenerator
    
    public init(
        baseTestFailingGeneratorDependencies: BaseTestFailingGeneratorDependencies)
    {
        self.testFailingAnyGenerator = baseTestFailingGeneratorDependencies.testFailingAnyGenerator
        self.testFailingObjectGenerator = baseTestFailingGeneratorDependencies.testFailingObjectGenerator
        self.testFailingArrayGenerator = baseTestFailingGeneratorDependencies.testFailingArrayGenerator
        self.testFailingDictionaryGenerator = baseTestFailingGeneratorDependencies.testFailingDictionaryGenerator
        self.testFailingOptionalGenerator = baseTestFailingGeneratorDependencies.testFailingOptionalGenerator
    }
    
    // MARK: - TestFailingAnyGenerator
    
    public func generate<T>(type: T.Type) -> T {
        return testFailingAnyGenerator.generate(type: type)
    }
    
    // MARK: - TestFailingObjectGenerator
    
    public func generate<T: RepresentableByFields>(
        type: T.Type,
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
        -> T
    {
        return testFailingObjectGenerator.generate(
            type: type,
            configure: configure
        )
    }
    
    // MARK: - TestFailingOptionalGenerator
    
    public func some<T>(
        type: T.Type)
        -> T?
    {
        return testFailingOptionalGenerator.some(type: type)
    }
    
    public func some<T: RepresentableByFields>(
        type: T.Type,
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
        -> T?
    {
        return testFailingOptionalGenerator.some(type: type, configure: configure)
    }
    
    // MARK: - TestFailingArrayGenerator
    
    public func array<T>(
        count: Int,
        type: T.Type)
        -> [T]
    {
        return testFailingArrayGenerator.array(
            count: count,
            type: type
        )
    }
        
    public func array<T: RepresentableByFields>(
        count: Int,
        type: T.Type,
        configure: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<T>) throws -> ())
        -> [T]
    {
        return testFailingArrayGenerator.array(
            count: count,
            type: type,
            configure: configure
        )
    }
    
    // MARK: - TestFailingDictionaryGenerator
    
    public func dictionary<K, V>(
        count: Int,
        keyType: K.Type,
        valueType: V.Type)
        -> [K: V]
    {
        return testFailingDictionaryGenerator.dictionary(
            count: count,
            keyType: keyType,
            valueType: valueType
        )
    }
    
    public func dictionary<K: RepresentableByFields, V>(
        count: Int,
        keyType: K.Type,
        valueType: V.Type,
        keys: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<K>) throws -> ())
        -> [K: V]
    {
        return testFailingDictionaryGenerator.dictionary(
            count: count,
            keyType: keyType,
            valueType: valueType,
            keys: keys
        )
    }
    
    public func dictionary<K, V: RepresentableByFields>(
        count: Int,
        keyType: K.Type,
        valueType: V.Type,
        values: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<V>) throws -> ())
        -> [K: V]
    {
        return testFailingDictionaryGenerator.dictionary(
            count: count,
            keyType: keyType,
            valueType: valueType,
            values: values
        )
    }
    
    public func dictionary<K: RepresentableByFields, V: RepresentableByFields>(
        count: Int,
        keyType: K.Type,
        valueType: V.Type,
        keys: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<K>) throws -> (),
        values: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<V>) throws -> ())
        -> [K: V]
    {
        return testFailingDictionaryGenerator.dictionary(
            count: count,
            keyType: keyType,
            valueType: valueType,
            keys: keys,
            values: values
        )
    }
}
