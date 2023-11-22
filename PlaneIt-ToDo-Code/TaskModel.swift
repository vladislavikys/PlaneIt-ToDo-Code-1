//
//  TaskModel.swift
//  PlaneIt-ToDo-Code
//
//  Created by Влад on 4.11.23.
//

import Foundation

struct Task:Codable{
    var title: String
    var description: String
    var isCompleted: Bool
    var creationDate: Date // поможет уникально идентифицировать каждую задачу и предотвратить путаницу при их удалении.
    
    // Инициализатор для удобства создания задачи
    init(title: String, description: String, isCompleted: Bool, creationDate: Date) {
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.creationDate = Date() // Присваиваем текущую дату при создании задачи
    }
    // Вычисляемое свойство для форматированной даты
        var formattedCreationDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter.string(from: creationDate)
    }
}

//
//
//// добавления новой задачи в массив
//func addTask(title: String) {
//    let newTask = Task(title: title, isCompleted: false)
//    tasks.append(newTask)
//}
//// отметки  как выполненной
//func completeTask(at index: Int) {
//    guard index >= 0 && index < tasks.count else {
//        return
//    }
//    
//    tasks[index].isCompleted = true
//}
