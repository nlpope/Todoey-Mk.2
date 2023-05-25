//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

//UITableViewController by default conforms to UITableViewDatasource & ..Delegate
//..conforms = no UITab....Source...Delegate calls needed but must still be defined in ext
class ToDoListViewController: UITableViewController {
    
    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
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
        var textFieldText: String?
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            print("Success to the console!")
            
        }
        
        alert.addTextField(configurationHandler: { alertTextField in

            alertTextField.placeholder = "Create new item"
            print("textfield updated")

        })
        
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
}

