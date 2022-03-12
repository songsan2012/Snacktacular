//
//  SpotDetailViewController.swift
//  Snacktacular
//
//  Created by song on 3/11/22.
//

import UIKit

class SpotDetailViewController: UIViewController {

//    @IBOutlet weak var nameTextField: UILabel!
//    @IBOutlet weak var addressTextField: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var spot: Spot!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if spot == nil {
            spot = Spot()
        }
        
    }
    
    func updateUserInterface() {
        nameTextField.text = spot.name
        addressTextField.text = spot.address
    }
    
    func updateFromInterface() {
        spot.name = nameTextField.text!
        spot.address = addressTextField.text!
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromInterface()
        spot.saveData { (success) in
            if success {
                self.leaveViewController()
            } else {
                // ERROR during save occured
                self.oneButtonAlert(title: "😡 Save Failed", message: "For some reason could not save to the cloud.")
            }
        }
    }
    


    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
            leaveViewController()
        
    }
    
}
