//
//  ContentView.swift
//  Get User Location
//
//  Created by Adham Raouf on 03/11/2022.
//
import MapKit
import CoreLocationUI
import SwiftUI

struct ContentView: View {
    
//    @StateObject private var viewModel = contentViewModel()
    @StateObject private var viewModel = contentViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                .ignoresSafeArea()
                .tint(.red)
            
            LocationButton(.currentLocation) {
                viewModel.requstAllowOnceLocationPermissin()
            }
            .foregroundColor(.white)
            .cornerRadius(20)
//            .labelStyle(.iconOnly)
            .symbolVariant(.fill)
            .tint(.black)
            .padding(.bottom, 40)
            
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class contentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40, longitude: 120),
        span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
    
    
    let locationManger = CLLocationManager()
    
    override init() {
        super.init()
        locationManger.delegate = self
    }
    
    
    
    func requstAllowOnceLocationPermissin() {
        locationManger.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            //show an error
            return
        }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(
                center: latestLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
}


