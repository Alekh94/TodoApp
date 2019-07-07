//
//  ViewController.swift
//  TodoApp
//
//  Created by Macbook Air on 2019-03-24.
//  Copyright © 2019 Alekh Singh. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
  var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        // Vi behöver ladda upp data som sparades sist med hjälp av funktionen som vi skapat
        
    loadItems()
        
    }

    // MARK: - TableView Datasource Methods
    
    
    // Denna method säger hur många celler ska va med i tabellen
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // Denna method säger vad som skall stå i cellerna
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
        //ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        //Om Item Done == true då ska checkmark läggas till annars inte
        
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
      
        return cell
    }

    
    //MARK: - TableView Delegate Methods
    
    
    // Vad ska hända när man trycker på respeketive rad?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }} catch {
                    print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    //MARK: - ADD new items
    //Vi skapade knappen med hjälp av UIBarButton i Main Storyboard.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Skapar en variabel för att sedan kunna använda data från en closure
        var textField = UITextField()
        
        //Skapar en pop up där det står Add new Todo med hjälp av UIalertController
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        
        //Skapar en actionknapp som heter Add Item med hjälp av UIAlertAction
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        // En closure --> lägger till en textfield till alert (konstanten som innehåler pop up)
        //placeholder gör att det finns en grå text som försvinner sedan när man trycker på fältet
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        //Det här händer när man trycker på knappen
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manupulation Methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}
//MARK: - Seach Bar methods

extension ToDoViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

    }

    //Gå tillbaka till orginal listan

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }

        }
    }

}
