import UIKit

// Основной контроллер для управления списком задач
class ToDoListViewController: UIViewController {
    
    var tasks: [Task] = []
    
    // Элементы интерфейса
    var imageView: UIImageView!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "28313A")
        
        // Установка изображения, таблицы и кнопок
        setupImageView()
        setupTableView()
        setupCoffeeButton()
        setupTaskButton()
        
        //функция перемешения ячеек которую не смог реализовать
        //tableView.dragInteractionEnabled = true
        //tableView.dragDelegate = self
        //tableView.dropDelegate = self
        
        // Загрузка обновленные задачи
        readData()
    }
    
    // Обработчик нажатия на кнопку "Coffee"
    @objc func coffeeButtonTapped() {
        // Создание экземпляра CoffeeViewController
        let coffeeViewController = CoffeeViewController()
        // Установка стиля модальной презентации
        coffeeViewController.modalPresentationStyle = .overCurrentContext

        // Установка стиля анимации перехода
        coffeeViewController.modalTransitionStyle = .crossDissolve

        // Вызов метода презентации экрана coffeeViewController
        present(coffeeViewController, animated: false, completion: nil)
    }

    
    // Обработчик нажатия на кнопку "Add Task"
    @objc func openTaskScreen() {
        // Создание экземпляра TaskViewController
        let taskViewController = TaskViewController()

        // Установка стиля модальной презентации на полный экран
        taskViewController.modalPresentationStyle = .fullScreen

        // Установка делегата для обработки событий из TaskViewController
        taskViewController.delegate = self

        // Вызов метода презентации экрана taskViewController
        present(taskViewController, animated: true, completion: nil)
    }

    
    // Обработчик нажатия на кнопку "Checkmark"
    @objc func checkmarkButtonTapped(sender: UIButton) {
        // Получение ячейки, в которой находится кнопка
        guard let cell = sender.superview?.superview as? CustomCell,
            let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        // Вызов метода обработки нажатия на "Checkmark" для соответствующей ячейки
        checkmarkTapped(at: indexPath)
    }

}

// Расширение для работы с таблицей (UITableViewDataSource, UITableViewDelegate)
extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Количество ячеек в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    // Отображение ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем ячейку из переиспользуемых ячеек с идентификатором "customCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        // Назначаем делегата ячейке
        cell.delegate = self
        // Устанавливаем IndexPath для ячейки
        cell.indexPath = indexPath
        
        // Заполняем данные ячейки
        cell.noteLabel.text = tasks[indexPath.row].title
        cell.checkmarkButton.setImage(UIImage(named: "checkmarkImage"), for: .normal)
        cell.checkmarkButton.setImage(UIImage(named: "checkmarkImageSelected"), for: .selected)
        cell.checkmarkButton.isSelected = tasks[indexPath.row].isCompleted
        
        // Настраиваем внешний вид ячейки
        cell.noteLabel.textColor = UIColor(named: "FFFFFF")
        cell.backgroundColor = UIColor(named: "333E49")
        cell.layer.cornerRadius = 10
        cell.editButton.tintColor = UIColor(named: "ACF478")
        
        // Добавляем обработчик нажатия на кнопку "Checkmark"
        cell.checkmarkButton.addTarget(self, action: #selector(checkmarkButtonTapped), for: .touchUpInside)
        
        // Добавляем обработчик нажатия на кнопку "Edit"
        cell.editButtonAction = { [weak self, indexPath] in
            self?.editTask(at: indexPath)
        }
        // Настраиваем кнопку "Edit"
        cell.setupEditButton()
        
        return cell
    }
    
    // Отмена выделения ячейки при тапе
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    // Добавление функционала удаления задачи по свайпу
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Создаем действие удаления
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            // Получаем идентификатор задачи для удаления
            guard let taskID = self?.tasks[indexPath.row].id else {
                completionHandler(false)
                return
            }
            // Вызываем метод удаления задачи
            self?.deleteTask(withID: taskID)
            completionHandler(true)
        }
        // Настраиваем внешний вид действия удаления
        deleteAction.backgroundColor = UIColor(named: "F66156")
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        // Создаем конфигурацию для свайпа с действием удаления
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    // Обработка удаления задачи
    func deleteTask(withID id: String) {
        // Ищем индекс задачи в массиве по ее идентификатору
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            // Удаляем задачу из массива
            tasks.remove(at: index)
            // Перезагружаем всю таблицу после удаления
            tableView.reloadData()
            // Сохраняем обновленные задачи
            saveTasks()
            
            // Если необходимо проверить данные после удаления
    //        print("-------------------------------------")
    //        readJSON()
    //        print("-------------------------------------")
        }
    }

    
    // Обработчик нажатия на кнопку "Edit"
    @objc func editButtonTapped(at indexPath: IndexPath) {
        // Получаем выбранную задачу
        let selectedTask = tasks[indexPath.row]

        // Создаем экземпляр TaskViewController и передаем выбранную задачу
        let taskViewController = TaskViewController()
        taskViewController.task = selectedTask
        taskViewController.isEdit = true
        taskViewController.editingIndexPath = indexPath
        taskViewController.delegate = self
        taskViewController.modalPresentationStyle = .fullScreen

        // Открываем экран редактирования задачи
        present(taskViewController, animated: true, completion: nil)

        // Сохраняем обновленные задачи
        saveTasks()

        // Если необходимо проверить данные после редактирования
    //    print("@objc func editButtonTapped-------------------------------------")
    //    readJSON()
    //    print("@objc func editButtonTapped-------------------------------------")
    }
}

