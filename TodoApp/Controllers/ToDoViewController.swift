//
//  ViewController.swift
//  TodoApp
//
//  Created by Macbook Air on 2019-03-24.
//  Copyright © 2019 Alekh Singh. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
   
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        // Vi behöver ladda upp data som sparades sist med hjälp av funktionen som vi skapat
        
    loadItems()
        
    }

    // MARK: - TableView Datasource Methods
    
    
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

    
    //MARK: - TableView Delegate Methods
    
    
    // Vad ska hända när man trycker på respeketive rad?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        
        // För att ta bort en Item! Ta alltid bort från context innan man tar bort från listan
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        //denna mening ersätter if satsen. Koden sätter done property för den valda raden till den motsatta med hjälp av not operatorn !
         itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        // Så att det inte ser ut att en rad är markerad hela tiden
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
            // What will happen once the user click on the add item button on our UIAlert
            
            //Lägga till texten från closure nedan i itemArray som sedan ser till att synliggöra det

            //mha (UIApplication.shared.delegate as! AppDelegate) kan vi kma åt AppDelegate. Här korrigerar vi i staging-area (context)
            
           
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
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
    
    //MARK: - Model Manupulation Methods
    //Här sparar vi contexten
    func saveItems() {
        
        do {
            
        try context.save()
         
        } catch {
            print("Error saving context \(error)")
        }
        // Uppdaterar tabellenviewen och därmed synliggörs det man skrev in i raden ovan
        self.tableView.reloadData()
        }
        
    
    //Här laddar vi från databasen. Defaultvärdet är att vi laddar upp "Items" men vi kan även lägga in i en input för att använda denna funktion i sökbaren
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        
        do {
          itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}
//MARK: - Seach Bar methods

extension ToDoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
       
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
       request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)

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
