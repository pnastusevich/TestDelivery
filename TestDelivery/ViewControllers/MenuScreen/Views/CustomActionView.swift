import UIKit

final class CustomActionView: UIView {
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        return view
    }()
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.masksToBounds = false
        
        return view
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(text: String, imageName: String, color: UIColor) {
        super.init(frame: .zero)
        setupUI(text: text, imageName: imageName, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(text: String, imageName: String, color: UIColor) {
        
        imageView.image = UIImage(named: imageName)
        label.text = text
        label.textColor = color
        
        self.addSubview(containerView)
        containerView.addSubview(backgroundView)
        containerView.addSubview(label)
        containerView.addSubview(imageView)
       
        setupLayout()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isHidden = true
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            backgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            backgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            label.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -16),
            
            imageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            imageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
