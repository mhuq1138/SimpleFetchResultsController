//
//  EditViewController.swift
//  CoreDataDemo
//
//  Created by Mazharul Huq on 2/16/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController {

    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var dobField: UITextField!
    
    var titleString = ""
    var dateFormatter:DateFormatter!
    var managedContext:NSManagedObjectContext!
    var person:Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        self.firstNameField.text = person?.firstName
        self.lastNameField.text = person?.lastName
        if let dob = person?.dateOfBirth as Date?{
            self.dobField.text = dateFormatter.string(from: dob)
        }
    }

    
    @IBAction func saveTapped(_ sender: Any) {
        
        if self.person == nil {
            self.person = Person(context: self.managedContext)
        }
        
        person?.firstName = self.firstNameField.text
        person?.lastName = self.lastNameField.text
        person?.dateOfBirth = dateFormatter.date(from: dobField.text!) as NSDate?
        
        //Save changes to the context
        if self.managedContext.hasChanges {
            do {
                try self.managedContext.save()
            }
            catch {
                let nserror = error as NSError
                print("Could not save \(nserror),(nserror.userInfo)")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
