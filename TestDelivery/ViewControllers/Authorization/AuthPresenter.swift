import Foundation

protocol AuthPresenterProtocol {
    func checkLogin(username: String, password: String)
}

final class AuthPresenter: AuthPresenterProtocol {
   
    weak var view: AuthViewControllerProtocol?
    private let router: AuthRouterProtocol
    
    init(router: AuthRouterProtocol, view: AuthViewControllerProtocol) {
        self.router = router
        self.view = view
    }
    
    func checkLogin(username: String, password: String) {
        let authModel = AuthModel(login: "qwe", password: "qwe")
            
        if authModel.login == username && authModel.password == password {
            router.navigateToMainScreen()
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        } else {
            view?.showError()
        }
    }
}
