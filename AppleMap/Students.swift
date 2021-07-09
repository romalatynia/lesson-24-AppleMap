//
//  Students.swift
//  AppleMap
//
//  Created by Roma Latynia on 3/3/21.
//

import Foundation
import MapKit

class Student: NSObject, MKAnnotation {
    
    var name: String
    var lastName: String
    var coordinate: CLLocationCoordinate2D
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "dd MMMM YYYY"
        return formatter
    }()
    var dateOfBirth: String
    var gender: String
    var title: String? {
        "\(name) \(lastName)"
    }
    var subtitle: String? {
        "\(dateOfBirth)"
    }
    
    init(name: String, lastName: String, coordinate: CLLocationCoordinate2D, dateOfBirth: String, gender: String) {
        self.name = name
        self.lastName = lastName
        self.coordinate = coordinate
        self.dateOfBirth = dateOfBirth
        self.gender = gender
    }
}

/*
 Координаты Бреста в десятичных градусах

 Широта: 52.0975500°
 Долгота: 23.6877500°
 */

class Model {
    
    static let firstNames = [
        "Tran", "Lenore", "Bud", "Fredda", "Katrice",
        "Clyde", "Hildegard", "Vernell", "Nellie", "Rupert",
        "Billie", "Tamica", "Crystle", "Kandi", "Caridad",
        "Vanetta", "Taylor", "Pinkie", "Ben", "Rosanna",
        "Eufemia", "Britteny", "Ramon", "Jacque", "Telma",
        "Colton", "Monte", "Pam", "Tracy", "Tresa",
        "Willard", "Mireille", "Roma", "Elise", "Trang",
        "Ty", "Pierre", "Floyd", "Savanna", "Arvilla",
        "Whitney", "Denver", "Norbert", "Meghan", "Tandra",
        "Jenise", "Brent", "Elenor", "Sha", "Jessie"
    ]
    
    static let lastNames = [
        "Farrah", "Laviolette", "Heal", "Sechrest", "Roots",
        "Homan", "Starns", "Oldham", "Yocum", "Mancia",
        "Prill", "Lush", "Piedra", "Castenada", "Warnock",
        "Vanderlinden", "Simms", "Gilroy", "Brann", "Bodden",
        "Lenz", "Gildersleeve", "Wimbish", "Bello", "Beachy",
        "Jurado", "William", "Beaupre", "Dyal", "Doiron",
        "Plourde", "Bator", "Krause", "Odriscoll", "Corby",
        "Waltman", "Michaud", "Kobayashi", "Sherrick", "Woolfolk",
        "Holladay", "Hornback", "Moler", "Bowles", "Libbey",
        "Spano", "Folson", "Arguelles", "Burke", "Rook"
    ]
    
    static let genders = ["мужской", "женский"]
    
    static func createStudents() -> [Student] {
        var students = [Student]()
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(
            calendar: calendar,
            year: Int.random(in: 1960...2015),
            month: Int.random(in: 1...12),
            day: Int.random(in: 1...30)
        )
        let date = calendar.date(from: dateComponents) ?? Date()
        
        for _ in 1...30 {
            let randomLatitude = Double.random(in: -0.1...0.1)
            let randomLongitude = Double.random(in: -0.1...0.1)
            students.append(
                Student(
                    name: firstNames.randomElement() ?? "Имя отсутствует",
                    lastName: lastNames.randomElement() ?? "Фамилия отсутствует",
                    coordinate: CLLocationCoordinate2D(
                        latitude: 52.0975500 + randomLatitude,
                        longitude: 23.6877500 + randomLongitude
                    ),
                    dateOfBirth: Student.dateFormatter.string(from: date),
                    gender: genders.randomElement() ?? "пол не указан" 
                )
            )
        }
        return students
    }
}
