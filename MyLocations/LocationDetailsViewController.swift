//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Mario Alberto Gonzalez on 21/03/17.
//  Copyright © 2017 Mario Alberto Gonzalez. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

private let dateFormatter: DateFormatter = {
   let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
class LocationDetailsViewController: UITableViewController {

    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var selectedCategory: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var categoryName = "No Category"
    var date = Date()
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionText.text = ""
        selectedCategory.text = categoryName
        
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        
        if let placemark = placemark {
            addressLabel.text = string(from: placemark)
        }else {
            addressLabel.text = "No address found"
        }
        dateLabel.text = format(date: date)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    func hideKeyboard(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        if let indexPath = indexPath, indexPath.section == 0 && indexPath.row == 0 {
            return
        }
        descriptionText.resignFirstResponder()
    }
    
    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func string(from placemark: CLPlacemark) -> String {
        var text = ""
        if let s = placemark.subThoroughfare {
            text += s + " "
        }
        if let s = placemark.thoroughfare {
            text += s + ", "
        }
        if let s = placemark.locality {
            text += s + ", "
        }
        if let s = placemark.administrativeArea {
            text += s + " "
        }
        if let s = placemark.postalCode {
            text += s + ", "
        }
        if let s = placemark.country {
            text += s
        }
        return text
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 88
        } else if indexPath.section == 2 && indexPath.row == 2 {
            addressLabel.frame.size = CGSize(
                width: view.bounds.size.width - 115, height: 10000)
            addressLabel.sizeToFit()
            addressLabel.frame.origin.x = view.bounds.size.width -
                                          addressLabel.frame.size.width - 15
            return addressLabel.frame.size.height + 20
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        }else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionText.becomeFirstResponder()
        }
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        let _ = HudView.hud(inView: navigationController!.view, animate: true)
        
        let location = Location(context: managedObjectContext)
        location.locationDescription = descriptionText.text
        location.category = categoryName
        location.date = date
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.placemark = placemark
        
        do {
            try managedObjectContext.save()
            afterDelay(0.6, closure: {
                self.dismiss(animated: true, completion: nil)
            })
        } catch {
            fatalError("Error \(error)")
        }
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickCategoryDidPickCategory(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! PickCategoryViewController
        selectedCategory.text = controller.selectedCategory
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickCategory" {
            let controller = segue.destination as! PickCategoryViewController
            controller.selectedCategory = categoryName
        }
    }
}
