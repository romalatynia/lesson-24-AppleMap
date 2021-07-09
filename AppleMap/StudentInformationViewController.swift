//
//  StudentInformationViewController.swift
//  AppleMap
//
//  Created by Roma Latynia on 3/4/21.
//

import CoreLocation
import UIKit

private enum Constants {
    static let tableViewSource = [
        "First name",
        "Last name",
        "Gender",
        "Day of Birth",
        "Country code",
        "Country",
        "City",
        "Neighborhood",
        "Street",
        "Postal code"
    ]
    static let studentIdentifier = "Student"
    static let null = "Null"
    static let unknown = "Unknown"
    static let man = "мужской"
    static let woman = "женский"
    static let latitude = 23.7
    static let longitude = 52.1
}

class StudentInformationViewController: UITableViewController {
    
    private var student: Student?
    private var countryCode: String?
    private var country: String?
    private var city: String?
    private var street: String?
    private var state: String?
    private var postalCode: String? {
        didSet {
            updateTableCells()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        decodeLocationToStrings()
    }
    
    init(student: Student) {
        self.student = student
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateTableCells() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    private func decodeLocationToStrings() {
        let geocoder = CLGeocoder()
        let location = CLLocation(
            latitude: student?.coordinate.latitude ?? Constants.latitude,
            longitude: student?.coordinate.longitude ?? Constants.longitude
        )
        geocoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            if error != nil {
                print(error.debugDescription)
            } else {
                if placemarks?.count ?? .zero > 0 {
                    let placemark = placemarks?.last ?? CLPlacemark()
                    self.countryCode = placemark.isoCountryCode
                    self.country = placemark.country
                    self.city = placemark.locality
                    self.street = placemark.thoroughfare
                    self.state = placemark.subAdministrativeArea
                    self.postalCode = placemark.postalCode
                } else {
                    print("No placemarks found")
                }
            }
        }
    }
    
    private func valueForRow(row: Int) -> String {
        let result: String
        switch row {
        case 0:
            result = student?.name ?? Constants.unknown
        case 1:
            result = student?.lastName ?? Constants.unknown
        case 2:
            result = student?.gender == Constants.man ? Constants.man : Constants.woman
        case 3:
            result = student?.dateOfBirth ?? Constants.unknown
        case 4:
            result = countryCode ?? Constants.unknown
        case 5:
            result = country ?? Constants.unknown
        case 6:
            result = city ?? Constants.unknown
        case 7:
            result = state ?? Constants.unknown
        case 8:
            result = street ?? Constants.unknown
        case 9:
            result = postalCode ?? Constants.unknown
        default:
            result = Constants.null
        }
        
        return result
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
         1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Constants.tableViewSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: Constants.studentIdentifier)
        cell.textLabel?.text = Constants.tableViewSource[indexPath.row]
        cell.detailTextLabel?.text = valueForRow(row: indexPath.row)

        return cell
    }
}
