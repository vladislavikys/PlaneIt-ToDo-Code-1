import UIKit

// Основной контроллер для управления списком задач
class ToDoListViewController: UIViewController {
    
    // Массив задач
    var tasks: [Task] = [Task(title: "yes", description: "yes", isCompleted: true),
                             Task(title: "no", description: "no", isCompleted: false)]
    
    
    // Элементы интерфейса
    var imageView: UIImageView!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "28313A")
        // Установка изображения, таблицы и кнопок
        setupImageView()
        setupTableView()
        setupCoffeeButton()
        setupTaskButton()

        //readJSON()
        readData()
    }
    
    // Обработчик нажатия на кнопку "Coffee"
    @objc func coffeeButtonTapped() {
            let coffeeViewController = CoffeeViewController()
            coffeeViewController.modalPresentationStyle = .overCurrentContext
            coffeeViewController.modalTransitionStyle = .crossDissolve
            present(coffeeViewController, animated: false, completion: nil)
        }
    
    // Обработчик нажатия на кнопку "Add Task"
    @objc func openTaskScreen() {
        let taskViewController = TaskViewController()
        taskViewController.modalPresentationStyle = .fullScreen
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    // Обработчик нажатия на кнопку "Checkmark"
    @objc func checkmarkButtonTapped(sender: UIButton) {
        guard let cell = sender.superview?.superview as? CustomCell, let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        checkmarkTapped(at: indexPath)
    }
}

// Расширение для работы с таблицей (UITableViewDataSource, UITableViewDelegate)
extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Количество ячеек в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // Футер для секции
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear // Прозрачный фон для отступа
        return footerView
    }
    
    // Отображение ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.delegate = self
        cell.indexPath = indexPath
        
        // Заполнение данных ячейки
        cell.noteLabel.text = tasks[indexPath.row].title
        cell.checkmarkButton.setImage(UIImage(named: "checkmarkImage"), for: .normal)
        cell.checkmarkButton.setImage(UIImage(named: "checkmarkImageSelected"), for: .selected)
        cell.checkmarkButton.isSelected = tasks[indexPath.row].isCompleted
        
        cell.noteLabel.textColor = UIColor(hex: "FFFFFF")
        cell.backgroundColor = UIColor(hex: "333E49")
        cell.layer.cornerRadius = 10
        cell.editButton.tintColor = UIColor(hex: "ACF478")
        
        // Добавление обработчика нажатия на кнопку "Checkmark"
        cell.checkmarkButton.addTarget(self, action: #selector(checkmarkButtonTapped), for: .touchUpInside)
        
        // Добавление обработчика нажатия на кнопку "Edit"
        cell.editButtonAction = { [weak self, indexPath] in
            self?.editTask(at: indexPath)
        }
        cell.setupEditButton()
        
        return cell
    }
    
    // Отмена выделения ячейки при тапе
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    // Добавление функционала удаления задачи по свайпу
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
                self?.deleteTask(at: indexPath)
                completionHandler(true)
            }

            deleteAction.backgroundColor = UIColor(hex: "F66156")
            deleteAction.image = UIImage(systemName: "trash.fill")

            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        }

        // Обработка удаления задачи
        func deleteTask(at indexPath: IndexPath) {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveTasks()
            readJSON()
            print("-------------------------------------")
        }
    
    // Обработчик нажатия на кнопку "Edit"
    @objc func editButtonTapped(at indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.row]

        // Создать экземпляр TaskViewController и передать выбранную задачу
        let taskViewController = TaskViewController()
        taskViewController.task = selectedTask
        taskViewController.isEdit = true
        taskViewController.editingIndexPath = indexPath
        taskViewController.delegate = self
        taskViewController.modalPresentationStyle = .fullScreen

        // Открыть экран редактирования задачи
        present(taskViewController, animated: true, completion: nil)
    }
}

// Расширение для работы с делегатами TaskViewControllerDelegate, CustomCellDelegate
extension ToDoListViewController: TaskViewControllerDelegate, CustomCellDelegate {
    
    // Обработка завершения редактирования задачи
    func completedEditTask(task: Task, at indexPath: IndexPath) {
        // Обновляем задачу в массиве задач
        tasks[indexPath.row] = task
        // Обновляем соответствующую строку в tableView
        tableView.reloadRows(at: [indexPath], with: .automatic)
        saveTasks()
        print("completedEditTask---------------------")
        readJSON()
    }
    
