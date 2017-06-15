
//
//  ViewController.swift
//  Noty
//
//  Created by Marvin Adademey on 16/01/2017.
//  Copyright © 2017 Marvin Adademey. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UNUserNotificationCenterDelegate {
    @IBOutlet var theTableview: UITableView!
    var containerEntites: [Note]!
    var refreshControl: UIRefreshControl!
    var genIndex: Int!
    
    let locationManager = CLLocationManager()



    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUI()
        containerEntites = Note.mr_findAll() as! [Note]
        setLocationManager()
        notyTest()
        test2()
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        containerEntites = Note.mr_findAll() as! [Note]

        theTableview.reloadData()

    }
    
    @IBAction func addAnItem(_ sender: Any) {
        
        performSegue(withIdentifier: "toComposer", sender:nil)
    }
    
    func setUI() {
        self.title = "noty"
        theTableview.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ViewController.reloadTBL), for: UIControlEvents.valueChanged)
        theTableview.addSubview(refreshControl)
    }

    
    func reloadTBL(){
        containerEntites = Note.mr_findAll() as! [Note]
        
        theTableview.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetail"){
            let destination = segue.destination as? DetailViewController
            destination?.aNote = sender as! Note!
            
        }
        
    }

    
    
    //Methodes TableView
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        print(containerEntites.count)
        return containerEntites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        cell.textLabel?.text = containerEntites[indexPath.row].name
        cell.detailTextLabel?.text = containerEntites[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            containerEntites.remove(at: indexPath.row).mr_deleteEntity()
            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
            
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        genIndex = indexPath.row
        performSegue(withIdentifier: "toDetail", sender: containerEntites[genIndex])
        print(containerEntites[indexPath.row])
    }
    
    func notyTest() {
        
        
        let center = UNUserNotificationCenter.current()
//        [content setValue:@(YES) forKeyPath:@"shouldAlwaysAlertWhileAppIsForeground"];
        center.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        

        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
//                settings.sho
                // Notifications not allowed
            }
        }

        
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Buy some milk"
        content.setValue(true, forKey: "shouldAlwaysAlertWhileAppIsForeground")

        content.sound = UNNotificationSound.default()
        
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        let startLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 60.0, longitude: 60.0)
        let monitoredRegion = CLCircularRegion(center: startLocation, radius: 100, identifier: "Region Test")
        
        //        var region = CLRegion(coder : CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        let trigger = UNLocationNotificationTrigger(region:monitoredRegion, repeats:true)
        
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
//        UIApplication.shared.loc
        
//        request.shou
        print(request)
        center.add(request, withCompletionHandler: { (error) in
            
            if let error = error {
                print(error)
                // Something went wrong
            }
        })
         print(request)

    }
//    
    func test2()  {
        func triggerNotification(){
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Notification Testing", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "This is a test", arguments: nil)
            content.sound = UNNotificationSound.default()
            content.badge = (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber;
            content.setValue("YES", forKeyPath: "shouldAlwaysAlertWhileAppIsForeground") //Update is here
            
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: 1.0,
                repeats: false)
            
            let request = UNNotificationRequest.init(identifier: "testTriggerNotif", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    
    func setLocationManager(){
        
        if (CLLocationManager.locationServicesEnabled() == true) {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            print("latitude : \(locationManager.location?.coordinate.latitude), \nlongitude : \(locationManager.location?.coordinate.longitude) \n")
//            
//            lat = locationManager.location?.coordinate.latitude
//            lng = locationManager.location?.coordinate.longitude
            //
            //                        lat = 0.0
            //                        lng = 0.0
            
        }
        
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void){
        print("LOL")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("LOL")
    }
    
    
    
    
}

