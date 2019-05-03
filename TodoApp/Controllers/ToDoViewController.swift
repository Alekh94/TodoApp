//
//  ViewController.swift
//  TodoApp
//
//  Created by Macbook Air on 2019-03-24.
//  Copyright © 2019 Alekh Singh. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        let newItem = Item()
        newItem.title = "Köpa"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Gärningar"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Uppgifter"
        itemArray.append(newItem3)
        
        
        
        // Om det finns en array med key "" då items får det värdet och vidare får ItemArray det värdet --> Data sparas även om appen stängs ned! :)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
        
    }

    // MARK - TableView Datasource Methods
    
    
    // Denna method säger hur många celler ska va med i tabellen
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Denna method säger vad som skall stå i cellerna
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        //Om Item Done == true då ska checkmark läggas till annars inte
        
        cell.accessoryType = item.done == true ? .checkmark : .none
      
        return cell
    }

    
    //MARK - TableView Delegate Methods
    
    
    // Vad ska hända när man trycker på respeketive rad?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        
        // om en rad redan har checkmark, vi läggre en if sats för att bort den annars lägger vi till en checkmark för den valda raden
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        //denna mening ersätter if satsen ovan. Koden sätter done property för den valda raden till den motsatta med hjälp av not operatorn ! 
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        //denna metod gör att alla tableview methods uppdaterar varje gång man väljer en rad
        tableView.reloadData()
        
        // Så att det inte ser ut att en rad är markerad hela tiden
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    //MARK - ADD new items
    //Vi skapade knappen med hjälp av UIBarButton i Main Storyboard.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Skapar en variabel för att sedan kunna använda data från en closure
        var textField = UITextField()
        
        //Skapar en pop up där det står Add new Todo med hjälp av UIalertController
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        
        //Skapar en actionknapp som heter Add Item med hjälp av UIAlertAction
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user click on the add item button on our UIAlert
            
            //Lägga till texten från closure nedan i itemArray som sedan ser till att synliggöra det
           
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            //Sparar data i defaults. Set(value:any, forKey: String) --> sparas ned i en p-list
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // Uppdaterar tabellenviewen och därmed synliggörs det man skrev in i raden ovan
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
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

