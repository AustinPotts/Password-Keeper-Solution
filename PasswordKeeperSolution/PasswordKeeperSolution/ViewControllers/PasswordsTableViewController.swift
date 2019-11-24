//
//  PasswordsTableViewController.swift
//  PasswordKeeperSolution
//
//  Created by Austin Potts on 11/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class PasswordsTableViewController: UITableViewController {
    
    
    let passwordController = PasswordController()
    
    //Creating computed property for Fetch Results Controller
       lazy var fetchResultsController: NSFetchedResultsController<Password> = {
           
           //Create the fetch request
           let fetchRequest: NSFetchRequest<Password> = Password.fetchRequest()
           
           //sort the fetched results
           fetchRequest.sortDescriptors = [NSSortDescriptor(key: "website", ascending: true)]
           
           let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.share.mainContext, sectionNameKeyPath: "website", cacheName: nil)
           
           frc.delegate = self

           do{
               try frc.performFetch()
           }catch {
               fatalError("Error performing fetch: \(error)")
           }
           
           return frc
           
       }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordCell", for: indexPath)

        // Configure the cell...
        
        let password = fetchResultsController.object(at: indexPath)
        cell.textLabel?.text = password.website

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               //Get the object
               let password = fetchResultsController.object(at: indexPath)
               // Delete the row from the data source
            passwordController.delete(password: password)
           }
       }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ViewPasswordSegue" {
            guard let detailVC = segue.destination as? AddPasswordViewController,
                let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let password = fetchResultsController.object(at: indexPath)
            
            detailVC.password = password
            detailVC.passwordController = passwordController
        } else if segue.identifier == "AddPasswordSegue"{
            guard let detailVC = segue.destination as? AddPasswordViewController else{return}
            
            detailVC.passwordController = passwordController
        }
        
        
    }

    

}

extension PasswordsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else{return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .delete:
            guard let indexPath = indexPath else{return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else{return}
            tableView.moveRow(at: indexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else{return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        @unknown default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let sectionSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(sectionSet, with: .automatic)
            
        case .delete:
            tableView.deleteSections(sectionSet, with: .automatic)
            
        default: return
        }
        
 }

}
