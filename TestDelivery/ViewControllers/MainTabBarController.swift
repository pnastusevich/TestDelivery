import UIKit

final class MainTabBarController: UITabBarController {
    
    let assembly: AppAssemblyProtocol
    
    init(assembly: AppAssemblyProtocol) {
        self.assembly = assembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        setupUI()
    }
    
    private func setupUI() {
        let firstViewController =  assembly.makeMenuModule()
        let secondVC = UIViewController()
        let thirdVC = UIViewController()
        let fourthVC = UIViewController()

        firstViewController.tabBarItem = UITabBarItem(title: "Меню", image: UIImage(named: "menu"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "Контакты", image: UIImage(named: "contact"), tag: 1)
        thirdVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.fill"), tag: 2)
        fourthVC.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(named: "carts1"), tag: 3)
        
        tabBar.tintColor = .mainCrimson
        
        viewControllers = [firstViewController, secondVC, thirdVC, fourthVC]
    }
}

#Preview {
    MainTabBarController(assembly: Assembly())
}
