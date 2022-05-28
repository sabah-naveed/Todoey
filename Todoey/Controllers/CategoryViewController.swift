//  Sabah Naveed
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Sabah Naveed on 1/16/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
    
    //MARK: Initialize
    
    let realm = try! Realm()
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetUp()
        
        loadCategories()
        
        tableView.separatorStyle = .none
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("nav bar does not exist")}
        navBar.backgroundColor = UIColor.purple
    }

   
    //MARK: - TV DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
        //^nil coalescing operator "if CA is not nil return the count if it is return 1"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categoryArray?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "no categories added yet :("
        
        //cell.backgroundColor = UIColor.randomFlat().hexValue()
        cell.backgroundColor = UIColor(hexString: category?.color ?? "FFFF00")
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category?.color ?? "FFF000") ?? UIColor.yellow, returnFlat: true)
        
        cell.frame = cell.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

        return cell
    }
    

    //MARK: - TV Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
         
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation
    func saveCategories(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving categories \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        categoryArray = realm.objects(Category.self)

    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categoryArray?[indexPath.row] {
            do {
                try realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("error removing cell \(error)")
            }
        }
    }
    
    
    //MARK: - Add category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Todoey category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { action in
            //what will happen once the user clicks add item on the UIAlert
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.saveCategories(category: newCategory)
        }
        
        alert.addTextField { alertTextField in
            //only called when the alert pops up
            
            alertTextField.placeholder = "Type a category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    //MARK: - View Setup
    func viewSetUp() {
        //fixing navigation bar tint
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemPurple
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
}

