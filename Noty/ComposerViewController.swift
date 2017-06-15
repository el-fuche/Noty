//
//  ComposerViewController.swift
//  Noty
//
//  Created by Marvin Adademey on 16/01/2017.
//  Copyright © 2017 Marvin Adademey. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import CoreData
import MapKit

class ComposerViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet var scView: UIScrollView!
    @IBOutlet weak var newTextView: UITextView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var switchReminderState: UISwitch!
    
    let locationManager = CLLocationManager()
    var theDate : String!

    var lng:Double?
    var lat:Double?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
        newTextView.delegate = self
        titleTF.delegate = self
        
        
        
        
        
//        retrivedata()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setUI(){
        
        self.title = "Add a new note"
        scView.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        newTextView.layer.borderColor = UIColor.red.cgColor
        newTextView.layer.borderWidth = 1.0;
        newTextView.layer.cornerRadius = 5.0;
        scView.isScrollEnabled = false
        
        scView.contentSize.height = 900.0
    }
    
    func setLocationManager(){
        
        if (CLLocationManager.locationServicesEnabled() == true) {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            lat = locationManager.location?.coordinate.latitude
            lng = locationManager.location?.coordinate.longitude
//            
//                        lat = 0.0
//                        lng = 0.0

        }
        
    }
    
   
    @IBAction func dismissComposerAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func saveItemAction(_ sender: Any) {
        //sauvegarder l'item
        if (titleTF.text?.characters.count == 0){
            let alert = UIAlertController(title:nil, message: "Veuillez remplir tous les champs avant d'enregistrer un rappel.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
        
        _ = textView(newTextView, shouldChangeTextIn: NSRangeFromString("\n"),replacementText: "\n")
        setLocationManager()
        getTheDate()

        var currentNote: Note!
        currentNote = Note.mr_createEntity()! as Note
        currentNote.name = self.titleTF.text!
        currentNote.content = self.newTextView.text!
        currentNote.lng = lng!
        currentNote.lat = lat!
        currentNote.date = theDate!
            if (switchReminderState.isOn){
                currentNote.reminder = true
            }
            else{
                currentNote.reminder = false
            }
        print(currentNote)
        
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        
        let alert = UIAlertController(title:nil, message: "Votre rappel a été correctement enregistré.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        }
    }
    
    

    
       func getTheDate(){
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        theDate = formatter.string(from: currentDateTime)
        
    }

    // Méthodes pour bouger l'écran si clavier
    func KeyboardDidShow(notification:NSNotification){
//        let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        self.scView.frame.origin.y = -100
    }
    
    func KeyboardDidHide(notification:NSNotification){
//         let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        self.scView.frame.origin.y = 0
    }
    
    
    // Méthodes textField
    func textView(_ textView: UITextView,  shouldChangeTextIn range: NSRange,replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    // Méthodes textView
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        scView.isScrollEnabled = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(KeyboardDidShow),
            name: .UIKeyboardDidShow,
            object: nil)
        return true
    }
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        scView.isScrollEnabled = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(KeyboardDidHide),
            name: .UIKeyboardDidHide,
            object: nil)
        
        return true
    }
    

       
}
