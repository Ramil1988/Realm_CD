//
//  ToDoListTableViewController.swift
//  Homework 14
//
//  Created by Ramil Sharapov on 15.06.2021.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    
    var cellId = "customCell" // Идентификатор ячейки
    let realm = RealmManager().realm// Доступ к хранилищу
    var items = RealmManager().items

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Цвет заливки вью контроллера
        view.backgroundColor = .white
        
        // Цвет навигейшин бара
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 21/255,
                                                                   green: 101/255,
                                                                   blue: 192/255,
                                                                   alpha: 1)
        // Цвет текста для кнопки
        navigationController?.navigationBar.tintColor = .white
        
        // Добавляем кнопку "Добавить" в навигейшин бар
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addItem)) // Вызов метода для кнопки
        
        // Присваиваем ячейку для TableView с идентифиактором "Cell"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        items = realm.objects(TaskObject.self)
    }
    
    // Действие при нажатии на кнопку "Добавить"
    @objc func addItem(_ sender: AnyObject) {
        addAlertForNewItem()
    }
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items?.count != 0 {
            return items!.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let item = items?[indexPath.row]
        cell.textLabel?.text = item?.taskText
        cell.accessoryType = item!.isChecked ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") { [weak self] (action, view, completionHandler) in
            completionHandler(true)
            
            let alert = UIAlertController(title: "New Task", message: "Please fill in the field", preferredStyle: .alert)
            
            // Создание текстового поля
            var alertTextField: UITextField!
            alert.addTextField { textField in
                alertTextField = textField
                textField.placeholder = "New Task"
            }
            // Создание кнопки для сохранения новых значений
            let saveAction = UIAlertAction(title: "Save", style: .default) { action in
                let editingRow = self?.items?[indexPath.row]
    
                try! self?.realm.write {
                    editingRow?.taskText = alertTextField.text ?? "Print text!"
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        
            // Создаем кнопку для отмены ввода новой задачи
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            alert.addAction(saveAction) // Присваиваем алёрту кнопку для сохранения результата
            alert.addAction(cancelAction) // Присваиваем алерут кнопку для отмены ввода новой задачи
            
            self!.present(alert, animated: true, completion: nil) // Вызываем алёрт контроллер
        }
        
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
            completionHandler(true)
            let editingRow = self!.items![indexPath.row]
            try! self!.realm.write {
                self!.realm.delete(editingRow)
                tableView.reloadData()
            }
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items?[indexPath.row]
        try! self.realm.write({
            item?.isChecked = !item!.isChecked
        })
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    //MARK: - Public methods
    func addAlertForNewItem() {
        // Создание алёрт контроллера
        let alert = UIAlertController(title: "New Task", message: "Please fill in the field", preferredStyle: .alert)
        
        // Создание текстового поля
        var alertTextField: UITextField!
        alert.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "New Task"
        }
        
        // Создание кнопки для сохранения новых значений
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            
            // Проверяем не является ли текстовое поле пустым
            guard let text = alertTextField.text, !text.isEmpty else { return print("The text field is empty")}
            let task = TaskObject()
            task.taskText = text
            
            try! self.realm.write {
                self.realm.add(task)
            }
            // Обновление таблицы
            self.tableView.insertRows(at: [IndexPath.init(row: self.items!.count-1, section: 0)], with: .automatic)
        }
        
        // Создаем кнопку для отмены ввода новой задачи
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(saveAction) // Присваиваем алёрту кнопку для сохранения результата
        alert.addAction(cancelAction) // Присваиваем алерут кнопку для отмены ввода новой задачи
        present(alert, animated: true, completion: nil) // Вызываем алёрт контроллер
    }

}
