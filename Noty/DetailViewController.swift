//
//  DetailViewController.swift
//  Noty
//
//  Created by Marvin Adademey on 17/01/2017.
//  Copyright © 2017 Marvin Adademey. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    //Reception de l'object Note
    var aNote : Note!
   
    @IBOutlet weak var remidLabel: UILabel!
    
    @IBOutlet weak var mapToShow: MKMapView!
    @IBOutlet weak var theTitle: UILabel!
    @IBOutlet weak var theDate: UILabel!
    @IBOutlet weak var desc: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        theTitle.text = titleContainer
        print(aNote)
        theTitle.text = aNote.name
        desc.text = aNote.content
        theDate.text = aNote.date
        self.title = aNote.name
        if (aNote.reminder == true){
            remidLabel.isHidden = false
        }
        else{
            remidLabel.isHidden = true
        }
        setMap(longitude: aNote.lng, latitude: aNote.lat)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMap(longitude: Double, latitude : Double ) {
        
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude:latitude, longitude: longitude)
        mapToShow.addAnnotation(annotation)

        let center = CLLocationCoordinate2D(latitude:latitude,longitude: longitude)
        let region = MKCoordinateRegion(center:center, span:MKCoordinateSpan(latitudeDelta:0.02,longitudeDelta:0.02))
        
        self.mapToShow.setRegion(region, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
