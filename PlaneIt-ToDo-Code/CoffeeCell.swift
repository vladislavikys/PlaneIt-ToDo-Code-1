//
//  CoffeeCell.swift
//  PlaneIt-ToDo-Code
//
//  Created by Влад on 20.11.23.
import UIKit

class CoffeeCell: UICollectionViewCell {
    //это кастомная ячейка для использования в коллекции
    static let identifier = "CoffeeViewCell"
    //Используется для идентификации ячейки. Вы можете использовать это значение при регистрации ячейки для использования в UICollectionView.
    let imageView: UIImageView = {
        //Это изображение внутри ячейки, которое будет отображаться. Он создается с использованием замыкания и настраивается для корректного отображения.
        let image = UIImageView()
        
        // Установка режима масштабирования содержимого изображения.
        image.contentMode = .scaleAspectFit
        
        // Установка свойства clipsToBounds в true, чтобы избежать обрезки изображения за пределами границ UIImageView.
        image.clipsToBounds = true
        
        // Установка свойства translatesAutoresizingMaskIntoConstraints в false, чтобы использовать Auto Layout.
        image.translatesAutoresizingMaskIntoConstraints = false
        
        // Возврат созданного и настроенного экземпляра UIImageView.
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Добавление imageView в иерархию представлений contentView.
        contentView.addSubview(imageView)

        // Активация Auto Layout-ограничений с использованием NSLayoutConstraint.activate.
        NSLayoutConstraint.activate([
            // Ограничение: верхняя граница imageView равна верхней границе contentView.
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),

            // Ограничение: левая граница imageView равна левой границе contentView.
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            // Ограничение: правая граница imageView равна правой границе contentView.
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // Ограничение: нижняя граница imageView равна нижней границе contentView.
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCups(cup: UIImage){
        ///предназначен для обновления изображения в imageView ячейки.
        /////Он принимает изображение типа UIImage и устанавливает его в imageView.
        ///// Это может использоваться для обновления содержимого ячейки с новым изображением.
        imageView.image = cup
    }
}



