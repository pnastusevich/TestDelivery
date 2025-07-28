import UIKit

final class CustomTextField: UITextField {
    
    private var toggleButton: UIButton?
    
    // MARK: - Init
    init(placeholder: String, iconName: String, isSecure: Bool) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecure
        setupUI(iconName: iconName, isSecure: isSecure)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Setup UI
    private func setupUI(iconName: String, isSecure: Bool) {
        setupBaseStyle()
        setupLeftIcon(named: iconName)
        
        if isSecure {
            setupRightToggleButton()
        }
    }
    
    private func setupBaseStyle() {
        translatesAutoresizingMaskIntoConstraints = false
        borderStyle = .none
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupLeftIcon(named iconName: String) {
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: iconName)
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.tintColor = .gray
        leftImageView.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        
        let leftContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftImageView.center = leftContainer.center
        leftContainer.addSubview(leftImageView)
        
        leftView = leftContainer
        leftViewMode = .always
    }
    
    private func setupRightToggleButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .gray
        button.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.background.backgroundColor = .clear
        button.configuration = config
        button.configurationUpdateHandler = { btn in
            btn.configuration?.background.backgroundColor = .clear
            btn.configuration?.baseBackgroundColor = .clear
        }
        
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        button.center = rightContainer.center
        rightContainer.addSubview(button)
        
        rightView = rightContainer
        rightViewMode = .always
        
        self.toggleButton = button
    }
      
    // MARK: - Actions
    @objc private func togglePasswordVisibility() {
        isSecureTextEntry.toggle()

        let imageName = isSecureTextEntry ? "eye.slash" : "eye"
        toggleButton?.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
