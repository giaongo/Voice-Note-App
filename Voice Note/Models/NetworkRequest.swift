// 
// Created by Anwar Ulhaq on 21.4.2023.
// 
// 

import Foundation

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) async -> ModelType?
    func execute(withCompletion completion: @escaping (ModelType?) -> Void) async throws
}

extension NetworkRequest {
    func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) async throws {
        let request = URLRequest(url: url)
        let data = try await URLSession.shared.data(for: request, delegate: nil).0

        if let value = await decode(data) {
            completion(value)
        } else {
            completion(nil)

        }

    }
}