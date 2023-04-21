// 
// Created by Anwar Ulhaq on 21.4.2023.
// 
// 

import Foundation

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func execute(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
        print("URL: \(url)")
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response , error) -> Void in
            // TODO handle error
            // TODO handle response
            guard let data = data, let value = self?.decode(data) else {
                print("Error Decoding")
                // TODO Add different kind of decoding errors
                DispatchQueue.main.async { completion(nil) }
                return
            }
            DispatchQueue.main.async { completion(value) }
        }
        task.resume()
    }
}
