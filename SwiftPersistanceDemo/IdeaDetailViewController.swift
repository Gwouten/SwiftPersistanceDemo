//
//  IdeaDetailViewController.swift
//  SwiftPersistanceDemo
//
//  Created by mobapp15 on 21/01/2020.
//  Copyright © 2020 mobapp15. All rights reserved.
//

import UIKit

class IdeaDetailViewController: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var contentTV: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    var ideaToUpdate:Idea?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let idea = ideaToUpdate {
            titleTF.text = idea.title
            contentTV.text = idea.content
        }
        
        titleEdited()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func titleEdited() {
        if titleTF.text!.count >= 3 {
            saveBtn.isEnabled = true
        } else {
            saveBtn.isEnabled = false
        }
    }
    
    @IBAction func saveIdea() {
        if ideaToUpdate == nil {
            DAO.sharedInstance.saveIdea(
                title: titleTF.text!,
                content: contentTV.text
            )
        } else {
            DAO.sharedInstance.updateIdea(
                objectId: ideaToUpdate!.objectID,
                title: titleTF.text!,
                content: contentTV.text!
            )
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // Doe keyboard weg als er buiten een textfield getapt wordt
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        titleTF.resignFirstResponder()
        contentTV.resignFirstResponder()
    }
    
}
