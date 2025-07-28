import UIKit

final class MenuViewCell: UICollectionViewCell {
    static let identifier = "MenuViewCell"
    
    private let imageLoader = ImageLoader.shared

    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .mainCrimson
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 13, weight: .semibold)
            return outgoing
        }
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)
        config.background.cornerRadius = 8
        config.background.strokeWidth = 1
        config.background.strokeColor = .mainCrimson
        
        let button = UIButton()
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(itemImageView)
        contentView.addSubview(infoStack)

        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceButton)
        contentView.addSubview(separatorView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            itemImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            
            titleLabel.topAnchor.constraint(equalTo: itemImageView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            priceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            priceButton.bottomAnchor.constraint(equalTo: itemImageView.bottomAnchor),
            priceButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.27),
            priceButton.heightAnchor.constraint(equalToConstant: 37),
            
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with item: MenuItem) {
        if let url = URL(string: item.img) {
                imageLoader.loadImage(from: url) { [weak self] image in
                    self?.itemImageView.image = image
                }
            } else {
                itemImageView.image = UIImage(named: "pizza1")
            }
        titleLabel.text = item.name
        descriptionLabel.text = item.dsc
        priceButton.setTitle("от \(item.price) р", for: .normal)
    }
}
