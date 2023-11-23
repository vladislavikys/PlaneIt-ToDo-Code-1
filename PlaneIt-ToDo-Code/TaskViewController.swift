import UIKit

// Протокол для делегата TaskViewController
protocol TaskViewControllerDelegate {
    func completedCreateTask(task: Task)
    func completedEditTask(task: Task, at indexPath: IndexPath)
}


class TaskViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    // Элементы интерфейса
    let nameLabel = UITextField()
    let descriptionTextView = UITextView()
    let navBar = UINavigationBar()
    var saveButton: UIBarButtonItem!

    // Данные задачи
    var task: Task?
    var isEdit: Bool = false
    var editingIndexPath: IndexPath?
    
    // Делегат для обновления данных в ToDoListViewController
    var delegate: TaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.delegate = self
        
        // Заполнение элементов интерфейса данными задачи при редактировании
        if isEdit, let taskToEdit = task {
            nameLabel.text = taskToEdit.title
            descriptionTextView.text = taskToEdit.description
        }
        
        // Настройка интерфейса
        setupNavigationBar()
        setupNameLabel()
        setupDescriptionTextView()
        
        // Добавляем распознаватель жестов для скрытия клавиатуры по тапу
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        navBar.backgroundColor = UIColor(named: "28313A")
        view.backgroundColor = UIColor(named: "333E49")

    }
    // Обработчик изменения текста в поле ввода
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // метод , который вызывается каждый раз, когда текст в текстовом поле изменяется.
        if textField == nameLabel {
            //если не меняли то
            // Вызываем метод для обновления состояния кнопки "Save"
            updateSaveButtonState()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Чтобы открыть клавиатуру при выборе nameLabel и очистить его содержимое
        if textField == nameLabel {
            textField.text = ""
            textField.textColor = .white
            textField.becomeFirstResponder()
        }
    }
    //баг
    //    func textViewDidChange(_ textView: UITextView) {
    //        if textView == descriptionTextView {
    //            textView.text = ""
    //            textView.becomeFirstResponder()
    //        }
    //    }
    
    // Метод делегата для скрытия клавиатуры при нажатии на клавишу "Return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Скрываем клавиатуру
        return true
    }
    // Метод для обновления состояния кнопки "Save"
    private func updateSaveButtonState() {
        let nameFilled = !(nameLabel.text?.isEmpty ?? true)
        // Устанавливаем состояние кнопки "Save" в зависимости от заполненности поля nameLabel
        //если label не меняли быдет false
        saveButton.isEnabled = nameFilled
    }
    
    // Обработчик нажатия кнопки "Back"
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    // Обработчик тапа для скрытия клавиатуры
    @objc private func handleTap() {
        view.endEditing(true)
    }
    // Обработчик нажатия кнопки "Save"
    @objc private func saveButtonTapped() {
        guard let textName = nameLabel.text, !textName.isEmpty,
              let textDescription = descriptionTextView.text else {
            // Обработка случая, когда заголовок задачи не введен
            // Можете добавить  предупреждение для пользователя но нам не нужно
            //если данных нет кнопка SAVE  не доступна к сохранения 
            return
        }

        let currentDate = Date()

        if isEdit, let editingIndexPath = editingIndexPath {
            // Если редактируем существующую задачу
            let updatedTask = Task(id: task?.id ?? UUID().uuidString, title: textName, description: textDescription, isCompleted: task?.isCompleted ?? false, creationDate: currentDate)
            // Вызываем метод делегата, чтобы обновить задачу в массиве и таблице
            delegate?.completedEditTask(task: updatedTask, at: editingIndexPath)
        } else {
            // Создаем новую задачу
            let newTask = Task(id: UUID().uuidString, title: textName, description: textDescription, isCompleted: task?.isCompleted ?? false, creationDate: currentDate)

            // Вызываем метод делегата, чтобы добавить новую задачу в массив и таблицу
            delegate?.completedCreateTask(task: newTask)
        }

        // Закрываем TaskViewController после сохранения
        dismiss(animated: true, completion: nil)
    }

}

// Расширение для настройки интерфейса
extension TaskViewController {
    func setupNavigationBar(){
        // Настройка навигационной панели
        let navItem = UINavigationItem(title: "")
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        // отключает автоматическую конвертацию констрейнтов в AutoresizingMask при использовании Auto Layout. Мы хотим управлять констрейнтами вручную.
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        //устанавливает верхнюю границу навигационной панели находящейся ниже границы безопасной области верхнего края родительского представления.
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //устанавливает левую границу навигационной панели находящейся в начале (левом краю) родительского представления.
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //устанавливает правую границу навигационной панели находящейся в конце (правом краю) родительского представления.
        navBar.tintColor = UIColor(named: "28313A")
        navBar.barTintColor = UIColor(named: "28313A")
        
        // Кнопки навигационной панели
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor(named: "ACF478")
        
        // Создаем кнопку "Save"
        saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        saveButton.tintColor = UIColor(named: "ACF478")
        
        navItem.leftBarButtonItem = backButton
        navItem.rightBarButtonItem = saveButton
        navBar.setItems([navItem], animated: false)
        
        // Устанавливаем начальное состояние кнопки "Save"
        updateSaveButtonState()
    }
    
    // Настройка текстового поля для ввода названия задачи
    func setupNameLabel() {
        // Установка делегата для обработки событий текстового поля
        nameLabel.delegate = self
        
        // Условие: если мы  находимся в режиме создания, устанавливаем текст по умолчанию
        if isEdit == false {
            nameLabel.text = "Name..."
        }
        
        // Настройка внешнего вида текстового поля
        nameLabel.textColor = .gray
        nameLabel.backgroundColor = UIColor(named: "333E49")
        nameLabel.clipsToBounds = true
        nameLabel.autocapitalizationType = .words
        nameLabel.layer.masksToBounds = true
        
        // Добавление текстового поля на экран
        view.addSubview(nameLabel)
        
        // Настройка Auto Layout для текстового поля
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 10), // Отступ от навигационной панели
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // Отступ слева
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15), // Отступ справа
            nameLabel.heightAnchor.constraint(equalToConstant: 40) // Высота текстового поля
        ])
    }

    
    func setupDescriptionTextView() {
        descriptionTextView.delegate = self
        if isEdit == false {
            descriptionTextView.text = "Description..."
        }
        descriptionTextView.font = .systemFont(ofSize: 20)
        descriptionTextView.autocapitalizationType = .words
        descriptionTextView.textColor = .white
        descriptionTextView.backgroundColor = UIColor(named: "5B5B5B")
        descriptionTextView.autocapitalizationType = .words
        descriptionTextView.layer.cornerRadius = 20
        descriptionTextView.layer.masksToBounds = true
        view.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)])
    }
}

