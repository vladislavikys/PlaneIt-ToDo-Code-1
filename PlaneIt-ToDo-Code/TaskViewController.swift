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
    
    // Данные задачи
    var task: Task?
    
    var isEdit: Bool = false
    var editingIndexPath: IndexPath?
    
    // Делегат для обновления данных в ToDoListViewController
    var delegate: TaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Заполнение элементов интерфейса данными задачи при редактировании
        if isEdit, let taskToEdit = task {
            nameLabel.text = taskToEdit.title
            descriptionTextView.text = taskToEdit.description
        }
        
        // Настройка навигационной панели
        let navItem = UINavigationItem(title: "")
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navBar.tintColor = UIColor(hex: "28313A")
        navBar.barTintColor = UIColor(hex: "28313A")
        
        // Кнопки навигационной панели
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor(hex: "ACF478")
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        saveButton.tintColor = UIColor(hex: "ACF478")
        navItem.leftBarButtonItem = backButton
        navItem.rightBarButtonItem = saveButton
        navBar.setItems([navItem], animated: false)
        
        // Настройка интерфейса
        setupNameLabel()
        setupDescriptionTextView()
        
        navBar.backgroundColor = UIColor(hex: "28313A")
        view.backgroundColor = UIColor(hex: "333E49")
    }
    
    // Методы UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        //  добавить логику при начале редактирования описания
        if nameLabel.text == "Name" {
            nameLabel.text = ""
            nameLabel.textColor = .white
            }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //  добавить логику при завершении редактирования описания
        if descriptionTextView.text == "Description" {
            descriptionTextView.text = ""
            descriptionTextView.textColor = .white
            }
    }
    
    // Обработчик нажатия кнопки "Back"
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    // Обработчик нажатия кнопки "Save"
    @objc private func saveButtonTapped() {
        guard let textName = nameLabel.text, let textDescription = descriptionTextView.text else {
            // Возможно, показать сообщение об ошибке пользователю
            return
        }
        
        if isEdit, let editingIndexPath = editingIndexPath {
            // Если редактируем существующую задачу
            let updatedTask = Task(title: textName, description: textDescription, isCompleted: task?.isCompleted ?? false)
            // Обновляем задачу
            task?.title = textName
            task?.description = textDescription
            // Вызываем метод делегата, чтобы обновить задачу в массиве и таблице
            delegate?.completedEditTask(task: updatedTask, at: editingIndexPath)
        } else {
            // Создаем новую задачу
            let newTask = Task(title: textName, description: textDescription, isCompleted: false)
            // Вызываем метод делегата, чтобы добавить новую задачу в массив и таблицу
            delegate?.completedCreateTask(task: newTask)
        }

        // Закрываем TaskViewController после сохранения
        dismiss(animated: true, completion: nil)
    }
}

// Расширение для настройки интерфейса
extension TaskViewController {
    func setupNameLabel() {
        nameLabel.delegate = self
        if isEdit == false {
            nameLabel.text = " Name"
        }
        nameLabel.textColor = .gray
        nameLabel.backgroundColor = UIColor(hex: "333E49")
        nameLabel.clipsToBounds = true
        nameLabel.autocapitalizationType = .words
        nameLabel.layer.masksToBounds = true
        view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupDescriptionTextView() {
        descriptionTextView.delegate = self
        
        if isEdit == false {
            descriptionTextView.text = " Desccription"
        }
        descriptionTextView.font = .systemFont(ofSize: 20)
        descriptionTextView.autocapitalizationType = .words
        descriptionTextView.textColor = .white
        descriptionTextView.backgroundColor = UIColor(hex: "5B5B5B")
        descriptionTextView.autocapitalizationType = .words
        view.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        descriptionTextView.layer.cornerRadius = 20
        descriptionTextView.layer.masksToBounds = true
    }
}
