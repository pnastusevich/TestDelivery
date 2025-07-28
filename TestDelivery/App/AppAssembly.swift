

import UIKit

protocol AppAssemblyProtocol: AnyObject {
    func makeRootViewController() -> UIViewController
    func makeMainModule() -> UIViewController
    func makeMenuModule() -> UIViewController
}

final class Assembly: AppAssemblyProtocol {
    private let diContainer = DIContainer()
    
    func makeRootViewController() -> UIViewController {
        let viewController = AuthViewController()
        let router = AuthRouter(viewController: viewController, assembly: self)

        let presenter = AuthPresenter(router: router, view: viewController)
        viewController.setPresenter(presenter)
        
        let view = UINavigationController(rootViewController: viewController)
        return view
    }
    
    func makeMainModule() -> UIViewController {
        let viewController = MainTabBarController(assembly: self)
        return viewController
    }
    
    func makeMenuModule() -> UIViewController {
        let presenter = MenuPresenter(networkManager: diContainer.network)
        let viewController = MenuViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
