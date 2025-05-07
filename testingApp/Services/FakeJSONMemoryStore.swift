//
//  FakeJSONMemoryStore.swift
//  testingApp
//
//  Created by Rama Adi Nugraha on 07/05/25.
//
import Foundation

/**
 # FakeJSONMemoryStore
 
 An in-memory, thread-safe key-value store for storing and retrieving Codable objects as JSON-encoded data.
 
 This class is primarily intended for use in unit tests, previews, or development environments where you want to simulate persistent storage without writing to disk.
 
 ## Features
 
 - Thread-safe access using a concurrent queue with barrier writes.
 - Stores any `Encodable` object under a string key.
 - Retrieves any `Decodable` object by key and type.
 - Supports deletion and full reset of storage.
 - Singleton access via `FakeJSONMemoryStore.shared`.
 
 ## Example Usage
 
 ```swift
 // Saving an object
 let user = User(id: 1, name: "Alice")
 FakeJSONMemoryStore.shared.save(user, forKey: "currentUser")
 
 // Loading an object
 if let loadedUser: User = FakeJSONMemoryStore.shared.load(User.self, forKey: "currentUser") {
 print(loadedUser.name)
 }
 
 // Deleting an object
 FakeJSONMemoryStore.shared.delete(forKey: "currentUser")
 
 // Resetting all storage
 FakeJSONMemoryStore.shared.reset()
 ```
 
 ## Thread Safety
 
 All operations are thread-safe. Writes (save, delete, reset) use a barrier to ensure exclusive access, while reads (load) are concurrent.
 
 */
final class FakeJSONMemoryStore {
    /// Shared singleton instance for global access.
    static let shared = FakeJSONMemoryStore()
    
    /// Internal storage dictionary mapping keys to JSON-encoded Data.
    private var storage: [String: Data] = [:]
    /// Concurrent queue for thread-safe access.
    private let queue = DispatchQueue(label: "FakeJSONMemoryStoreQueue", attributes: .concurrent)
    
    /// Private initializer to enforce singleton usage.
    private init() {}
    
    /**
     Saves an `Encodable` object to the store under the specified key.
     
     - Parameters:
     - object: The object to encode and store.
     - key: The string key under which to store the object.
     
     The operation is performed asynchronously and is thread-safe.
     */
    func save<T: Encodable>(_ object: T, forKey key: String) {
        queue.async(flags: .barrier) {
            if let data = try? JSONEncoder().encode(object) {
                self.storage[key] = data
            }
        }
    }
    
    /**
     Loads and decodes an object of the specified type from the store.
     
     - Parameters:
     - type: The type of object to decode.
     - key: The string key under which the object is stored.
     
     - Returns: The decoded object if found and decoding succeeds, otherwise `nil`.
     
     The operation is performed synchronously and is thread-safe.
     */
    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        var result: T?
        queue.sync {
            if let data = self.storage[key] {
                result = try? JSONDecoder().decode(T.self, from: data)
            }
        }
        return result
    }
    
    /**
     Deletes the object stored under the specified key.
     
     - Parameter key: The string key of the object to delete.
     
     The operation is performed asynchronously and is thread-safe.
     */
    func delete(forKey key: String) {
        queue.async(flags: .barrier) {
            self.storage.removeValue(forKey: key)
        }
    }
    
    /**
     Removes all objects from the store.
     
     The operation is performed asynchronously and is thread-safe.
     */
    func reset() {
        queue.async(flags: .barrier) {
            self.storage.removeAll()
        }
    }
}
