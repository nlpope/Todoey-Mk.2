//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

//reviewing/practicing singletons via playgrounds

import UIKit

//UITableViewController by default conforms to UITableViewDatasource & ..Delegate
//..conforms = no UITab....Source...Delegate calls needed but must still be defined in ext
class ToDoListViewController: UITableViewController {
    
    //REMEMBER: YOU CAN'T SAVE AN ARRAY OF CUSTOM OBJECTS TO USER DEFAULTS. UDs ONLY STORES NS TYPES
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //replaces User Defaults
        
        
        print(dataFilePath)
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Destroy demogorgan"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Save the world"
        itemArray.append(newItem3)
        
                
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        //set the global itemArray variable to the user defaults
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
    }
}

//MARK: DATASOURCE AND DELEGATE METHODS
extension ToDoListViewController  {
    //MARK: TableView DataSource Methods
    //..conforms = no UITab....Source...Delegate calls needed but must still be defined in ext
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //handle checkmarks here (in one place) and just RELOAD the data in the delegat DIDSELECTROWAT
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        //below status check handles re-used cells' repeating check mark problem
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //below was inefficient, could be handling in one place while I reload here
        //let cell = tableView.cellForRow(at: indexPath)
        //tableView.cellForRow(at: indexPath)?.accessoryType = cell?.accessoryType != .checkmark ? .checkmark : .none

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add New items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //create a pop up (UIAlertController)
        //have an editable text field in that UIAlert
        //on submission append the new item to the end of the itemArray
        // display/present the pop up
        
        //how do i live monitor a UIAlertController's textfield ?
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            let encoder = PropertyListEncoder()
            //encoder encodes our item array data into a property list
            do {
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            } catch {
                print("error encoding array: \(error)")
                
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField(configurationHandler: { alertTextField in

            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            //UITextFields contain a delegate that auto checks for changes in field
            //im assuming, after every keystroke a snapshot is taken by said delegate
        })
        
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
}

