//
//  AddClockViewController.swift
//  iOS_Clock_App
//
//  Created by WendaLi on 2020-05-31.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit
import CoreData

class AddClockViewController: FetchedResultsTableViewController {

    private var fetchedResultsController: NSFetchedResultsController<ManagedTimeZone>!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var cancelButton: UIBarButtonItem!
    
    private let cellId = "basicStyle"
    
    var container: NSPersistentContainer!

    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        //navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = false
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()

        setupSearchController()
        
        setupTableView()
        
        fetchExistedZones()
                
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: WorldClocksController.zonesUpdatedNotification, object: nil)
    }
    
    private func setupNavigation() {
        //view.backgroundColor = .black
        navigationItem.title = "Choose a City"
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        cancelButton.tintColor = UIColor(named: "highlightOrange")
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        //searchController.searchBar.searchTextField.textColor = .white
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "highlightOrange")]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as [NSAttributedString.Key : Any] , for: .normal)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        //tableView.backgroundColor = .black
        //tableView.separatorColor = .gray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func fetchExistedZones() {
        fetchedResultsController = {
             let request: NSFetchRequest<ManagedTimeZone> = ManagedTimeZone.fetchRequest()
             request.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
             let frc = NSFetchedResultsController<ManagedTimeZone>(
                fetchRequest: request,
                managedObjectContext: container!.viewContext,
                sectionNameKeyPath: "firstLetter",
                cacheName: nil)
             // It's going to permanently cache the results (stores on disk in some internal format)
             // Be sure that any cacheName you use is always associated with exactly the same request.
             // You'll have to invalidate the cache if you change anything about the request. (There's an API for it)
            frc.delegate = self
            return frc
        }()
        updateUI()
    }
    
    private func filterZonesFor(_ searchText: String) {
        if isFiltering {
            fetchedResultsController = {
                let request: NSFetchRequest<ManagedTimeZone> = ManagedTimeZone.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
                request.predicate = NSPredicate(format: "ANY city CONTAINS[c] %@", searchText)
                let frc = NSFetchedResultsController<ManagedTimeZone>(
                    fetchRequest: request,
                    managedObjectContext: container!.viewContext,
                    sectionNameKeyPath: "firstLetter",
                    cacheName: nil)
                frc.delegate = self
                return frc
            }()
            updateUI()
        }else {
            fetchExistedZones()
            updateUI()
        }
    }
    
    @objc func updateUI() {
        DispatchQueue.main.async {
            try? self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        }
    }
    
    private func updateWorldClockDatabase(with zone: Zone) {
        container.performBackgroundTask { context in
            context.perform {
                _ = try? ManagedWorldClock.findOrCreateWorldClock(matching: zone, with: zone.zoneName, in: context)
                try? context.save()
            }
        }
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension AddClockViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filterZonesFor(searchController.searchBar.text!)
  }
}

extension AddClockViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterZonesFor(searchController.searchBar.text!)
  }
}

extension AddClockViewController {
    // MARK: - table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections, sections.count > 0 {
            return sections[section].numberOfObjects
            //return isFiltering ? filteredZones.count : zones.count
        } else {
          return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections, sections.count > 0 {
          return sections[section].name
        } else {
          return nil
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let city = fetchedResultsController.object(at: indexPath)
        //let city = isFiltering ? filteredZones[indexPath.row] : zones[indexPath.row]
        //cell.backgroundColor = .black
        cell.selectionStyle = .none
        //cell.textLabel?.textColor = .white
        let zoneName = city.zoneName!.split(separator: "/")
        let cityName = zoneName[1]
        cell.textLabel?.text = "\(cityName), \(city.countryName!)"
        return cell
    }
    
    // MARK: table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let didSelectZone = fetchedResultsController.object(at: indexPath).converToZone()
        //let didSelectZone = isFiltering ? filteredZones[indexPath.row] : zones[indexPath.row]
        if !WorldClocksController.shared.worldClocks.worldClockList.contains(where: { (city) -> Bool in
            return city == didSelectZone
        }) {
            WorldClocksController.shared.worldClocks.worldClockList.append(didSelectZone)
            self.updateWorldClockDatabase(with: didSelectZone)
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
