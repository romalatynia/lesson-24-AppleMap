//
//  ExtensionView.swift
//  AppleMap
//
//  Created by Roma Latynia on 3/4/21.
//

import Foundation
import MapKit

extension UIView {
    
    func superAnnotationView () -> MKAnnotationView? {
        if self.isKind(of: MKAnnotationView.self) {
            return self as? MKAnnotationView
        }
        return self.superview?.superAnnotationView()
    }
}
