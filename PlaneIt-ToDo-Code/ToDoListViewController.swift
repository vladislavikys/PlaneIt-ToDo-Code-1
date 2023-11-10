import UIKit


class ToDoListViewController: UIViewController {
    
    var tasks: [Task] = [Task(title: "yes", description: "", isCompleted: true),
                         Task(title: "no", description: "", isCompleted: false)]
    
    var imageView: UIImageView!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        imageView.image = UIImage(named: "testImg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 200,width: view.frame.width, height: view.frame.height - 200))
        tableView.register(CustomCell.self, forCellReuseIdentifier: "customCell")
        tableView.backgroundColor = UIColor(hex:"28313A")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        let coffeeButton = UIButton(frame: CGRect(x: 20, y: view.frame.height - 80, width: 50, height: 50))
        coffeeButton.setImage(UIImage(named: "coffeButton"), for: .normal) 
        coffeeButton.imageView?.contentMode = .scaleAspectFit
        coffeeButton.addTarget(self, action: #selector(coffeeButtonTapped), for: .touchUpInside)
        self.view.addSubview(coffeeButton)
        
        let taskButton = UIButton(frame: CGRect(x: view.frame.width - 60, y: view.frame.height - 80, width: 50, height: 50))
        taskButton.setImage(UIImage(named: "addButton"), for: .normal)
        taskButton.imageView?.contentMode = .scaleAspectFit
        taskButton.addTarget(self, action: #selector(openTaskScreen), for: .touchUpInside)
        self.view.addSubview(taskButton)
        
    }
    
    @objc func coffeeButtonTapped() {
        let coffeeViewController = CoffeeViewController()
        coffeeViewController.modalPresentationStyle  = .overCurrentContext
        present(coffeeViewController,animated: true,completion: nil)
    }
    
    @objc func openTaskScreen() {
        let taskViewController = TaskViewController()
        taskViewController.modalPresentationStyle = .fullScreen
        present(taskViewController, animated: true, completion: nil)
    }
}


extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        
        
        cell.noteLabel.text = tasks[indexPath.row].title
        if tasks[indexPath.row].isCompleted{
                cell.checkmarkButton.isSelected = true
                cell.checkmarkButton.setImage(UIImage(named: "checkmarkImageSelected"), for: .normal)
            } else {
                cell.checkmarkButton.isSelected = false
                cell.checkmarkButton.setImage(UIImage(named: "checkmarkImage"), for: .normal)
            }
        cell.noteLabel.textColor = UIColor(hex: "FFFFFF")
        cell.backgroundColor = UIColor(hex: "333E49")
        cell.layer.cornerRadius = 10
        cell.editButton.tintColor = UIColor(hex: "ACF478")
        cell.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    @objc func editButtonTapped() {
        // Логика для редактирования заметки
    }
}

extension ToDoListViewController: TaskViewControllerDelegate{
    func completedCreateTask(task: Task) {
        tasks.append(task)
        tableView.reloadData()
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

