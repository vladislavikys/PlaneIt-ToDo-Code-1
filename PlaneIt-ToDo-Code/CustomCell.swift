import UIKit

protocol CustomCellDelegate: AnyObject {
    func checkmarkTapped(at indexPath: IndexPath)
}

class CustomCell: UITableViewCell {

    var checkmarkButton: UIButton!
    var noteLabel: UILabel!
    
    var editButton: UIButton!
    var editButtonAction: (() -> Void)?
    
    weak var delegate: CustomCellDelegate?
    var indexPath: IndexPath!
    var checkmarkButtonAction: (() -> Void)?
    

        
    
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
    
    func setupEditButton() {
            editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    @objc func editButtonTapped() {
        editButtonAction?()
    }
    @objc func checkmarkButtonTapped() {
            delegate?.checkmarkTapped(at: indexPath)
        }
    
    
}

extension CustomCell{
    func setupCheckmark(){
        checkmarkButton = UIButton()
        checkmarkButton.setImage(UIImage(named: "checkmarkImage"), for: .normal)
        checkmarkButton.setImage(UIImage(named: "checkmarkImageSelected"), for: .selected)
        checkmarkButton = UIButton(frame: CGRect(x: 10, y: 12, width: 24, height: 24))
        checkmarkButton.contentMode = .scaleAspectFit
        contentView.addSubview(checkmarkButton)
    }
    func setupNote(){
        noteLabel = UILabel(frame: CGRect(x: 56, y: 16, width: frame.width - 120, height: 24))
        contentView.addSubview(noteLabel)
    }
    func setupEdit(){
         editButton = UIButton(type: .system)
         editButton.frame = CGRect(x: frame.width + 12 , y: 10, width: 29, height: 29)
         editButton.setImage(UIImage(named: "edit"), for: .normal)
         editButton.imageView?.contentMode = .scaleAspectFit
         editButton.imageView?.tintColor = UIColor(hex: "99C779")
         editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
         contentView.addSubview(editButton)
    }
}
