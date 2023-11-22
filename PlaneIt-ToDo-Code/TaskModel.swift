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
    //var creationDate: Date
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
