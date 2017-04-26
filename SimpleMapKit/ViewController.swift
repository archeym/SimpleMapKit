//
//  ViewController.swift
//  SimpleMapKit
//
//  Created by Arkadijs Makarenko on 26/04/2017.
//  Copyright © 2017 ArchieApps. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let lat = 3.1374262
    let long = 101.6328546
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nextAnnotation = MKPointAnnotation()
        nextAnnotation.title = "NextAcademy"
        nextAnnotation.subtitle = "You are here!"
        nextAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.addAnnotation(nextAnnotation)
        
        mapView.delegate = self
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: long), animated: true)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString("KLCC") { (placemarks, error) in
            if let err = error{
                print("error: \(err.localizedDescription)")
                return
            }
            if let places = placemarks{
                for place in places{
                    if let coord = place.location?.coordinate{
                    let annot = MKPointAnnotation()
                    annot.coordinate = coord
                    annot.title = place.name
                    annot.subtitle = place.postalCode
                        self.mapView.addAnnotation(annot)
                    }
                }
            }
        }
    }
}


extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let title = annotation.title
            else {return nil}
        if title == "NextAcademy" {
        let annotationView = MKAnnotationView()
        annotationView.image = UIImage(named: "pin")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return annotationView
        }else{
            let pinAnotationView = MKPinAnnotationView()
            pinAnotationView.pinTintColor = UIColor.darkGray
            pinAnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinAnotationView.canShowCallout = true
            return pinAnotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let coord = view.annotation?.coordinate else {return}
        
        let span = MKCoordinateSpanMake(0.05, 0.05)//????
        let region = MKCoordinateRegion(center: coord, span: span)
        mapView.setRegion(region, animated: true)
    }
}

