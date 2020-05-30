//
//  LabelViewController.swift
//  iOS_Clock_App
//
//  Created by Naoki Mita on 2020-05-30.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit

class LabelViewController: UIViewController, UITextFieldDelegate {
    
    private let padding: CGFloat = 16
    var inputText: String!
    var textInputDone: ((String) -> ())?
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .line
        tf.becomeFirstResponder()
        tf.returnKeyType = UIReturnKeyType.done
        tf.enablesReturnKeyAutomatically = true
        tf.clearButtonMode = .always
        tf.clearButtonMode = .whileEditing
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textField)
        view.backgroundColor = .white
        title = "Label"
        textField.text = inputText
        textField.constraintWidth(equalToConstant: view.frame.width - padding * 2)
        textField.centerXYin(view)
        
        self.textField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textInputDone?(textField.text!)
        self.navigationController?.popViewController(animated: true)
        return true
    }
}
