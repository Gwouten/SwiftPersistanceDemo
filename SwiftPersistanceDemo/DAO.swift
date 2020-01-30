//
//  DAO.swift
//  SwiftPersistanceDemo
//
//  Created by mobapp15 on 20/01/2020.
//  Copyright © 2020 mobapp15. All rights reserved.
//

import Foundation
import CoreData

class DAO{
    
    // MARK: Singleton pattern
    // 1 statische instantie van de klasse die overal gebruikt kan worden en dus overal dezelfde waarden bijhoudt
    static let sharedInstance = DAO.init()
    
    // init methode afschermen, door private te maken
    private init(){
        // gewoon om niet te overschrijven
    }
    
    // MARK: CORE DATA
    // opbouwen container
    lazy var persistentContainer:NSPersistentContainer = {
        let container = NSPersistentContainer.init(name: "Model") // naam van de .xcdatamodeld file
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            // foutafhandeling
        })
        
        return container
    }() // haakjes om de functie te laten uitvoeren
    
    // Gegevens opslaan als er wijzingen geweest zijn
    private func saveContext(){
        let context = persistentContainer.viewContext
        // Zijn er wijzigingen geweest?
        if context.hasChanges{
            do {
                try context.save() // sla op in de database
            } catch {
                print("Error: \(error.localizedDescription)") // 'error' bestaat sowieso in een catch
            }
        }
    }
    
    // MARK: CRUD
    
    // Create
    func saveIdea(title:String, content:String){
        // nieuwe idee in de juiste context toevoegen
        let newIdea = Idea.init(context: persistentContainer.viewContext)
        newIdea.title   = title
        newIdea.content = content
                
        saveContext()
    }
    
    // Read all
    func getAllIdeas() -> [Idea]{
        // opbouwen van query
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Idea")
        do {
            let ideas = try persistentContainer.viewContext.fetch(request) as! [Idea]
            return ideas
        } catch {
            return []
        }
    }
    
    // Read filtered result
    func getIdeasByPartOfTitle(filter:String) -> [Idea]{
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Idea")
        let predicate = NSPredicate.init(format: "title CONTAINS[cd] %@", filter)
        request.predicate = predicate
        
        do {
            return try persistentContainer.viewContext.fetch(request) as! [Idea]
        } catch {
            return []
        }
    }
    
    // Update
    func updateIdea(objectId:NSManagedObjectID, title:String, content:String){
        // Query om Idea te vinden op id
        do {
            let idea = try persistentContainer.viewContext.existingObject(with: objectId) as! Idea
            idea.title = title
            idea.content = content
        } catch {
            // fout opgevangen
            print(error.localizedDescription)
        }
        saveContext()
    }
    
    
    // Delete
    func deleteIdea(ideaToDelete:Idea){
        persistentContainer.viewContext.delete(ideaToDelete)
        
        saveContext()
    }
    
}
