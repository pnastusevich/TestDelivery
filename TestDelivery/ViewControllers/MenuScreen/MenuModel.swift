
struct CategorySection {
    let title: String
    let items: [MenuItem]
}

struct MenuItem: Codable {
    let id: String
    let img: String
    let name: String
    let dsc: String
    let price: Double
    let rate: Int
    let country: String
}

struct MenuResponse: Codable {
    let pizzas: [MenuItem]?
    let desserts: [MenuItem]?
    let drinks: [MenuItem]?
    let burgers: [MenuItem]?
}