    // Обработка завершения создания задачи
    func completedCreateTask(task: Task) {
        tasks.append(task)
        // Вставляем новую строку в tableView
        let indexPath = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        saveTasks()
        print("completedCreateTask---------------------")
        readJSON()
    }
    
    // Обработка нажатия на кнопку "Checkmark" в ячейке
    func checkmarkTapped(at indexPath: IndexPath) {
        // Инвертируем состояние isCompleted для выбранной задачи
        tasks[indexPath.row].isCompleted.toggle()
        // Обновляем соответствующую строку в tableView
        tableView.reloadRows(at: [indexPath], with: .automatic)
        saveTasks()
        print("checkmarkTapped---------------------")
        readJSON()
    }
}

// Расширение для расширенных цветов
extension UIColor {
    convenience init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgbValue: UInt64 = 0
        guard Scanner(string: hex).scanHexInt64(&rgbValue) else {
            return nil
        }
        
        let red, green, blue: CGFloat
        switch hex.count {
        case 6:
            red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        default:
            return nil
        }
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// Расширение для работы с TaskViewController
extension ToDoListViewController {
    
    // Открыть экран редактирования задачи
    func editTask(at indexPath: IndexPath) {
        let taskViewController = TaskViewController()
        // Конфигурация TaskViewController перед его показом
        taskViewController.delegate = self
        taskViewController.task = tasks[indexPath.row]
        taskViewController.isEdit = true
        taskViewController.editingIndexPath = indexPath
        // Показываем TaskViewController
        present(taskViewController, animated: true, completion: nil)
    }
    // Сохранение задач в UserDefaults
        func saveTasks() {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(tasks)
                UserDefaults.standard.set(data, forKey: "tasks")
            } catch {
                print("Ошибка при кодировании задач: \(error.localizedDescription)")
            }
        }
    
    // Установка изображения в верхней части экрана
    func setupImageView() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        imageView.image = UIImage(named: "helloImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
    }
    
    // Настройка таблицы
    func setupTableView() {
        let margin: CGFloat = 8

        tableView = UITableView(frame: CGRect(x: margin, y: 200, width: view.frame.width - margin - margin, height: view.frame.height - 200))
        tableView.register(CustomCell.self, forCellReuseIdentifier: "customCell")
        tableView.backgroundColor = UIColor(hex: "28313A")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    
    // Настройка кнопки "Coffee"
    func setupCoffeeButton() {
        let coffeeButton = UIButton()
        coffeeButton.setImage(UIImage(named: "coffeButton"), for: .normal)
        coffeeButton.imageView?.contentMode = .scaleAspectFit
        coffeeButton.addTarget(self, action: #selector(coffeeButtonTapped), for: .touchUpInside)
        self.view.addSubview(coffeeButton)
        
        coffeeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coffeeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            coffeeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            coffeeButton.widthAnchor.constraint(equalToConstant: 70),
            coffeeButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    // Настройка кнопки "Add Task"
    func setupTaskButton() {
        let taskButton = UIButton()
        taskButton.setImage(UIImage(named: "addButton"), for: .normal)
        taskButton.imageView?.contentMode = .scaleAspectFit
        taskButton.addTarget(self, action: #selector(openTaskScreen), for: .touchUpInside)
        self.view.addSubview(taskButton)
        
        taskButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            taskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            taskButton.widthAnchor.constraint(equalToConstant: 70),
            taskButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}

extension ToDoListViewController{
    func readJSON(){
        if let tasksData = UserDefaults.standard.data(forKey: "tasks"),
           let tasksArray = try? JSONSerialization.jsonObject(with: tasksData, options: []) as? [[String: Any]] {
            print("Tasks from UserDefaults: \(tasksArray)")
        } else {
            print("No tasks found in UserDefaults.")
        }
    }
    func readData(){
        if let savedTasksData = UserDefaults.standard.data(forKey: "tasks"),
           let savedTasks = try? JSONDecoder().decode([Task].self, from: savedTasksData) {
            tasks = savedTasks
        }
        tableView.reloadData()
    }
}
