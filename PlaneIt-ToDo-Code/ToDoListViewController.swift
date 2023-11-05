//
//  ViewController.swift
//  PlaneIt-ToDo-Code
//
//  Created by Влад on 1.11.23.
//

import UIKit

class ToDoListViewController: UIViewController {
    
    let task = ["down app","generate gif","buy beer"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        imageView.image = UIImage(named: "testImg")
        view.addSubview(imageView)
        
    
    }
    
    
}

