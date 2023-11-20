import UIKit

class CoffeeViewController: UIViewController   {
    
    var coffeeTitle = UILabel()
    var coffeeTitleView = UIView()
    var imageView: UIImageView!
    let navBar = UINavigationBar()
    let coffeeCupImage = UIImageView()
    let coffeeImageView = UIImageView()
    let collectionView: UICollectionView = {
        //Эти строки кода представляют собой создание экземпляра UICollectionView с использованием замыкания (closure) и затем его немедленную инициализацию.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //Здесь устанавливаются некоторые параметры макета, такие как направление прокрутки (.vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //Этот объект имеет начальный размер frame: .zero и использует предварительно созданный layout для управления внешним видом и расположением ячеек внутри коллекции.
        return collectionView
    }()
    //Это означает, что замыкание выполняется сразу после его определения, что приводит к созданию и настройке UICollectionView в момент выполнения этого кода.
    
    
    let infoButton = UIButton()
    let circleInfo = UIImageView()
    
    let pickerView = UIView()
    let picker = UIPickerView()
    
    // Добавленные переменные
    let coffeeImages: [String] = ["coffee-cup-1", "coffee-cup-2", "coffee-cup-3", "coffee-cup-4", "coffee-cup-5",
                                  "coffee-cup-6", "coffee-cup-7", "coffee-cup-8", "coffee-cup-9", "coffee-cup-10"]
    var selectedCount = 0
    let pickerCount: [Int] = Array(stride(from: 0, through: 10, by: 1))
    //создать последовательность чисел от 0 до 10 с шагом 1, и затем преобразует эту последовательность в массив типа [Int].
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "333E49")
        
        picker.dataSource = self
        //Устанавливает dataSource (источник данных) для UIPickerView в текущий контроллер.
        //Это означает, что ваш контроллер будет предоставлять данные для UIPickerView.
        picker.delegate = self
        //Устанавливает delegate (делегат) для UIPickerView в текущий контроллер.
        //Это означает, что ваш контроллер будет обрабатывать события и взаимодействия с UIPickerView.
        
        collectionView.register(CoffeeCell.self, forCellWithReuseIdentifier: CoffeeCell.identifier)
        //Регистрирует ячейку CoffeeViewCell для использования в UICollectionView.
        //Это необходимо для создания и повторного использования ячеек.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupCoffeeCup()
        setupImageView()
        setupTitile()
        setupNavigationBar()
        setupCollectionView()
        setupPicker()
        setupInfoButton()
        
    }
    
    func setupTitile(){
        // Настраиваем заголовок coffeeTitle
        coffeeTitle.text = "Coffee control"
        coffeeTitle.textColor = #colorLiteral(red: 0.6592550278, green: 0.8111829162, blue: 0.5474096537, alpha: 1)
        coffeeTitle.font = UIFont(name: "Verdana", size: 25)
        coffeeTitle.textAlignment = .center
        coffeeTitle.translatesAutoresizingMaskIntoConstraints = false
        
        // Настраиваем coffeeTitleView
        coffeeTitleView.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.1921568627, blue: 0.2274509804, alpha: 1)
        coffeeTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(coffeeTitleView)
        view.addSubview(coffeeTitle)
        NSLayoutConstraint.activate([
            // Констрейнты для coffeeTitle
            coffeeTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coffeeTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            coffeeTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            coffeeTitle.heightAnchor.constraint(equalToConstant: 20),
            coffeeTitle.widthAnchor.constraint(equalToConstant: 300),
            // Констрейнты для coffeeTitleView
            coffeeTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coffeeTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coffeeTitleView.heightAnchor.constraint(equalToConstant: 50),
            coffeeTitleView.topAnchor.constraint(equalTo: view.topAnchor)])
        
    }
    
    func setupImageView() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        imageView.image = UIImage(named: "helloImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
    }
    func setupNavigationBar() {
        let navItem = UINavigationItem(title: "Coffee control")
        
        // Добавляем кнопку "Back"
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor(hex: "ACF478")
        navItem.leftBarButtonItem = backButton
        
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
        
        // Настраиваем констрейнты для navBar
        navBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        navBar.tintColor = UIColor(hex: "28313A")
        navBar.barTintColor = UIColor(hex: "28313A")
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = layout
        
        // Рассчитываем ширину ячейки так, чтобы уместить две ячейки в ряд
        let cellWidth = (view.frame.width - 3 * 10) / 2
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CoffeeImageCell.self, forCellWithReuseIdentifier: "CoffeeImageCell")
        
        // Добавляем коллекцию к представлению и настраиваем ее ограничения
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Констрейнты для collectionView
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.collectionViewLeading),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.collectionViewTrailing),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -350),
            collectionView.widthAnchor.constraint(equalToConstant: 50),
            collectionView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    
    func setupCoffeeCup(){
        // Настраиваем изображение coffeeCupImage
        coffeeCupImage.image = UIImage(named: "coffeeCup")
        view.addSubview(coffeeCupImage)
        coffeeCupImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([coffeeCupImage.widthAnchor.constraint(equalToConstant: 100),
                                     coffeeCupImage.heightAnchor.constraint(equalToConstant: 120),
                                     coffeeCupImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60),
                                     coffeeCupImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50)])
       
    }
    func setupPicker(){
        // Настраиваем pickerView
        pickerView.backgroundColor = .white
        pickerView.alpha = 0.90
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.layer.cornerRadius = 10
        
        view.addSubview(pickerView)
        view.addSubview(picker)
        // Настраиваем picker
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([// Констрейнты для picker
            picker.widthAnchor.constraint(equalToConstant: 100),
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            picker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            picker.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -475),
            // Констрейнты для pickerView
            pickerView.widthAnchor.constraint(equalToConstant: 230),
            pickerView.heightAnchor.constraint(equalToConstant: 150),
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 55)])
     
    }
    
    func setupInfoButton(){
        infoButton.setImage(UIImage(named: "information"), for: .normal)
        circleInfo.image = UIImage(named: "informationCirlce")
        view.addSubview(circleInfo)
        view.addSubview(infoButton)
        
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        circleInfo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Констрейнты для informationButton
            infoButton.widthAnchor.constraint(equalToConstant: 100),
            infoButton.heightAnchor.constraint(equalToConstant: 100),
            infoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -10),
            infoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Констрейнты для ellipsForInfo
            circleInfo.widthAnchor.constraint(equalToConstant: 60),
            circleInfo.heightAnchor.constraint(equalToConstant: 60),
            circleInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            circleInfo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -17)])
     
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    func savingSelectedCups(){
        
    }
}


