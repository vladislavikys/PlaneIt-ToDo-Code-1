import UIKit

class CoffeeViewController: UIViewController   {
    
    var coffeeTitle = UILabel()
    var coffeeTitleView = UIView()
    var imageView: UIImageView!
    let navBar = UINavigationBar()
    let coffeeCupImage = UIImageView()
    let coffeeImageView = UIImageView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()
    
    
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
        
        
        setupNavigationBar()
        setupCollectionView()
        setupPicker()
        setupInfoButton()
        
    }
    
    func setupImageView() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        imageView.image = UIImage(named: "coffee_image_VC")
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
        // Настройка цвета и шрифта текста заголовка
        navBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(hex: "ACF478")!,
            NSAttributedString.Key.font: UIFont(name: "Verdana", size: 20) ?? UIFont.systemFont(ofSize: 20)
        ]
        navBar.barTintColor = UIColor(hex: "28313A")
    }
    
    func setupCollectionView() {
        // Определение констант для отступов и количества элементов в ряду
        let leadingTrailingSpacing: CGFloat = 10
        let numberOfItemsInRow: CGFloat = 2
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = layout
        
        // Рассчитываем ширину ячейки так, чтобы уместить две ячейки в ряд
        let cellWidth = (view.frame.width - (numberOfItemsInRow + 1) * leadingTrailingSpacing) / numberOfItemsInRow
        // (numberOfItemsInRow + 1) * leadingTrailingSpacing - общая ширина отступов между ячейками (между двумя ячейками и слева и справа от коллекции).
        // Результат делится на numberOfItemsInRow для определения ширины каждой ячейки.
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
            // Устанавливаем левый констрейнт для collectionView, привязывая его к левому краю основного представления (view)
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.collectionViewLeading),

            // Устанавливаем правый констрейнт для collectionView, привязывая его к правому краю основного представления (view) с учетом отступа
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.collectionViewTrailing),

            // Устанавливаем верхний констрейнт для collectionView, привязывая его к верхней грани основного представления (view) с учетом отступа
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 280),

            // Устанавливаем нижний констрейнт для collectionView, привязывая его к нижней грани основного представления (view) с учетом отступа
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -340),

            // Устанавливаем констрейнт на ширину collectionView, фиксируя его ширину в 50 точек
            collectionView.widthAnchor.constraint(equalToConstant: 50),

            // Устанавливаем констрейнт на высоту collectionView, фиксируя его высоту в 20 точек
            collectionView.heightAnchor.constraint(equalToConstant: 20)

        ])
    }
    
    
    func setupCoffeeCup(){
        // Настраиваем изображение coffeeCupImage
        coffeeCupImage.image = UIImage(named: "coffeeCup")
        coffeeCupImage.tintColor = UIColor(hex:"CFCFCF")
        view.addSubview(coffeeCupImage)
        coffeeCupImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([coffeeCupImage.widthAnchor.constraint(equalToConstant: 100),//Устанавливает констрейнт на ширину
                                     coffeeCupImage.heightAnchor.constraint(equalToConstant: 120),//Устанавливает констрейнт на высоту
                                     coffeeCupImage.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -240),
                                     coffeeCupImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50)])
    }
    func setupPicker(){
        // Настраиваем pickerView
        pickerView.backgroundColor = UIColor(hex: "28313A")
        pickerView.alpha = 0.5
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.layer.cornerRadius = 10
        
        
        view.addSubview(pickerView)
        view.addSubview(picker)
        // Настраиваем picker
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([// Констрейнты для picker
            picker.widthAnchor.constraint(equalToConstant: 100),//Устанавливает ширину picker в 100 точек.
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),//Размещает центр picker по горизонтали в центре основног (view), вправо
            picker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 180),//Размещает центр picker по вертикали в центре основного  (view),  вниз
            picker.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -680),//Устанавливает высоту picker так, чтобы она занимала высоту основного представления (view) за вычетом
            //580 impiric method
            
            // Констрейнты для pickerView
            pickerView.widthAnchor.constraint(equalToConstant: 230),//Устанавливает ширину pickerView в 230 точек.
            pickerView.heightAnchor.constraint(equalToConstant: 150),//Устанавливает высоту pickerView в 150 точек.
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),//Размещает центр pickerView по горизонтали в центре   (view).
            pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)])
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
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = "\(row)"
        let color = UIColor(hex: "CFCFCF")!
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
        //в UIPickerView отображаются числа от 0 до 10, то текст каждой строки будет соответствовать числу от 0 до 10.
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Устанавливаем значение переменной selectedCount равным выбранной строке (выбранному числу чашек)
        selectedCount = row
        print(selectedCount)
        
        // Вызываем reloadData() для обновления данных в коллекции после изменения выбранного числа чашек
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

}

extension CoffeeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCount
        //Таким образом, количество отображаемых чашек кофе в коллекции будет соответствовать выбранному пользователем числу
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Отвечает за создание и настройку ячейки коллекции.
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoffeeCell.identifier, for: indexPath) as! CoffeeCell
            
            // Проверяем, чтобы индекс строки был меньше чем количество изображений в массиве coffeeImages
            if indexPath.row < coffeeImages.count {
                let imageName = coffeeImages[indexPath.row]
                cell.updateCups(cup: UIImage(named: imageName)!)
            }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        // Рассчитываем ширину ячейки так, чтобы уместить numberOfColumns ячеек в ряд
        let cellWidth = (collectionView.frame.width - (Constants.numberOfColumns - 1) * Constants.interitemSpacing) / Constants.numberOfColumns

        // Рассчитываем высоту ячейки, учитывая дополнительную высоту
        let cellHeight = collectionView.frame.height / Constants.numberOfColumns + Constants.additionalHeight


        return CGSize(width: cellWidth, height: cellHeight)
        //Здесь вы устанавливаете размеры ячеек. Размеры зависят от ширины и высоты коллекции.
        //Количество колонок установлено в 5, и от каждой ячейки вычитается 10 единиц ширины
        //(это для учета отступов между ячейками), а к высоте прибавляется 30 (это просто для увеличения высоты ячейки).
    }
}

