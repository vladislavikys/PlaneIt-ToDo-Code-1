import UIKit
class ToDoListViewController: UIViewController {
    
    var tasks: [Task] = [Task(title: "yes", description: "", isCompleted: true),
                         Task(title: "no", description: "", isCompleted: false)]
    
    var imageView: UIImageView!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        setupTableView()
        setupCoffeeButton()
        setupTaskButton()
    }
    
    @objc func coffeeButtonTapped() {
        let coffeeViewController = CoffeeViewController()
        coffeeViewController.modalPresentationStyle  = .overCurrentContext
        present(coffeeViewController,animated: true,completion: nil)
    }
    
    @objc func openTaskScreen() {
        let taskViewController = TaskViewController()
        taskViewController.modalPresentationStyle = .fullScreen
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
}

extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10 // Высота пространства между секциями
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear // Задаем прозрачный фон для отступа
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10 // Высота пространства между секциями
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear // Прозрачный фон для отступа
        return footerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        
        cell.noteLabel.text = tasks[indexPath.row].title
        cell.checkmarkButton.setImage(UIImage(named: "checkmarkImage"), for: .normal)
        cell.checkmarkButton.setImage(UIImage(named: "checkmarkImageSelected"), for: .selected)
        cell.checkmarkButton.isSelected = tasks[indexPath.row].isCompleted
        //        if tasks[indexPath.row].isCompleted{
        //            cell.checkmarkButton.isSelected = true
        //            cell.checkmarkButton.setImage(UIImage(named: "checkmarkImageSelected"), for: .normal)
        //        } else {
        //            cell.checkmarkButton.isSelected = false
        //            cell.checkmarkButton.setImage(UIImage(named: "checkmarkImage"), for: .normal)
        //        }
        cell.noteLabel.textColor = UIColor(hex: "FFFFFF")
        cell.backgroundColor = UIColor(hex: "333E49")
        cell.layer.cornerRadius = 10
        cell.editButton.tintColor = UIColor(hex: "ACF478")
        
        cell.editButtonAction = { [weak self, indexPath] in
            self?.editTask(at: indexPath)
        }
        
        // cell.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        return cell
    }
    // отмена выделение ячейки
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    @objc func editButtonTapped(at indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.row]

        // Создать экземпляр TaskViewController и передать выбранную задачу
        let taskViewController = TaskViewController()
        taskViewController.task = selectedTask
        taskViewController.isEdit = true
        taskViewController.editingIndexPath = indexPath
        taskViewController.delegate = self

        // Открыть экран редактирования задачи
        present(taskViewController, animated: true, completion: nil)
    }

}

extension ToDoListViewController: TaskViewControllerDelegate{
    func completedEditTask(task: Task, at indexPath: IndexPath) {
        // Обновляем задачу в массиве задач
        tasks[indexPath.row] = task
        // Обновляем соответствующую строку в tableView
        tableView.reloadRows(at: [indexPath], with: .automatic)

    }
    
    func completedCreateTask(task: Task) {
        tasks.append(task)
        // Вставляем новую строку в tableView
        let indexPath = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
}

extension UIColor{
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

extension ToDoListViewController{
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
    func setupImageView() {
        imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: view.frame.width, height: 200) )
        imageView.image = UIImage(named: "helloImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        //автолэйаут вроде если будет работать
        //        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        //                                     imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        //                                     imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        //                                     imageView.heightAnchor.constraint(equalToConstant: 200)])
        //не выщло(((
    }
    func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 200,width: view.frame.width, height: view.frame.height - 200))
        tableView.register(CustomCell.self, forCellReuseIdentifier: "customCell")
        tableView.backgroundColor = UIColor(hex:"28313A")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    func setupCoffeeButton() {
        let coffeeButton = UIButton()
        //let coffeeButton = UIButton(frame: CGRect(x: 20, y: view.frame.height - 80, width: 50, height: 50))
        coffeeButton.setImage(UIImage(named: "coffeButton"), for: .normal)
        coffeeButton.imageView?.contentMode = .scaleAspectFit
        coffeeButton.addTarget(self, action: #selector(coffeeButtonTapped), for: .touchUpInside)
        self.view.addSubview(coffeeButton)
        
        //а вот тут аутолей работает
        coffeeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([coffeeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     coffeeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                                     coffeeButton.widthAnchor.constraint(equalToConstant: 50),
                                     coffeeButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    func setupTaskButton() {
        let taskButton = UIButton()
        //let taskButton = UIButton(frame: CGRect(x: view.frame.width - 60, y: view.frame.height - 80, width: 50, height: 50))
        taskButton.setImage(UIImage(named: "addButton"), for: .normal)
        taskButton.imageView?.contentMode = .scaleAspectFit
        taskButton.addTarget(self, action: #selector(openTaskScreen), for: .touchUpInside)
        self.view.addSubview(taskButton)
        
        taskButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([taskButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     taskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                                     taskButton.widthAnchor.constraint(equalToConstant: 50),
                                     taskButton.heightAnchor.constraint(equalToConstant: 50)])
    }
}