// Расширение для работы с делегатами TaskViewControllerDelegate, CustomCellDelegate
extension ToDoListViewController: TaskViewControllerDelegate, CustomCellDelegate {
    
    // Обработка завершения редактирования задачи
    func completedEditTask(task: Task, at indexPath: IndexPath) {
        // Поиск индекса задачи с таким же id в массиве
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            // Обновляем задачу в массиве задач
            tasks[index] = task
            
            // Обновляем соответствующую строку в tableView
            tableView.reloadRows(at: [indexPath], with: .automatic)
            // Сохраняем обновленные задачи
            saveTasks()
            
            // Проверка данных после редактирования
//            print("func completedEditTask---------------------")
//            readJSON()
//            print("func completedEditTask---------------------")
        } else {
            // Если задача с указанным id не найдена, возможно, выполнить какое-то дополнительное действие или выводить сообщение об ошибке
            print("Task with id \(task.id) not found.")
        }
    }
    
    // Обработка завершения создания задачи
    func completedCreateTask(task: Task) {
        var updatedTask = task
        updatedTask.creationDate = Date() // Присваиваем текущую дату при создании задачи
        updatedTask.id = UUID().uuidString // Генерируем уникальный идентификатор для задачи
        
        tasks.append(updatedTask)
        // Вставляем новую строку в tableView
        let indexPath = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        // Сохраняем обновленные задачи
        saveTasks()
        
        // Проверка данных после создания задачи
//        print("completedCreateTask---------------------")
//        readJSON()
//        print("completedCreateTask---------------------")
    }
    
    // Обработка нажатия на кнопку отметки в ячейке
    func checkmarkTapped(at indexPath: IndexPath) {
        // Инвертируем состояние isCompleted для выбранной задачи
        tasks[indexPath.row].isCompleted.toggle()
        // Обновляем соответствующую строку в tableView
        tableView.reloadRows(at: [indexPath], with: .automatic)
        // Сохраняем обновленные задачи
        saveTasks()
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
        // Определение отступа от краев экрана
        let margin: CGFloat = 8
        
        // Создание UITableView с указанием координат, ширины и высоты
        tableView = UITableView(frame: CGRect(x: margin, y: 200, width: view.frame.width - margin * 2, height: view.frame.height - 200))
        
        // Регистрация ячейки, которую будет использовать таблица
        tableView.register(CustomCell.self, forCellReuseIdentifier: "customCell")
        
        tableView.backgroundColor = UIColor(named: "28313A")
        
        // Назначение текущего класса в качестве источника данных (dataSource) и делегата (delegate) таблицы
        tableView.dataSource = self
        tableView.delegate = self
        
        // Добавление таблицы на главное представление
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



//перенес в свой файл можно кдалть если все работает норм как раньше
extension ToDoListViewController {
    // Сохранение задач в UserDefaults
    func saveTasks() {
        do {
            // Создаем экземпляр JSONEncoder для кодирования данных в формат JSON
            let encoder = JSONEncoder()
            // Преобразуем массив задач в данные формата JSON
            let data = try encoder.encode(tasks)
            // Сохраняем закодированные данные в UserDefaults по ключу "tasks"
            UserDefaults.standard.set(data, forKey: "tasks")
        } catch {
            // В случае ошибки выводим информацию об ошибке
            print("Ошибка при кодировании задач: \(error.localizedDescription)")
        }
    }

    // Загрузка данных из UserDefaults
    func readData() {
        // Проверяем наличие данных по ключу "tasks" в UserDefaults
        if let savedTasksData = UserDefaults.standard.data(forKey: "tasks") {
            do {
                // Декодируем данные формата JSON в массив задач типа [Task]
                let savedTasks = try JSONDecoder().decode([Task].self, from: savedTasksData)
                // Присваиваем массиву задач сохраненные задачи
                tasks = savedTasks
            } catch {
                // В случае ошибки выводим информацию об ошибке
                print("Error decoding saved tasks: \(error.localizedDescription)")
            }
        }
        // Обновляем отображение таблицы после загрузки данных
        tableView.reloadData()
    }

    // Чтение данных из UserDefaults в формате JSON (для отладки)
    func readJSON() {
        // Проверяем наличие данных по ключу "tasks" в UserDefaults
        if let tasksData = UserDefaults.standard.data(forKey: "tasks") {
            do {
                // Декодируем данные формата JSON в массив задач типа [Task]
                let tasksArray = try JSONDecoder().decode([Task].self, from: tasksData)
                // Выводим информацию о задачах в консоль (для отладки)
                print("Tasks from UserDefaults: \(tasksArray)")
            } catch {
                // В случае ошибки выводим информацию об ошибке
                print("Error decoding tasks: \(error.localizedDescription)")
            }
        } else {
            // Выводим сообщение, если нет сохраненных задач
            print("No tasks found in UserDefaults.")
        }
    }
}
// Расширение для расширенных цветов
extension UIColor {
    convenience init?(named: String) {
        let hex = named.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
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


/*
 extension ToDoListViewController : UITableViewDragDelegate, UITableViewDropDelegate {
 // Реализация методов для поддержки перемещения ячеек
 //ЭТА ЗАЛУПА ВРОДЕ РАБОТАЕТ НО ПЕРЕМЕШИВАЕТ ЯЧЕЙКИ УХХХХХХХХ БЛЯ
 //ОЧЕНБ ХОТЕЛОСЬ РЕАЛЗОВАТЬ НО НЕ ВЫШЛО ((((((((
 
 // Метод делегата для поддержки начала перемещения ячейки
 func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
 let task = tasks[indexPath.row]
 
 // Создаем провайдер элемента для перемещаемой задачи
 let itemProvider = NSItemProvider(object: task.id as NSString)
 
 // Создаем объект UIDragItem с использованием провайдера
 let dragItem = UIDragItem(itemProvider: itemProvider)
 
 // Возвращаем массив с единственным UIDragItem
 return [dragItem]
 }
 // Метод для обновления идентификатора задачи при перемещении
 func updateTaskId(at indexPath: IndexPath, withNewId newId: String) {
 tasks[indexPath.row].id = newId
 saveTasks()
 readJSON()
 }
 
 
 // Метод делегата для поддержки перемещения ячейки внутри той же таблицы
 func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
 // Удаляем задачу из исходной позиции
 let movedTask = tasks.remove(at: sourceIndexPath.row)
 
 // Вставляем задачу на новую позицию
 tasks.insert(movedTask, at: destinationIndexPath.row)
 
 // Сохраняем изменения и обновляем отображение
 saveTasks()
 readJSON()
 }
 
 
 // Метод делегата для определения, может ли быть принята перемещаемая ячейка
 func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
 // Возвращаем true только для локальных сессий перемещения (внутри той же таблицы)
 return session.localDragSession != nil
 }
 
 // Метод делегата для обработки завершения перемещения ячейки
 func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
 // Проверяем, что у нас есть пункт назначения (куда была перемещена ячейка)
 guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
 
 // Обработка завершения перемещения ячейки
 coordinator.session.loadObjects(ofClass: NSString.self) { items in
 // Проверяем, что мы получили массив строк и первый элемент не nil
 guard let ids = items as? [String], let id = ids.first else { return }
 
 // Ищем индекс перемещаемой задачи в массиве
 if let movedTaskIndex = self.tasks.firstIndex(where: { $0.id == id }) {
 // Удаляем задачу из старой позиции и вставляем ее на новую позицию
 let movedTask = self.tasks.remove(at: movedTaskIndex)
 self.tasks.insert(movedTask, at: destinationIndexPath.row)
 
 // Обновляем отображение и сохраняем изменения
 self.tableView.insertRows(at: [destinationIndexPath], with: .automatic)
 self.saveTasks()
 self.readJSON()
 }
 }
 }
 
 }
 
 */
