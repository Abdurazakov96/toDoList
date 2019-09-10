//
//  ToDoTableViewController.swift
//  toDoList
//
//  Created by Магомед Абдуразаков on 27/08/2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    var todos = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todos = [
            ToDo(title: "Сделать дз по Swift", note: " ", image: UIImage(named: "swift")),
            ToDo(title: "Посмотреть англоязычный фильм с субтитрами", note: " ", image: UIImage(named: "cinema")),
            ToDo(title: "Погладить рубашку", note: " ", image: UIImage(named: "ironing"))]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ToDoTableViewCell
        let toDo = todos[indexPath.row]
        configure(cell: cell, todo: toDo)
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "segueItem" else {return}
        guard let selectedIndex = tableView.indexPathForSelectedRow else {return}
        let destination = segue.destination as! ToDoItemTableViewController
        destination.todo = todos[selectedIndex.row].copy() as! ToDo 
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else {return}
        guard let selectedIndex = tableView.indexPathForSelectedRow else {return}
        let source = segue.source as! ToDoItemTableViewController
        todos[selectedIndex.row] = source.todo
        
        if let toDoCell = tableView.cellForRow(at: selectedIndex) as? ToDoTableViewCell {
            if let stackView = toDoCell.stackView {
                stackView.arrangedSubviews.forEach {subview in
                    stackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
            }
        } 
        
        tableView.reloadRows(at: [selectedIndex], with: .automatic)
    }
    
    
    func configure(cell: ToDoTableViewCell,todo: ToDo) {
        
        guard let stackView = cell.stackView else {return}
        guard stackView.arrangedSubviews.count == 0 else {return}
        
        for index in 0 ..< todo.keys.count {
            
            let key = todo.capitalezedKeys[index]
            let value = todo.values[index]
            
            if let stringValue = value as? String {
                let label = UILabel()
                let text = "\(key): \(stringValue.capitalizedWithSpaces)"
                label.text = text
                stackView.addArrangedSubview(label)
                
            }
                
            else if let dateValue = value as? Date {
                let label = UILabel()
                let text = "\(key): \(dateValue.formattedDate)"
                label.text = text
                stackView.addArrangedSubview(label)
                
            }
                
            else if let boolValue = value as? Bool {
                let label = UILabel()
                let text = "\(key): \(boolValue ? "✅" : "❌")"
                label.text = text
                stackView.addArrangedSubview(label)
            }
                
            else if let imageValue = value as? UIImage {
                let image = UIImageView(image: imageValue)
                image.contentMode = .scaleAspectFit
                
                let height = NSLayoutConstraint(
                    item: image,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .height,
                    multiplier: 1,
                    constant: 200)
                image.addConstraint(height)
                stackView.addArrangedSubview(image)
            }
        }
    }
}

