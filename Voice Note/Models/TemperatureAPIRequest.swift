// 
// Created by Anwar Ulhaq on 22.4.2023.
// 
// 

import Foundation

class TemperatureAPIRequest<Resource: APIResource> {
    let resource: Resource

    init(resource: Resource) {
        self.resource = resource
    }
}

extension TemperatureAPIRequest: NetworkRequest {
    func decode(_ data: Data) -> [Resource.ModelType]? {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = CoreDataService.localStorage.getManageObjectContext()
        let wrapper = try? decoder.decode(APIResponseWrapper<Resource.ModelType>.self, from: data)
        return wrapper?.temperatureResponses
    }

    func execute(withCompletion completion: @escaping ([Resource.ModelType]?) -> Void) async throws {
        try await load(resource.url, withCompletion: completion)
    }
}
