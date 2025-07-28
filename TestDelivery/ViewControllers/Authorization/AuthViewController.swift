import UIKit

protocol AuthViewControllerProtocol: AnyObject {
    func showError()
}

final class AuthViewController: UIViewController {
    
    private var errorContainerView = CustomActionView(
        text: "Неверный логин или пароль",
        imageName: "close-circle",
        color: .mainCrimson
    )
    
    // MARK: Login View
    private var logoImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    private var loginTextField = CustomTextField(
        placeholder: "Логин",
        iconName: "Union",
        isSecure: false
    )
    
    private let passwordTextField = CustomTextField(
        placeholder: "Пароль",
        iconName: "lock-line",
        isSecure: true
    )
    // MARK: Bottom View
    private var bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .mainCrimson
        button.layer.cornerRadius = 18
        button.alpha = 0.4
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    private var presenter: AuthPresenterProtocol!
    
    private var bottomConstraint: NSLayoutConstraint!
    private var logoTopConstraint: NSLayoutConstraint!
    private var keyboardIsShown = false
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loginTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        setupKeyboardNotifications()
        setupDismissKeyboardGesture()
    }
    
    func setPresenter(_ presenter: AuthPresenterProtocol) {
        self.presenter = presenter
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Setup UI
    private func setupUI() {
        navigationItem.title = "Авторизация"
        view.backgroundColor = .mainBackground
        
        view.addSubview(logoImageView)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(bottomContainerView)
        bottomContainerView.addSubview(loginButton)
        bottomContainerView.addSubview(backgroundView)
        bottomContainerView.sendSubviewToBack(backgroundView)
        view.addSubview(errorContainerView)

        setupLayout()
    }
    
    private func setupLayout() {
        logoTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140)
        bottomConstraint = loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        
        NSLayoutConstraint.activate([
            errorContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            errorContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            errorContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            logoTopConstraint,
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            loginTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint,
            bottomContainerView.heightAnchor.constraint(equalToConstant: 120),
            
            loginButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 25),
            loginButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -25),
            loginButton.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 10),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            backgroundView.topAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            backgroundView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor)
        ])
    }
    
    // MARK: - Setup Keyboard
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard !keyboardIsShown,
            let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                      let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return }
        
        keyboardIsShown = true
        
        bottomConstraint.constant = -frame.height - 16
        logoTopConstraint.constant = 40
                
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        keyboardIsShown = false

        bottomConstraint.constant = -30
        logoTopConstraint.constant = 140
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldsDidChange() {
        let isLoginEmpty = loginTextField.text?.isEmpty ?? true
        let isPasswordEmpty = passwordTextField.text?.isEmpty ?? true
        
        let isEnabledView = !isLoginEmpty && !isPasswordEmpty
        loginButton.isEnabled = isEnabledView
        loginButton.alpha = isEnabledView ? 1.0 : 0.4
    }
    
    @objc private func loginButtonTapped() {
        guard let username = loginTextField.text,
              let password = passwordTextField.text else { return }
        presenter.checkLogin(username: username, password: password)
    }
    
    private func animateErrorAppearance(for view: UIView) {
        view.alpha = 0
        view.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 2.5, options: [], animations: {
                view.alpha = 0
            }) { _ in
                view.isHidden = true
            }
        }
    }
}

extension AuthViewController: AuthViewControllerProtocol {
    func showError() {
        animateErrorAppearance(for: errorContainerView)
    }
}
