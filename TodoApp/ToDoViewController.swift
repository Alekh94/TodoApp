//
//  ViewController.swift
//  TodoApp
//
//  Created by Macbook Air on 2019-03-24.
//  Copyright © 2019 Alekh Singh. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArray = ["Shoppa", "Uppgifter", "Gärningar"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK - TableView Datasource Methods
    
    
    // Denna method säger hur många celler ska va med i tabellen
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Denna method säger vad som skall stå i cellerna
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }

    
    //MARK - TableView Delegate Methods
    
    
    // Vad ska hända när man trycker på respeketive rad?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        
        // om en rad redan har checkmark, vi läggre en if sats för att bort den annars lägger vi till en checkmark för den valda raden
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none }
        else {  tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            self.itemArray.append(textField.text!)
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

