//
//  ListViewController.swift
//  CoreDataDemo
//
//  Created by Mazharul Huq on 2/16/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    var coreDataStack = CoreDataStack(modelName: "PersonList")
    var managedContext:NSManagedObjectContext!
    var persons:[Person] = []
    
    lazy var fetchedResultsController:NSFetchedResultsController<Person> = {
        //1 Creating fetch request and adding sort descriptor
        let fetchRequest:NSFetchRequest<Person> = Person.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Person.lastName), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        //2 Creating an instance of NSFetchedResultsController
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        //3 Assigning delegate
        frc.delegate = self
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.managedContext = self.fetchedResultsController.managedObjectContext
        do{
            try self.fetchedResultsController.performFetch()
        }
        catch{
            let fetchError = error as NSError
            print("Unable to fetch \(fetchError),(fetchError.userInfo)")
        }
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = self.fetchedResultsController.sections else{
            return 0
        }
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else
        {
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let person = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = person.lastName
        var firstName = ""
        if let name = person.firstName{
            firstName = name
        }
        var dobString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        if let date = person.dateOfBirth{
            dobString = "  DOB: \(dateFormatter.string(from: date as Date))"
        }
        cell.detailTextLabel?.text = firstName + dobString

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = self.fetchedResultsController.object(at: indexPath)
            self.managedContext.delete(person)
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print("Could not save \(error),\(error.userInfo)")
            }
        }
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let vc = segue.destination as! EditViewController
         vc.managedContext = self.managedContext
         if segue.identifier == "editSegue"{
             vc.titleString = "Update Person"
             if let indexPath = self.tableView.indexPathForSelectedRow{
                 vc.person = fetchedResultsController.object(at: indexPath)
            }
         }
         else{
            vc.titleString = "Insert Person"
        }
    }
}

// MARK: -NSFetchedRecordsController delegate methods

extension ListViewController:NSFetchedResultsControllerDelegate{
    
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
