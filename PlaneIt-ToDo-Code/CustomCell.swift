//
//  CustomCell.swift
//  PlaneIt-ToDo-Code
//
//  Created by Влад on 2.11.23.
//
import UIKit
class CustomCell: UITableViewCell {
    
    var checkmarkButton: UIButton!
    var noteLabel: UILabel!
    var editButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Создание чек-марка
        checkmarkButton = UIButton()
        checkmarkButton.setImage(UIImage(named: "checkmarkImage"), for: .normal)
        checkmarkButton.setImage(UIImage(named: "checkmarkImageSelected"), for: .selected)
        checkmarkButton = UIButton(frame: CGRect(x: 16, y: 16, width: 24, height: 24))
        checkmarkButton.contentMode = .scaleAspectFit
        contentView.addSubview(checkmarkButton)
        
        // Создание  заметки
        noteLabel = UILabel(frame: CGRect(x: 56, y: 16, width: frame.width - 120, height: 24))
        contentView.addSubview(noteLabel)
        
        // Создание  редактирования заметки
        editButton = UIButton(type: .system)
        editButton.frame = CGRect(x: frame.width - 56, y: 16, width: 40, height: 24)
        editButton.setImage(UIImage(named: "edit"), for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        editButton.imageView?.tintColor = UIColor(hex: "99C779")
        contentView.addSubview(editButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func checkmarkButtonTapped() {
            checkmarkButton.isSelected = !checkmarkButton.isSelected
            if checkmarkButton.isSelected {
                checkmarkButton.setImage(UIImage(named: "checkmarkImageSelected"), for: .normal)
            } else {
                checkmarkButton.setImage(UIImage(named: "checkmarkImage"), for: .normal)
            }
        }
}
