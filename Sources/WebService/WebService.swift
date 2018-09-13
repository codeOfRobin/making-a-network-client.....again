import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}

protocol URLRequestConvertible {
    func toURLRequest() -> Result<URLRequest>
}

enum APIError: Error {
    case dataIsNil()
    case requestCreationFailed(Error)
    case responseInvalid(HTTPURLResponse)
    case urlSesssionError(NSError)
    case parsingError(Error)
}

public struct Resource<A> {
    let url: URL
    let parse: (Data) -> Result<A>

    public init(url: URL, parse: @escaping (Data) -> Result<A>) {
        self.url = url
        self.parse = parse
    }
}

public final class WebService {

    public init() {}

    public func load<A>(resource: Resource<A>, completion: @escaping (Result<A>) -> ()) {
        URLSession.shared.dataTask(with: resource.url) {
            data, response, error in

            if let data = data {
                completion(resource.parse(data))
            } else {

            }
        }.resume()
    }
}
