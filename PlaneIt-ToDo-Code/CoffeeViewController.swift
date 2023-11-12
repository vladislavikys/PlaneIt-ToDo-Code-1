import UIKit

class CoffeeViewController: UIViewController {

    let navBar = UINavigationBar()
    let coffeeImageView = UIImageView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let quantitySelector = UIStepper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCoffeeImageView()
        setupNavigationBar()
        setupCollectionView()
        setupQuantitySelector()
    }
    
    func setupNavigationBar() {
        let navItem = UINavigationItem(title: "Coffee")
        
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor(hex: "ACF478")
        
        navItem.leftBarButtonItem = backButton
        navBar.setItems([navItem], animated: false)
        
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: coffeeImageView.bottomAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        navBar.tintColor = UIColor(hex: "28313A")
        navBar.barTintColor = UIColor(hex: "28313A")
    }
    
    func setupCoffeeImageView() {
        coffeeImageView.image = UIImage(named: "coffeeImage")
        coffeeImageView.contentMode = .scaleAspectFill
        coffeeImageView.clipsToBounds = true
        view.addSubview(coffeeImageView)
        
        coffeeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coffeeImageView.topAnchor.constraint(equalTo: view.topAnchor),
            coffeeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coffeeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coffeeImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func setupCollectionView() {
        // Настройте вашу коллекцию из изображений кофе
        // Используйте UICollectionView и UICollectionViewDelegate, UICollectionViewDataSource для этого
        view.backgroundColor = .black
    }
    
    func setupQuantitySelector() {
        quantitySelector.minimumValue = 1
        quantitySelector.maximumValue = 10
        quantitySelector.value = 1
        quantitySelector.addTarget(self, action: #selector(quantityChanged), for: .valueChanged)
        quantitySelector.backgroundColor = .white
        view.addSubview(quantitySelector)
        
        quantitySelector.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quantitySelector.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quantitySelector.topAnchor.constraint(equalTo: coffeeImageView.bottomAnchor, constant: 500)
        ])
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func quantityChanged() {
        // Обработайте изменение значения в quantitySelector
        // Можете использовать quantitySelector.value для получения текущего значения
    }
}
