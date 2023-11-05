
//
//  TaskViewController.swift
//  PlaneIt-ToDo-Code
//
//  Created by Влад on 3.11.23.
//

import UIKit

class TaskViewController : UIViewController {
    
    let nameLabel = UITextField()
    let descriptionTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let navBar = UINavigationBar()
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let navItem = UINavigationItem(title: "")
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor(hex: "ACF478")
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain , target: self, action: #selector(saveButtonTapped))
        saveButton.tintColor = UIColor(hex: "ACF478")
        
        navItem.leftBarButtonItem = backButton
        navItem.rightBarButtonItem = saveButton
        navBar.setItems([navItem], animated: false)
        
        
        nameLabel.text = " Name"
        nameLabel.textColor = .gray
        nameLabel.backgroundColor = UIColor(hex: "333E49")
        view.addSubview(nameLabel)
        nameLabel.autocapitalizationType = .words
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -180).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameLabel.layer.cornerRadius = 21
        
        
        
        

        
        descriptionTextView.text = " Desccription"
        descriptionTextView.font = .systemFont(ofSize: 20)
        descriptionTextView.autocapitalizationType = .words
        descriptionTextView.textColor = .white
        descriptionTextView.backgroundColor = UIColor(hex: "5B5B5B")
        view.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        descriptionTextView.layer.cornerRadius = 20
        descriptionTextView.layer.masksToBounds = true
        
        
    
        
        navBar.backgroundColor = UIColor(hex: "28313A")
        view.backgroundColor = UIColor(hex: "333E49")
        navigationController?.pushViewController(self, animated: true)
}
    
    
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
      
    }

}
