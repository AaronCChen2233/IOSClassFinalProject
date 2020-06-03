//
//  FetchedResultsTableViewController.swift
//  NewsAPI
//
//  Created by Derrick Park on 5/24/20.
//  Copyright © 2020 Derrick Park. All rights reserved.
//

import UIKit
import CoreData

class FetchedResultsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
      case .insert: tableView.insertSections([sectionIndex], with: .fade)
      case .delete: tableView.deleteSections([sectionIndex], with: .fade)
      default: break
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
      case .insert:
        tableView.insertRows(at: [newIndexPath!], with: .fade)
      case .delete:
        tableView.deleteRows(at: [indexPath!], with: .fade)
      case .update:
        tableView.reloadRows(at: [indexPath!], with: .fade)
      case .move:
        tableView.deleteRows(at: [indexPath!], with: .fade)
        tableView.insertRows(at: [newIndexPath!], with: .fade)
      @unknown default:
        fatalError("FetchedResultsTableViewController -- unknown case found")
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
}
