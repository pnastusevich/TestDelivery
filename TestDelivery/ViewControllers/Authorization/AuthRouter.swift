import UIKit

protocol AuthRouterProtocol {
    func navigateToMainScreen()
}

final class AuthRouter: AuthRouterProtocol {
    private weak var viewController: UIViewController?
    private let assembly: AppAssemblyProtocol
    
    init(viewController: UIViewController, assembly: AppAssemblyProtocol) {
        self.viewController = viewController
        self.assembly = assembly
    }
    
    func navigateToMainScreen() {
        guard let navigationController = viewController?.navigationController else { return }
        let mainVC = assembly.makeMainModule()
            navigationController.setViewControllers([mainVC], animated: true)
    }
}
