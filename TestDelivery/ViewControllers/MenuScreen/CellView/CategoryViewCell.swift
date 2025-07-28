
import UIKit

final class CategoryViewCell: UICollectionViewCell {
    static let identifier = "CategoryViewCell"

    private var button: UIButton = {
        let button = UIButton(type: .system)
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    func configure(with title: String, selected: Bool) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseForegroundColor = .mainCrimson
        config.baseBackgroundColor = selected ? UIColor.mainCrimson.withAlphaComponent(0.15) : .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 22, bottom: 6, trailing: 22)
        config.cornerStyle = .capsule
        config.background.strokeWidth = selected ? 0 : 1
        config.background.strokeColor = .mainCrimson
        
        let font = UIFont.systemFont(ofSize: 13, weight: selected ? .semibold : .regular)
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: font]))
        
        button.configuration = config
    }
}
