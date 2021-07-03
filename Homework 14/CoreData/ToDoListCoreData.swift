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
    
    var taskEntities = [TaskEntity]() //
    var cellId = "CoreDataCustomCell" // Идентификатор ячейки
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }()
    
    //MARK: - Override Methods
    override func viewWillDisappear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext() //Сохраняем в CoreData
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
    
   
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskEntities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let item = taskEntities[indexPath.row]
        cell.textLabel?.text = item.task
        cell.accessoryType = item.isChecked ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _,_ in
            let currentTaskEntity = self.taskEntities[indexPath.row]
            self.context.delete(currentTaskEntity)
            self.taskEntities.remove(at: indexPath.row)
            tableView.reloadData()
        }
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") { [weak self] (action, view, completionHandler) in
            completionHandler(true)
            
            let alert = UIAlertController(title: "Edit Task", message: "Please fill in the field", preferredStyle: .alert)
            // Создание текстового поля
            var alertTextField: UITextField!
            alert.addTextField { textField in
                alertTextField = textField
                textField.placeholder = "New Task"
            }
            let saveAction = UIAlertAction(title: "Save", style: .default) { [self] action in
                // Проверяем не является ли текстовое поле пустым
                guard alertTextField.text?.isEmpty == false else {
                    print("The text field is empty") // Выводим сообщение на консоль, если поле не заполнено
                    return
                }
                // Изменяем в массив новую задачу из текстового поля
                let currrentText = self!.taskEntities[indexPath.row]
                currrentText.task = alert.textFields?.first?.text ?? ""
             
                // Обновляем таблицу
                self?.tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alert.addAction(saveAction) // Присваиваем алёрту кнопку для сохранения результата
            alert.addAction(cancelAction) // Присваиваем алерту кнопку для отмены ввода новой задачи
            self?.present(alert, animated: true, completion: nil) // Вызываем алёрт контроллер
            tableView.reloadData()
        }
        
        action.backgroundColor = .systemBlue
        self.tableView.reloadData()

        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTaskEntity = taskEntities[indexPath.row]
        selectedTaskEntity.isChecked.toggle()
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = selectedTaskEntity.isChecked ? .checkmark : .none
    }
    
    //MARK: - Private methods
    private func fetchTask() {
        
        if let entities = try? TaskEntity.getAll(context: context) {
            taskEntities = entities
        }
        tableView.reloadData()
    }
    
    private func addAlertForNewItem() {
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
            
            let inputText = alert.textFields?.first?.text ?? ""
            let newTaskEntity = TaskEntity.createObjects(task: inputText, context: self.context) // объект в базе данных
            self.taskEntities.append(newTaskEntity)
            
            // Обновляем таблицу
            self.tableView.reloadData()
        }
        // Создаем кнопку для отмены ввода новой задачи
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(saveAction) // Присваиваем алёрту кнопку для сохранения результата
        alert.addAction(cancelAction) // Присваиваем алерту кнопку для отмены ввода новой задачи
        
        present(alert, animated: true, completion: nil) // Вызываем алёрт контроллер
    }
}
