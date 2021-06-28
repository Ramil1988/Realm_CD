//
//  ViewController.swift
//  Homework 14
//
//  Created by Ramil Sharapov on 13.06.2021.
//

import UIKit

class UserModel: NSObject { // настройка модели данных
    var name: String
    var surmame: String
    
    init(name: String, surname: String) {
        self.name = name
        self.surmame = surname
    }
}

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var surnameTxt: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
        nameTxt.delegate = self
        surnameTxt.delegate = self
        
        addLine(textField: nameTxt)
        addLine(textField: surnameTxt)
        
        nameTxt.text = UserSettings.userName // сохраняем предыдущее имя в TXT
        surnameTxt.text = UserSettings.userSurname

    }

    @IBAction func name() {
        print(nameTxt.text ?? "nil")
    }
    
    @IBAction func surname() {
        print(surnameTxt.text ?? "nil")
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {

        UserSettings.userName = nameTxt.text
        UserSettings.userSurname = surnameTxt.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTxt {
            self.nameTxt.resignFirstResponder()
        }
        
        if textField == surnameTxt {
            self.surnameTxt.resignFirstResponder()
        }
        return true
    }
    
    func addLine(textField: UITextField) {
        let myLine = CALayer()
        myLine.frame = CGRect(x: 0.0, y: textField.frame.height + 5.0, width: textField.frame.width, height: 1.0)
        myLine.backgroundColor = UIColor.gray.cgColor
        textField.layer.addSublayer(myLine)
    }
}



//    func encode(with coder: NSCoder) {
//        coder.encode(name, forKey: "name")
//        coder.encode(name, forKey: "surname")
//    }
//
//    required init?(coder: NSCoder) {
//        name = coder.decodeObject(forKey: "name") as? String ?? ""
//        surmame = coder.decodeObject(forKey: "surname") as? String ?? ""
//    }
