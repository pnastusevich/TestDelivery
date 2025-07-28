protocol EndpointProtocol {
    var method: HTTPMethod { get }
    var path: String { get }
    var scheme: String { get }
    var host: String { get }
}

enum Endpoint: EndpointProtocol {
    case all
    
    var method: HTTPMethod {
        HTTPMethod.get
    }
    
    var path: String {
       "/all"
    }
    
    var scheme: String {
        "https"
    }

    var host: String {
        "free-food-menus-api-two.vercel.app"
    }
}
