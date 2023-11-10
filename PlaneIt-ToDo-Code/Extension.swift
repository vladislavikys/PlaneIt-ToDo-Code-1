//
//  TaskModel.swift
//  PlaneIt-ToDo-Code
//
//  Created by Влад on 4.11.23.
//

import UIKit


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
    
    func addShadowForTextView(shadowColor: CGColor = UIColor.black.cgColor,
                              shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                              shadowOpacity: Float = 0.4,
                              shadowRadius: CGFloat = 3.0){
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
}
extension TaskViewController: TaskViewControllerDelegate{
    func completedCreateTask(data: Task){
        
    }
}
extension ToDoListViewController: TaskViewControllerDelegate{
    func completedCreateTask(task: Task) {
        tasks.append(task)
        tableView.reloadData()
    }
}

