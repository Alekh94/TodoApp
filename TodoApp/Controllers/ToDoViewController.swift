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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        print(dataFilePath)
        
        
        // Vi behöver ladda upp data som sparades sist med hjälp av funktionen som vi skapat
        
loadItems()
        
        
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
        
        
        
        //denna mening ersätter if satsen. Koden sätter done property för den valda raden till den motsatta med hjälp av not operatorn !
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
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
            
            //Spara data i den nyskapade p-list med hjäp av encoder och dataFilePath
            self.saveItems()
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
    
    //MARK - Model Manupulation Methods
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        
        // Uppdaterar tabellenviewen och därmed synliggörs det man skrev in i raden ovan
        self.tableView.reloadData()
        }
        
    
    func loadItems() {
       if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
                
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
    
    
}

