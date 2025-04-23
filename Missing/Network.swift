

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case invalidData
}

class Network {
    static let shared = Network()
    private let session: URLSession
    
    private init() {
        self.session = URLSession(configuration: .default)
    }
    
    func createURL(by queries: [URLQueryItem]) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "ws-public.interpol.int"
        components.path = "/notices/v1/yellow"
        components.queryItems = queries
        
        if let url = components.url {
            return url
        } else {
            throw NetworkError.invalidURL
        }
    }
    
    func fetchPersons(from url: URL) -> AnyPublisher<Notices, Error> {
        print(url)
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { $0 as Error }
            .decode(type: Notices.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchImageData(from urlString: String) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func fetchPersonDetails(for id: String) -> AnyPublisher<PersonDetails, Error> {
        guard let url = URL(string: "https://ws-public.interpol.int/notices/v1/yellow/" + id) else { return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { $0 as Error }
            .decode(type: PersonDetails.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchPersonImagesLink(for id: String) -> AnyPublisher<PersonImageslink, Error> {
        guard let url = URL(string: "https://ws-public.interpol.int/notices/v1/yellow/" + id + "/images") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { $0 as Error }
            .decode(type: PersonImageslink.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
