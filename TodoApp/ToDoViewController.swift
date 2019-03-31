//
//  ViewController.swift
//  TodoApp
//
//  Created by Macbook Air on 2019-03-24.
//  Copyright © 2019 Alekh Singh. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    let itemArray = ["Shoppa", "Uppgifter", "Gärningar"]

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
}

