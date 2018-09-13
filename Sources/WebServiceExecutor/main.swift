import WebService
import Foundation

let semaphore = DispatchSemaphore(value: 0)

let url = URL.init(string: "https://httpbin.org/get")!
let resource = Resource(url: url) { (data) -> Result<Int> in
    return .success(0)
}


let service = WebService()
service.load(resource: resource) { (result) in
    semaphore.signal()
    print(result)
}
semaphore.wait()
