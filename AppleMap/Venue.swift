//
//  Venue.swift
//  AppleMap
//
//  Created by Roma Latynia on 3/5/21.
//

import Foundation
import MapKit

class Venue: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var nearestStudents = [Student]()
    var middleStudents = [Student]()
    var largeStudents = [Student]()
    var otherStudents = [Student]()
    
    init(coordinate: CLLocationCoordinate2D) {
        self.title = "title"
        self.subtitle = "subtitle"
        self.coordinate = coordinate
    }
    
    func devideStudentsACcordingToDistanse(students: [Student]) {
        nearestStudents = [Student]()
        middleStudents = [Student]()
        largeStudents = [Student]()
        otherStudents = [Student]()
        
        for item in students {
            switch distanceFromStudentToMeetup(student: item) {
            case 0...3000:
                nearestStudents.append(item)
            case 3001...8000:
                middleStudents.append(item)
            case 8001...15000:
                largeStudents.append(item)
            default:
                otherStudents.append(item)
            }
        }
    }
    
    func createParticipatorsList(students: [Student]) -> [Student] {
        var result = [Student]()
        
        for student in students {
            if willVisitTheEvent(student: student) {
                result.append(student)
            }
        }
        
        return result
    }
    
    func willVisitTheEvent(student: Student) -> Bool {
        var willVisit = false
        switch distanceFromStudentToMeetup(student: student) {
            case 0...3000:
                willVisit = Int.random(in: 0...1000) < 900
            case 3001...8000:
                willVisit = Int.random(in: 0...1000) < 600
            case 8001...15000:
                willVisit = Int.random(in: 0...1000) < 200
            default:
                willVisit = Int.random(in: 0...1000) < 80
        }
        
        return willVisit
    }
    
    func distanceFromStudentToMeetup(student: Student) -> CLLocationDistance {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let studentLocation = CLLocation(latitude: student.coordinate.latitude, longitude: student.coordinate.longitude)
        
        return location.distance(from: studentLocation)
    }

}
