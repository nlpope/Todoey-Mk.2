//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

//reading up on computational thinking by Jeannette M. Wing

import UIKit
import CoreData

//UITableViewController by default conforms to UITableViewDatasource & ..Delegate
//..conforms = no UITab....Source...Delegate calls needed but must still be defined 
class ToDoListViewController: UITableViewController {
    
    //REMEMBER: YOU CAN'T SAVE AN ARRAY OF CUSTOM OBJECTS TO USER DEFAULTS. UDs ONLY STORES SMALL NS TYPES
    var itemArray = [Item]()
    
    var selectedCategory: Category?
    
    //CORE DATA STEP 2
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        loadItems()
        
        
    }
    
    //MARK: - TableView DataSource Methods
    //^ auto-conforms = no UITab....Source...Delegate calls needed but must still be defined in ext
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
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //SWIFT'S NEW TOGGLE FEATURE
        itemArray[indexPath.row].done.toggle()
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //when deleting elements, make sure you delete the reference AND it's equiv in the context
            context.delete(itemArray[indexPath.row])
            //remove the reference to the NSManagedObject
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveItems()
        }
    }
    
    
    //MARK: - MODEL MANIPULATION METHODS
    //CRUD: CREATE
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //TAKE OUT ACTION, SEE WHAT HAPPENS 
        let action = UIAlertAction(title: "Add Item", style: .default) { (_) in
            
            //CORE DATA STEP 3
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            self.saveItems()
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
    
    func saveItems() {

        do {
            //CORE DATA STEP 4 - FINAL
           try context.save()
        } catch {
            print("error saving context \(error)")
        }
        
        //took "self." out
        tableView.reloadData()
    }
    
    //CRUD: READ
    //when using core data, Item auto has .fetchRequest() built in,
    //so Item.fetchRequest() returns all Items in the array w/out a predicate/filter
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        //try? = we don't need an error message back from the func that throws
        //try = we need an error message back from the func that throws - must be wrapped in do{} catch{}
      
        do {
          itemArray = try context.fetch(request)
        } catch {
            print("error fetching items: \(error)")
        }
        
        tableView.reloadData()
      
    }
    
}


extension ToDoListViewController: UISearchBarDelegate  {
    
    //MARK: SEARCHBAR METHODS
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //below returns an array of Items (<Item>) - needs a predicate (search filter) and sort descriptors
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //NSPredicate = which properties to filter by
        // %@ = "whatever is past the comma after this value will replace it
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
                
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                
        loadItems(with: request)
        
        if searchText.isEmpty {
            loadItems()
            
            //after the function "textDidChange" exits, the below is triggered
            //because you cannot resign first resp. until searchBar is finished talking to you from this func
            //resulting in the keyboard flashing back in after it was resigned for "textDidChange" being triggered on clear
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
//            searchBar.resignFirstResponder()

        }
        
    }
}


/**
 HELPFUL RESOURCES:
 
 if let unwrapping
 https://www.programiz.com/swift-programming/optionals#:~:text=Example%205%3A%20Optional%20handling%20using%20if%20let%20statement&text=The%20if%2Dlet%20statement%20also,an%20optional%20contains%20a%20value.
 
 
 */
