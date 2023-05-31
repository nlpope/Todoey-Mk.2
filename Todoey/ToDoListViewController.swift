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
    
//    var completed: Bool = false
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        //set the global itemArray variable to the user defaults
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
        
    }
}


extension ToDoListViewController  {
    //MARK: TableView DataSource Methods
    //..conforms = no UITab....Source...Delegate calls needed but must still be defined in ext
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        let cell = tableView.cellForRow(at: indexPath)
        tableView.cellForRow(at: indexPath)?.accessoryType = cell?.accessoryType != .checkmark ? .checkmark : .none

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
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
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

