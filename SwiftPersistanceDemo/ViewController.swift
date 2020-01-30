//
//  ViewController.swift
//  SwiftPersistanceDemo
//
//  Created by mobapp15 on 20/01/2020.
//  Copyright © 2020 mobapp15. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    var items:[Idea] = [Idea]()
    
    override func viewWillAppear(_ animated: Bool) {
        items = DAO.sharedInstance.getAllIdeas()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editIdeaSegue" {
            // welke cel?
            let cell:UITableViewCell = sender as! UITableViewCell
            // welke index heeft de cel?
            let indexPath = tableView.indexPath(for: cell)!
            // welk idee zat er in die cel?
            let idea:Idea = items[indexPath.row]
            // waar naartoe?
            let detailsVC = segue.destination as! IdeaDetailViewController
            // data doorsturen
            detailsVC.ideaToUpdate = idea
        }
    }

}

// Lijst opmaken
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        currentCell?.textLabel?.text = items[indexPath.row].title
        
        return currentCell!
    }
}

// Delete knop aanmaken
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDelete = items[indexPath.row]
            
            // Verwijderen uit de DAO
            DAO.sharedInstance.deleteIdea(ideaToDelete: toDelete)
            
            // Verwijderen uit tableView
            items.remove(at: indexPath.row)
            
            // Fancy animatie om uit te tableview te halen
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}

extension ViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            items = DAO.sharedInstance.getAllIdeas()
        } else {
            items = DAO.sharedInstance.getIdeasByPartOfTitle(filter: searchText)
        }
        tableView.reloadData()
    }
}
