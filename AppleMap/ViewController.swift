//
//  ViewController.swift
//  AppleMap
//
//  Created by Roma Latynia on 3/3/21.
//

import MapKit

private enum Constants {
    static let tagSize = 30
    static let infoListSize = 300
    static let imageSize = 50
    static let latitude = 52.0975500
    static let longitude = 23.6877500
    static let mainTitle = "Map"
    static let numberOfPiopleFrameLabelX = 185
    static let helpValue = 10
    static let frameLabelY8km = 60
    static let frameLabelY15km = 110
    static let numberOfPiopleFrameLabelWidth = 25
    static let frameLabelX = 5
    static let frameLabelWidth = 180
    static let frameLabelHeight = 17
    static let textLabel = "0"
    static let lineWidth: CGFloat = 2.0
    static let smallRadius: CLLocationDistance = 3000
    static let middleRadius: CLLocationDistance = 8000
    static let bigRadius: CLLocationDistance = 15000
    static let unitsInside3000m = "Units inside 3000 m:"
    static let unitsInside8000m = "Units inside 8000 m:"
    static let unitsInside15000m = "Units inside 15000 m:"
    static let frameViewY = 100
    static let frameViewWidth = 215
    static let frameViewHeight = 150
    static let bottomConstants: CGFloat = -40
    static let imageMan = "man"
    static let imageWoman = "woman"
}

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    private var mapView = MKMapView()
    private var venue: Venue?
    private var students: Student?
    private let arrayStudents = Model.createStudents()
    private var circle1 = MKCircle()
    private var circle2 = MKCircle()
    private var circle3 = MKCircle()
    private lazy var informationButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.addTarget(self, action: #selector(infoButtonPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    private let numberOfPeopleWithin3kmLabel: UILabel = {
        let label = UILabel(
            frame: CGRect(
                x: Constants.numberOfPiopleFrameLabelX,
                y: Constants.helpValue,
                width: Constants.numberOfPiopleFrameLabelWidth,
                height: Constants.frameLabelHeight
            )
        )
        label.text = Constants.textLabel
        return label
    }()
    
    private let numberOfPeopleWithin8kmLabel: UILabel = {
        let label = UILabel(
            frame: CGRect(
                x: Constants.numberOfPiopleFrameLabelX,
                y: Constants.frameLabelY8km,
                width: Constants.numberOfPiopleFrameLabelWidth,
                height: Constants.frameLabelHeight
            )
        )
        label.text = Constants.textLabel
        return label
    }()
    
    private let numberOfPeopleWithin15kmLabel: UILabel = {
        let label = UILabel(
            frame: CGRect(
                x: Constants.numberOfPiopleFrameLabelX,
                y: Constants.frameLabelY15km,
                width: Constants.numberOfPiopleFrameLabelWidth,
                height: Constants.frameLabelHeight
            )
        )
        label.text = Constants.textLabel
        return label
    }()
    
    lazy var informationBoard: UIView = {
        let view = UIView(
            frame: CGRect(
                x: Constants.helpValue,
                y: Constants.frameViewY,
                width: Constants.frameViewWidth,
                height: Constants.frameViewHeight
            )
        )
        view.backgroundColor = UIColor(displayP3Red: 0.5543, green: 0.75467, blue: 0.3446, alpha: 0.7)
        let label1 = UILabel(
            frame: CGRect(
                x: Constants.frameLabelX,
                y: Constants.helpValue,
                width: Constants.frameLabelWidth,
                height: Constants.frameLabelHeight
            )
        )
        label1.text = Constants.unitsInside3000m
        let label2 = UILabel(
            frame: CGRect(
                x: Constants.frameLabelX,
                y: Constants.frameLabelY8km,
                width: Constants.frameLabelWidth,
                height: Constants.frameLabelHeight
            )
        )
        label2.text = Constants.unitsInside8000m
        let label3 = UILabel(
            frame: CGRect(
                x: Constants.frameLabelX,
                y: Constants.frameLabelY15km,
                width: Constants.frameLabelWidth,
                height: Constants.frameLabelHeight
            )
        )
        label3.text = Constants.unitsInside15000m
        
        [
            label1,
            label2,
            label3,
            numberOfPeopleWithin3kmLabel,
            numberOfPeopleWithin8kmLabel,
            numberOfPeopleWithin15kmLabel
        ].forEach({view.addSubview($0)})
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.mainTitle
        createBarButton()
        createMaps()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    private func createBarButton() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        let addVenue = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addVenueAction))
        let pathButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(pathButtonPressed(sender:)))
        navigationItem.leftBarButtonItems = [addVenue, pathButton]
        navigationItem.rightBarButtonItem = add
    }
    
    private func createMaps() {
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.bottomConstants).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func refreshTitlesInInformationBar() {
        guard let meetup = venue else { return }
        meetup.devideStudentsACcordingToDistanse(students: arrayStudents)
        numberOfPeopleWithin3kmLabel.text = "\(meetup.nearestStudents.count)"
        numberOfPeopleWithin8kmLabel.text = "\(meetup.middleStudents.count)"
        numberOfPeopleWithin15kmLabel.text = "\(meetup.largeStudents.count)"
    }
    
    private func randomCoordinate() -> CLLocationCoordinate2D {
        let randomLatitude = Double.random(in: -0.1...0.1)
        let randomLongitude = Double.random(in: -0.1...0.1)
        let coordinate = CLLocationCoordinate2D(
            latitude: Constants.latitude + randomLatitude,
            longitude: Constants.longitude + randomLongitude
        )
        
        return coordinate
    }
    
    private func showCircles() {
        circle1 = MKCircle(center: venue?.coordinate ?? CLLocationCoordinate2D(), radius: Constants.smallRadius)
        circle2 = MKCircle(center: venue?.coordinate ?? CLLocationCoordinate2D(), radius: Constants.middleRadius)
        circle3 = MKCircle(center: venue?.coordinate ?? CLLocationCoordinate2D(), radius: Constants.bigRadius)
        
        mapView.addOverlays([circle1, circle2, circle3])
    }
    
    private func createImage(named: String) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: .zero, y: .zero, width: Constants.imageSize, height: Constants.imageSize))
        imageView.image = UIImage(named: named)
        
        return imageView
    }
    
    private func showPopover(navController: UITableViewController, sender: MKAnnotationView) {
        let infoList = navController
        infoList.preferredContentSize = CGSize(width: Constants.infoListSize, height: Constants.infoListSize)
        infoList.modalPresentationStyle = .popover
        let popover = infoList.popoverPresentationController
        popover?.delegate = self
        popover?.permittedArrowDirections = .any
        popover?.sourceView = sender
        popover?.sourceRect = sender.bounds
        present(infoList, animated: true, completion: nil)
    }
    
    // MARK: - Функции objc
    
    @objc private func infoButtonPressed(sender: UIButton) {
        let annotationView: MKAnnotationView? = sender.superAnnotationView()
        
        if annotationView != nil {
            guard let student = annotationView?.annotation as? Student else { return }
            let studentPopover = StudentInformationViewController(student: student)
            showPopover(navController: studentPopover, sender: annotationView ?? MKAnnotationView())
        }
    }
    
    @objc private func addAction() {
        for user in arrayStudents {
            mapView.addAnnotation(user)
        }
    }
    
    @objc private func addVenueAction() {
        venue = Venue(coordinate: randomCoordinate())
        guard let meetup = venue else { return }
        view.addSubview(informationBoard)
        showCircles()
        mapView.addAnnotation(meetup)
        mapView.showAnnotations(mapView.annotations, animated: true)
        refreshTitlesInInformationBar()
    }
    
    @objc func pathButtonPressed(sender: UIBarButtonItem) {
        mapView.removeOverlays([circle1, circle2, circle3])
        showCircles()
        
        guard let meetup = venue else { return }
        let studentsList = meetup.createParticipatorsList(students: arrayStudents)
        let placemark = MKPlacemark(coordinate: meetup.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        let request = MKDirections.Request()
        request.transportType = .automobile
        request.source = mapItem
        
        for student in studentsList {
            let studentPlacemark = MKPlacemark(coordinate: student.coordinate)
            let destination = MKMapItem(placemark: studentPlacemark)
            request.destination = destination
            let directins = MKDirections(request: request)
            directins.calculate { (responce: MKDirections.Response?, error: Error?) in
                if error != nil {
                    print(error.debugDescription)
                } else {
                    if let tmp = responce, !tmp.routes.isEmpty {
                        let mkRoute = tmp.routes.last ?? MKRoute()
                        self.mapView.addOverlay(mkRoute.polyline)
                        print("Hello")
                    } else {
                        print("No routes found")
                    }
                }
            }
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: Student.self) {
            annotationView = mapView.view(for: annotation) as? MKPinAnnotationView ??
                MKPinAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: nil
                )
            annotationView?.image = (annotation as? Student)?.gender == "мужской" ?
                createImage(named: Constants.imageMan).image :
                createImage(named: Constants.imageWoman).image
            annotationView?.frame.size = CGSize(width: Constants.tagSize, height: Constants.tagSize)
            annotationView?.canShowCallout = true
            annotationView?.isEnabled = true
            annotationView?.rightCalloutAccessoryView = informationButton
        } else if annotation.isKind(of: Venue.self) {
            
            annotationView = mapView.view(for: annotation) as? MKPinAnnotationView ??
                MKPinAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: nil
                )
            annotationView?.isDraggable = true
            annotationView?.canShowCallout = true
            annotationView?.isEnabled = true
        }
        
        return annotationView
    }
    
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        didChange newState: MKAnnotationView.DragState,
        fromOldState oldState: MKAnnotationView.DragState
    ) {
        switch newState {
        case .starting:
            view.dragState = .dragging
            mapView.removeOverlays(mapView.overlays)
//            showCircles()
        case .ending, .canceling:
            view.dragState = .none
            showCircles()
        default:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        var overlayRender = MKOverlayRenderer()
        if overlay.isKind(of: MKCircle.self) {
            let circleRender = MKCircleRenderer(overlay: overlay)
            circleRender.strokeColor = UIColor(displayP3Red: 0.4, green: 0.3665, blue: 0.987, alpha: 0.4)
            circleRender.fillColor = UIColor(displayP3Red: 0.4, green: 0.3665, blue: 0.987, alpha: 0.4)
            overlayRender = circleRender
            refreshTitlesInInformationBar()
        } else if overlay.isKind(of: MKPolyline.self) {
            let polylineRender = MKPolylineRenderer(overlay: overlay)
            var color: UIColor
            switch (overlay as? MKPolyline)?.pointCount ?? MKPolyline().pointCount {
            case 0...150:
                color = UIColor.green
            case 151...280:
                color = UIColor.yellow
            case 281...400:
                color = UIColor.orange
            default:
                color = UIColor.red
            }
            
            polylineRender.strokeColor = color
            polylineRender.lineWidth = Constants.lineWidth
            overlayRender = polylineRender
        }
        
        return overlayRender
    }
}
