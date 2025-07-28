import UIKit

protocol MenuViewInputProtocol: AnyObject {
    func reloadData()
    func scrollToSection(at index: Int)
}

final class MenuViewController: UIViewController {
    
    private var succesAuthContainerView = CustomActionView(
        text: "Вход выполнен успешно",
        imageName: "check-circle",
        color: .mainGreen
    )
    
    private let bannerView = BannerScrollView()
    
    private var geoIcon: UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "Icon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var geoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Москва"
        return label
    }()
    
    private lazy var geoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [geoLabel, geoIcon])
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createMenuSection()
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.cornerRadius = 25
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .white
        collectionView.register(MenuViewCell.self, forCellWithReuseIdentifier: MenuViewCell.identifier)
        collectionView.register(CategoryHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CategoryHeaderReusableView.identifier)
        return collectionView
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createCategorySection()
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .mainBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.masksToBounds = false
        collectionView.layer.shadowColor = UIColor.black.cgColor
        collectionView.layer.shadowOpacity = 0.12
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 4)
        collectionView.layer.shadowRadius = 8
        collectionView.register(CategoryViewCell.self, forCellWithReuseIdentifier: CategoryViewCell.identifier)
        return collectionView
    }()
    
    private lazy var stubView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let presenter: MenuPresenterProtocol
    
    private let bannerMaxHeight: CGFloat = 140
    private let bannerMinHeight: CGFloat = 0
    private var bannerHeightConstraint: NSLayoutConstraint!
    private var selectedCategoryIndex: Int = 0
    
    init(presenter: MenuPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateErrorAppearance(for: succesAuthContainerView)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .mainBackground

        collectionView.dataSource = self
        collectionView.delegate = self
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        view.addSubview(geoStackView)
        view.addSubview(succesAuthContainerView)
        view.addSubview(bannerView)
        view.addSubview(collectionView)
        view.addSubview(categoryCollectionView)
        view.addSubview(stubView)

        setupLayout()
    }
    
    private func setupLayout() {
        bannerHeightConstraint = bannerView.heightAnchor.constraint(equalToConstant: bannerMaxHeight)

        NSLayoutConstraint.activate([
            geoStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            geoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            succesAuthContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            succesAuthContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            succesAuthContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            bannerView.topAnchor.constraint(equalTo: geoStackView.bottomAnchor, constant: 18),
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerHeightConstraint,
            
            stubView.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 17),
            stubView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stubView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stubView.heightAnchor.constraint(equalToConstant: 2),
            
            categoryCollectionView.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 20),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            collectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    //MARK: - Setup Section
    private func createCategorySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(110),
                                              heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(110),
                                               heightDimension: .absolute(40)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        section.interGroupSpacing = 8

        return section
    }
    
    private func createMenuSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let estimatedHeight = view.bounds.height / 5
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.95),
            heightDimension: .absolute(estimatedHeight)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.interGroupSpacing = 12
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(200)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
    
    // MARK: - Setup Animate
    private func animateErrorAppearance(for view: UIView) {
        view.alpha = 0
        view.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 2, options: [], animations: {
                view.alpha = 0
            }) { _ in
                view.isHidden = true
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let newHeight = max(bannerMinHeight, bannerMaxHeight - offset)
        bannerHeightConstraint.constant = newHeight
        
        let shouldShowShadow = offset > 0
        categoryCollectionView.layer.shadowOpacity = shouldShowShadow ? 0.12 : 0.0

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == categoryCollectionView {
            return 1
        } else {
            return presenter.getSectionsCount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return presenter.getSectionsCount()
        } else {
            return presenter.getItemsCount(for: section)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.identifier,
                                                                for: indexPath) as? CategoryViewCell else {
                return UICollectionViewCell()
            }
            let isSelected = indexPath.item == selectedCategoryIndex
            cell.configure(with: presenter.getCategory(at: indexPath.item), selected: isSelected)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuViewCell.identifier,
                                                                for: indexPath) as? MenuViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: presenter.getItem(at: indexPath))
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            selectedCategoryIndex = indexPath.item
            categoryCollectionView.reloadData()
            
            presenter.didSelectCategory(at: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CategoryHeaderReusableView.identifier,
                for: indexPath) as? CategoryHeaderReusableView else {
                    return UICollectionReusableView()
            }
            if let randomItem = presenter.getRandomItem(for: indexPath.section) {
                header.configure(with: randomItem)
            }
            return header
        }
        return UICollectionReusableView()
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          sizeForItemAt indexPath: IndexPath) -> CGSize {
          let width = collectionView.bounds.width - 20
          let height = view.bounds.height / 5
          return CGSize(width: width, height: height)
      }
}

// MARK: - MenuViewInputProtocol
extension MenuViewController: MenuViewInputProtocol {
    func scrollToSection(at index: Int) {
        let headerIndexPath = IndexPath(item: 0, section: index)
        let layoutAttributes = collectionView.layoutAttributesForSupplementaryElement(
            ofKind: UICollectionView.elementKindSectionHeader,
            at: headerIndexPath
        )!
        let offsetY = layoutAttributes.frame.origin.y - collectionView.contentInset.top
        collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
    }
    
    func reloadData() {
        collectionView.reloadData()
        categoryCollectionView.reloadData()
    }
}

#Preview {
    MainTabBarController(assembly: Assembly())
}
