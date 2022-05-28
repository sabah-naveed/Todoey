//  Sabah Naveed
//  ViewController.swift
//  Todoey

import UIKit
import RealmSwift
import ChameleonFramework
import SwiftUI

class TodoListViewController: SwipeTableViewController {
    // MARK: Initialize
    
    //array of items:
    
    let realm = try! Realm()
    var todoItems : Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //viewSetUp()
        loadItems()
        
        tableView.separatorStyle = .none
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    
    // MARK: - TV DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //needs to know how many rows in table view
    
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //the cell that should be displayed at each row, gets called as many times as there are cells
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            //ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "no items added :("
        }
        
        
        return cell
    }
    
    
    // MARK: - TV Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //when a cell is selected
        
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error changing done property \(error)")
            }
        }
        tableView.reloadData()
                
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        //when the add button is pressed
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            //what will happen once the user clicks add item on the UIAlert
            
            
            if let parent = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        parent.items.append(newItem)
                    }
                } catch {
                    print("error saving items \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            //only called when the alert pops up
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Model Manipulation Methods
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("error removing cell \(error)")
            }
        }
    }
    
    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        //fixing navigation bar tint
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(hexString: selectedCategory?.color ?? "000000")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        guard let navBar = navigationController?.navigationBar else {fatalError("nav bar does not exist")}
        navBar.tintColor = ContrastColorOf(UIColor(hexString: selectedCategory?.color ?? "000000") ?? UIColor.white, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(UIColor(hexString: selectedCategory?.color ?? "000000") ?? UIColor.yellow, returnFlat: true)]
        
        title = selectedCategory?.name
        searchBar.barTintColor = UIColor(hexString: selectedCategory?.color ?? "000000")
        
    }
    
    
    
}


// MARK: - Search Bar Methods
//extensions are commonly used to separate out delegate protocols
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //create a query to the database
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder() //resigns keyboard
            }

        }
    }

}


