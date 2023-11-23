//
//  Constants.swift
//  PlaneIt-ToDo-Code
//
//  Created by Влад on 20.11.23.
//
import UIKit

struct Constants {
    static let collectionViewLeading: CGFloat = 22
    static let collectionViewTrailing: CGFloat = 22
    // Другие константы...
    
    // Количество колонок в коллекции
    static let numberOfColumns: CGFloat = 5

    // Расстояние между ячейками в коллекции
    static let interitemSpacing: CGFloat = 10

    // Дополнительная высота ячейки для улучшения внешнего вида
    static let additionalHeight: CGFloat = 30
    
    
     enum CoffeeType: String {
        case cup1 = "coffee-cup-1"
        case cup2 = "coffee-cup-2"
        case cup3 = "coffee-cup-3"
        case cup4 = "coffee-cup-4"
        case cup5 = "coffee-cup-5"
        case cup6 = "coffee-cup-6"
        case cup7 = "coffee-cup-7"
        case cup8 = "coffee-cup-8"
        case cup9 = "coffee-cup-9"
        case cup10 = "coffee-cup-10"
    }
}

