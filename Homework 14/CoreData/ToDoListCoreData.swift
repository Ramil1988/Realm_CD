//
//  ToDoListCoreData.swift
//  Homework 14
//
//  Created by Ramil Sharapov on 17.06.2021.
//

import Foundation
import UIKit
import CoreData

class ToDoListCoreData: UITableViewController {
    
    var itemsArray = [""] // Массив для хранения записей
    var taskEntities = [TaskEntity]() //
    var cellId = "Cell" // Идентификатор ячейки
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTask()
        
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
        
        // Присваиваем ячейку для TableView с иднетифиактором "Cell"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    // Действие при нажатии на кнопку "Добавить"
    @objc func addItem(_ sender: AnyObject) {
        addAlertForNewItem()
    }
    
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
            guard alertTextField.text?.isEmpty == false else {
                print("The text field is empty") // Выводим сообщение на консоль, если поле не заполнено
                return
            }
            
            // Добавляем в массив новую задачу из текстового поля
            self.itemsArray.append((alert.textFields?.first?.text)!)
            
            // Сохраняем в CoreData
            let text = alertTextField.text!
            let task = TaskEntity.createObjects(task: text, isChecked: false, context: self.context)
            
            // Обновляем таблицу
            self.tableView.reloadData()
        }
        
        // Создаем кнопку для отмены ввода новой задачи
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(saveAction) // Присваиваем алёрту кнопку для сохранения результата
        alert.addAction(cancelAction) // Присваиваем алерту кнопку для отмены ввода новой задачи
        
        present(alert, animated: true, completion: nil) // Вызываем алёрт контроллер
    }
    
    //MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let item = itemsArray[indexPath.row]
        cell.textLabel?.text = item
       
        
        return cell
    }
    
    //MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _,_ in
            self.itemsArray.remove(at: indexPath.row)
            let currentTaskEntity = self.taskEntities[indexPath.row]
            self.context.delete(currentTaskEntity)
            
            tableView.reloadData()
        }
        
        return [deleteAction]
    }
    
    private func fetchTask() {
        
        if let entities = try? TaskEntity.getAll(context: context) {
            itemsArray = entities.compactMap { $0.task } // добавляет в массив значения (tasks), которые не являются nil
            taskEntities = entities
        }
        
        tableView.reloadData()
        
    }
}