extension CoffeeViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        //это означает, что у нас есть только один столбец, и пользователь может выбирать значения только в этом столбце
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerCount.count
        //Каждая строка будет представлять число от 0 до 10, так как pickerCount создан как массив от 0 до 10 включительно.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
        //в UIPickerView отображаются числа от 0 до 10, то текст каждой строки будет соответствовать числу от 0 до 10.
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCount = row
        // устанавливается равным выбранной строке, то есть значению переменной row.
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        //вызывается для обновления данных в коллекции после изменения selectedCount
        
    }
}

extension CoffeeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCount
        //Таким образом, количество отображаемых чашек кофе в коллекции будет соответствовать выбранному пользователем числу
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //твечает за создание и настройку ячейки коллекции.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoffeeCell.identifier, for: indexPath) as! CoffeeCell
        //получить ячейку для использования, используя идентификатор ячейки
        if indexPath.row < coffeeImages.count {
            let imageName = coffeeImages[indexPath.row]
            cell.imageView.image = UIImage(named: imageName)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //позволяет настраивать размеры ячеек в коллекции
        let width = collectionView.frame.width / 5 - 10
        let height = collectionView.frame.height / 5 + 30
        return CGSize(width: width, height: height)
        //Здесь вы устанавливаете размеры ячеек. Размеры зависят от ширины и высоты коллекции.
        //Количество колонок установлено в 5, и от каждой ячейки вычитается 10 единиц ширины
        //(это для учета отступов между ячейками), а к высоте прибавляется 30 (это просто для увеличения высоты ячейки).
    }
}






