//
//  ViewController.swift
//  Database Project
//
//  Created by Joey deVilla on 1/29/19.
//  Copyright © 2019 Joey deVilla. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {

  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var personTextView: UITextView!

  // NSManagedObject is a Core Data class that represents
  // a single object stored in Core Data.
  // Think of it as a “box” that can hold any entity inside
  // a Core Data model that you need to use in order to
  // create, read, update, and delete entities from
  // the data store.
  // We’ll use people -- an array of NSManagedObjects --
  // to hold the Person entities that we retrieve
  // from the data store.
  var people: [NSManagedObject] = []


  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func getManagedContext() -> NSManagedObjectContext? {
    // In order to save or retrieve data from a Core Data
    // data store, we need an instance of NSManagedObjectContext,
    // a kind of in-memory “scratchpad” for working with
    // NSManagedObjects (which in turn are what you use to
    // create, read, update, and delete entities from
    // the data store).

    // When you check the “Use Core Data” checkbox when
    // first creating the project, Xcode generates an
    // NSManagedObjectContext instance and stores it
    // in the app’s appDelegate’s persistentContainer property.
    // So we need to get a reference to the app delegate...
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    // ...and once we have it, we use it to get our
    // NSManagedContext instance.
    return appDelegate.persistentContainer.viewContext
  }

  @IBAction func addToDatabaseButtonClicked(_ sender: Any) {
    let firstName = firstNameTextField.text!
    let lastName = lastNameTextField.text!
    if firstName.count > 0 && lastName.count > 0 {
      writePerson(firstName: firstName, lastName: lastName)
    }
  }

  func writePerson(firstName: String,
                   lastName: String) {
    // Remember, we need the app’s NSManagedObjectContext instance
    // in order to work with the NSManagedObjects that let us
    // create, read, update, and delete entities from
    // the data store.
    guard let managedContext = getManagedContext() else {
      return
    }

    // In order to add a Person entity to the data store,
    // we need to create a Person entity description
    // (an instance of NSEntityDescription specifically
    // keyed to Person entities)...
    let entityDescription = NSEntityDescription.entity(forEntityName: "Person",
                                                       in: managedContext)!

    // ...and use that entity description to create a new
    // managed object for the Person entity.
    let person = NSManagedObject(entity: entityDescription,
                                 insertInto: managedContext)

    // Now that we have a managed object for the Person entity,
    // we can assign values to its first_name and last_name attributes.
    person.setValue(firstName, forKeyPath: "first_name")
    person.setValue(lastName, forKeyPath: "last_name")

    do {
      // With the newly-created Person entity’s attributes set,
      // we add it to the data store.
      try managedContext.save()

      // We’ll also add the newly-created Person entity
      // to our in-memory list.
      people.append(person)

    } catch let error as NSError {
      print("Couldn't save the data: \(error)")
    }
  }

  @IBAction func listAllPeopleButtonClicked(_ sender: Any) {
    readPeople()
    displayPeople()
  }

  func readPeople() {
    // Remember, we need the app’s NSManagedObjectContext instance
    // in order to work with the NSManagedObjects that let us
    // create, read, update, and delete entities from
    // the data store.
    guard let managedContext = getManagedContext() else {
      return
    }

    // NSFetchRequest is the class responsible for fetching from Core Data.
    // In this app, we’re using it the simplest way possible — to simply
    // fetch all Person entities from the data store.
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")

    do {
      // We pass the fetch request to the NSManagedObjectContext instance
      // in order to execute the request, which gives us an array
      // of NSManagedObjects, one for each Person in the data store.
      people = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch from database: \(error)")
    }
  }

  func displayPeople() {
    personTextView.text = ""

    for person in people {
      let firstName = person.value(forKeyPath: "first_name") as! String
      let lastName = person.value(forKeyPath: "last_name") as! String
      personTextView.text += "\(firstName) \(lastName)\n"
    }
  }

}

