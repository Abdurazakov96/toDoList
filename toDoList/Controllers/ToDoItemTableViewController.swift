//
//  ToDoItemTableViewController.swift
//  toDoList
//
//  Created by Магомед Абдуразаков on 27/08/2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import UIKit

class ToDoItemTableViewController: UITableViewController {
    var todo = ToDo()
    var bool = false
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return todo.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let value = todo.values[section]
        
        return value is Date ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let value = todo.values[section]
        let cell = getCellFor(indexpath: indexPath, with: value!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let value = todo.values[indexPath.section]
        if let cell = tableView.cellForRow(at: indexPath) {
            return  cell.isHidden ? 0 : UITableView.automaticDimension
        } else {
            return value is Date && indexPath.row == 1 ? 0 : UITableView.automaticDimension
            
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = todo.capitalezedKeys[section]
        return title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let value = todo.values[indexPath.section]
        
        if value is Date {
            let indexPath = IndexPath(row: 1, section: indexPath.section)
            let labelIndexPath = IndexPath(row: 0, section: indexPath.section)
            let cell = tableView.cellForRow(at: indexPath)
            let labelCell = tableView.cellForRow(at: labelIndexPath)
                       tableView.reloadRows(at: [labelIndexPath], with: .automatic)
            cell?.isHidden = bool
            bool.toggle()
            
            tableView.reloadRows(at: [indexPath], with: .automatic)

        }
            
        else if value is UIImage {
            let alert = UIAlertController(title: "Choose source", message: nil, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancel)
            
            let imagePicker = SectionImagePicker()
            imagePicker.delegate = self
            imagePicker.section = indexPath.section
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let camera = UIAlertAction(title: "Camera", style: .default) {action in
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true)
                }
                alert.addAction(camera)
                
            }
            
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let photoLibrary = UIAlertAction(title: "PhotoLibrary", style: .default) { action in
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true)
                    
                }
                alert.addAction(photoLibrary)
            }
            present(alert, animated: true)
        }
    }
    
    
    func getCellFor(indexpath: IndexPath, with value: Any) -> UITableViewCell {
        
        if let stringValue = value as? String {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexpath) as! TextFieldCell
            cell.textfield?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            cell.textfield?.section = indexpath.section
            cell.textfield!.text = stringValue.capitalizedWithSpaces
            return cell
            
        }
            
        else if let dateValue = value as? Date {
            
            switch indexpath.row {
                
            case 0: let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexpath) as! DateCell
            cell.label.text = dateValue.formattedDate
            
            
            return cell
                
            case 1: let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell", for: indexpath) as! DatePickerCell
            
            cell.datePicker.minimumDate = Date()
            cell.datePicker.section = indexpath.section
            cell.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
            cell.datePicker.date = dateValue
            
            return cell
            default:
                fatalError("Error")
            }
            
        }
            //
        else if let boolValue = value as? Bool {
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexpath) as! SwitchCell
            
            cell.switch.isOn = boolValue
            cell.switch.section = indexpath.section
            cell.switch?.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            return cell
        }
        else if let imageValue = value as? UIImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexpath) as! ImageCell
            cell.imageCell.image = imageValue
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexpath) as! TextFieldCell
            cell.textfield!.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .editingChanged)
            cell.textfield!.text = ""
            cell.textfield?.section = indexpath.section
            return cell
        }
        
        
        
    }
    
    
    
    
}

extension ToDoItemTableViewController {
    @objc func textFieldValueChanged(_ sender: SectionTextField){
        let key = todo.keys[sender.section]
        let text = sender.text ?? ""
        todo.setValue(text, forKey: key)
    }
    
    @objc func datePickerValueChanged(_ sender: SectionDatePicker){
        let key = todo.keys[sender.section]
        let value = sender.date
        todo.setValue(value, forKey: key)
    }
    
    @objc func switchValueChanged(_ sender: SectionSwitch){
        let key = todo.keys[sender.section]
        let value = sender.isOn
        todo.setValue(value, forKey: key)
    }
    
}

extension ToDoItemTableViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {return}
        guard let sectionPicker = picker as? SectionImagePicker else {return}
        guard let section = sectionPicker.section else {return}
        
        let key = todo.keys[section]
        todo.setValue(image, forKey: key)
        
        let indexPath = IndexPath(row: 0, section: section)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        
    }
}
extension ToDoItemTableViewController: UINavigationControllerDelegate{}
