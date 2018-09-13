import Foundation
import Unbox

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

struct Episode {
    
}

extension Episode {
//    var media: Resource<Media> {
//        let url = NSURL(string: "http://localhost:8000/episodes/\(id).json")!
//        // TODO Return the resource ...
//    }

    static var all: Resource<[Int]> = Resource(url: URL(string: "http://localhost:8000/episodes/.json")!) { (data) in
        return .success([1,2,3,4])
    }
}

extension Resource where A: Unboxable {
    init(url: URL, parse:  @escaping (Unboxer) -> Result<A>) {
        self.url = url
        self.parse = {
            data in
            do {
                let item: A = try unbox(data: data)
                return .success(item)
            } catch {
                return .failure(error)
            }
        }
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
