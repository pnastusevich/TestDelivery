import Foundation

protocol MenuPresenterProtocol: AnyObject {
    func loadData()
    func getSectionsCount() -> Int
    func getItemsCount(for section: Int) -> Int
    func getItem(at indexPath: IndexPath) -> MenuItem
    func getCategory(at index: Int) -> String
    func getTitleForSection(_ index: Int) -> String
    func didSelectCategory(at index: Int)
    func getRandomItem(for section: Int) -> MenuItem?
}

final class MenuPresenter: MenuPresenterProtocol {
    
    private var sections: [CategorySection] = []
    
    weak var view: MenuViewInputProtocol?
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func loadData() {
        networkManager.fetchMenu { [weak self] result in
            guard let self else { return }
                switch result {
                case .success(let menuResponse):
                    var newSections: [CategorySection] = []
                    
                    if let pizzas = menuResponse.pizzas {
                        var pizzasItems = Array(pizzas.prefix(11))
                        pizzasItems.remove(at: 0)
                        newSections.append(CategorySection(title: "Пицца", items: pizzasItems))
                    }
                    if let desserts = menuResponse.desserts {
                        let dessertItems = Array(desserts.prefix(10))
                        newSections.append(CategorySection(title: "Десерты", items: dessertItems))
                    }
                    if let drinks = menuResponse.drinks {
                        let drinksItems = Array(drinks.prefix(10))
                        newSections.append(CategorySection(title: "Напитки", items: drinksItems))
                    }
                    if let burgers = menuResponse.burgers {
                        let burgersItems = Array(burgers.prefix(10))
                        newSections.append(CategorySection(title: "Бургеры", items: burgersItems))
                    }
                    
                    DispatchQueue.main.async {
                        self.sections = newSections
                        self.view?.reloadData()
                    }
                case .failure(let error):
                    print("Ошибка загрузки меню:", error)
                }
        }
    }

    func getSectionsCount() -> Int {
        sections.count
    }
    
    func getItem(at indexPath: IndexPath) -> MenuItem {
        sections[indexPath.section].items[indexPath.item]
    }
    
    func getItemsCount(for section: Int) -> Int {
        guard section >= 0 && section < sections.count else { return 0 }
        return sections[section].items.count
    }
    
    func getCategory(at index: Int) -> String {
        guard index >= 0 && index < sections.count else { return "" }
        return sections[index].title
    }
    
    func getTitleForSection(_ index: Int) -> String {
        getCategory(at: index)
    }
    
    func didSelectCategory(at index: Int) {
        view?.scrollToSection(at: index)
    }
    
    func getRandomItem(for section: Int) -> MenuItem? {
        guard section >= 0 && section < sections.count else { return nil }
        return sections[section].items.randomElement()
    }
}
