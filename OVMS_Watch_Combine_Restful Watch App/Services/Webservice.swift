//
//  Webservice.swift
//  OV-Watch-Combine Watch App
//
//  Created by Peter Harry on 10/9/2022.
//

import Foundation

import Combine

class Webservice {
    
    func getStatus(cookie: String, vehicle: String) -> AnyPublisher<Status,Error> {
        guard let url = URL(string: "https://api.openvehicles.com:6869/api/status/\(vehicle)") else {
              fatalError("Invalid URL")
          }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(cookie, forHTTPHeaderField: "Cookie")
        urlRequest.httpShouldHandleCookies = true
        return URLSession.shared.dataTaskPublisher(for: urlRequest).map { $0.data }
        .decode(type: Status.self, decoder: JSONDecoder())
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func getCharge(cookie: String, vehicle: String) -> AnyPublisher<Charge,Error> {
        
        guard let url = URL(string: "https://api.openvehicles.com:6869/api/charge/\(vehicle)") else {
              fatalError("Invalid URL")
          }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(cookie, forHTTPHeaderField: "Cookie")
        urlRequest.httpShouldHandleCookies = true
          return URLSession.shared.dataTaskPublisher(for: urlRequest).map { $0.data }
          .decode(type: Charge.self, decoder: JSONDecoder())
          .receive(on: RunLoop.main)
          .eraseToAnyPublisher()
    }
    
    func getLocation(cookie: String, vehicle: String) -> AnyPublisher<Location,Error> {
        
        guard let url = URL(string: "https://api.openvehicles.com:6869/api/location/\(vehicle)") else {
              fatalError("Invalid URL")
          }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(cookie, forHTTPHeaderField: "Cookie")
        urlRequest.httpShouldHandleCookies = true
          return URLSession.shared.dataTaskPublisher(for: urlRequest).map { $0.data }
          .decode(type: Location.self, decoder: JSONDecoder())
          .receive(on: RunLoop.main)
          .eraseToAnyPublisher()
    }
    
    func getVehicles(cookie: String) -> AnyPublisher<[Vehicle],Error> {
    
    guard let url = URL(string: "https://api.openvehicles.com:6869/api/vehicles/") else {
          fatalError("Invalid URL")
      }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(cookie, forHTTPHeaderField: "Cookie")
        urlRequest.httpShouldHandleCookies = true
      
      return URLSession.shared.dataTaskPublisher(for: urlRequest).map { $0.data }
      .decode(type: [Vehicle].self, decoder: JSONDecoder())
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
    }
    
    func getVehicle(cookie: String, vehicle: String) -> AnyPublisher<VehicleInfo,Error> {

    guard let url = URL(string: "https://api.openvehicles.com:6869/api/vehicle/\(vehicle)/") else {
          fatalError("Invalid URL")
      }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(cookie, forHTTPHeaderField: "Cookie")
        urlRequest.httpShouldHandleCookies = true
      return URLSession.shared.dataTaskPublisher(for: urlRequest).map { $0.data }
      .decode(type: VehicleInfo.self, decoder: JSONDecoder())
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
    }
}
