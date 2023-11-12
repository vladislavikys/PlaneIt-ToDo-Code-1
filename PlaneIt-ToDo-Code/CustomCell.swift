import UIKit

// Протокол делегата для обработки события нажатия на галочку в ячейке
protocol CustomCellDelegate: AnyObject {
    func checkmarkTapped(at indexPath: IndexPath)
}

class CustomCell: UITableViewCell {

    // Кнопка для отметки задачи
    var checkmarkButton: UIButton!
    // Метка с текстом задачи
    var noteLabel: UILabel!
    // Кнопка для редактирования задачи
    var editButton: UIButton!
    // Замыкание для обработки события нажатия на кнопку редактирования
    var editButtonAction: (() -> Void)?
    
    // Слабая ссылка на делегата
    weak var delegate: CustomCellDelegate?
    // Индекс ячейки
    var indexPath: IndexPath!
    
    // Замыкание для обработки события нажатия на кнопку отметки
    var checkmarkButtonAction: (() -> Void)?

    // Инициализация ячейки
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let cellSpacing: CGFloat = 10 // Размер отступа между ячейками
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: cellSpacing, left: 0, bottom: cellSpacing, right: 0))
       
        setupCheckmark()
        setupNote()
        setupEdit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Настройка кнопки редактирования
    func setupEditButton() {
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    // Обработчик нажатия на кнопку редактирования
    @objc func editButtonTapped() {
        editButtonAction?()
    }
    
    // Обработчик нажатия на кнопку отметки
    @objc func checkmarkButtonTapped() {
        delegate?.checkmarkTapped(at: indexPath)
    }
}

extension CustomCell {
    
    // Настройка кнопки отметки
    func setupCheckmark() {
        checkmarkButton = UIButton()
        checkmarkButton.setImage(UIImage(named: "checkmarkImage"), for: .normal)
        checkmarkButton.setImage(UIImage(named: "checkmarkImageSelected"), for: .selected)
        checkmarkButton = UIButton(frame: CGRect(x: 10, y: 12, width: 24, height: 24))
        checkmarkButton.contentMode = .scaleAspectFit
        // Добавление обработчика нажатия на кнопку отметки
        checkmarkButton.addTarget(self, action: #selector(checkmarkButtonTapped), for: .touchUpInside)
        contentView.addSubview(checkmarkButton)
    }
    
    // Настройка метки с текстом задачи
    func setupNote() {
        noteLabel = UILabel(frame: CGRect(x: 56, y: 16, width: frame.width - 120, height: 24))
        contentView.addSubview(noteLabel)
    }
    
    // Настройка кнопки редактирования
    func setupEdit() {
        editButton = UIButton(type: .system)
        editButton.frame = CGRect(x: frame.width + 12 , y: 10, width: 29, height: 29)
        editButton.setImage(UIImage(named: "edit"), for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        editButton.imageView?.tintColor = UIColor(hex: "99C779")
        // Добавление обработчика нажатия на кнопку редактирования
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        contentView.addSubview(editButton)
    }
}
