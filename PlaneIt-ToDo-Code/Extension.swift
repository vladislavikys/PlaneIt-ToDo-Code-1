//
//  TaskModel.swift
//  PlaneIt-ToDo-Code
//
//  Created by Влад on 4.11.23.
//

import UIKit

// Расширение для UIView с добавлением внутренней тени
extension UIView {
    func addShadow() {
        
        let innerShadow = CALayer()
        innerShadow.frame = bounds
        let radius = self.frame.size.height / 2
        let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: -1, dy: -1), cornerRadius: radius)
        let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius: radius).reversing()
        
        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true
        innerShadow.shadowColor = UIColor.black.cgColor
        innerShadow.shadowOffset = CGSize(width: 1, height: 3)
        innerShadow.shadowOpacity = 1
        innerShadow.shadowRadius = 1
        innerShadow.cornerRadius = self.frame.size.height / 2
        
        layer.addSublayer(innerShadow)
    }
    
    // Добавление тени для UITextView с настраиваемыми параметрами
    func addShadowForTextView(shadowColor: CGColor = UIColor.black.cgColor,
                              shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                              shadowOpacity: Float = 0.4,
                              shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
}

// Расширение для делегата TaskViewController в ToDoListViewController
extension ToDoListViewController: TaskViewControllerDelegate {
    
    // Добавление новой задачи и обновление таблицы с анимацией
    func completedCreateTask(task: Task) {
        tasks.append(task)
        let indexPath = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // Обновление существующей задачи и таблицы с анимацией
    func completedEditTask(task: Task, at indexPath: IndexPath) {
        tasks[indexPath.row] = task
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// Расширение для делегата CustomCell в ToDoListViewController
extension ToDoListViewController: CustomCellDelegate {
    
    // Обработка нажатия на кнопку отметки в ячейке
    func checkmarkTapped(at indexPath: IndexPath) {
        // Инвертирование состояния isCompleted для выбранной задачи
        tasks[indexPath.row].isCompleted.toggle()
        // Обновление соответствующей строки в tableView с анимацией
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
