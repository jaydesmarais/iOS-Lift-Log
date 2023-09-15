//
//  LoginSettings.swift
//  LiftLog
//
//  Created by Jay Desmarais on 5/1/23.
//

import Foundation
import HealthKit

@MainActor class LoginSettings: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var hasRequestedHealthData: Bool = true
    @Published var healthStore = HKHealthStore()
    @Published var allTypes = Set([HKObjectType.workoutType(),
                        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                        HKObjectType.quantityType(forIdentifier: .heartRate)!])

    func getHealthAuthorizationRequestStatus() {
        print("Checking HealthKit authorization status...")
        
        if !HKHealthStore.isHealthDataAvailable() {
            return
        }
        
        self.healthStore.getRequestStatusForAuthorization(toShare: self.allTypes, read: self.allTypes) { (authorizationRequestStatus, error) in
            
            var status: String = ""
            if let error = error {
                status = "HealthKit authorization status request error: \(error.localizedDescription)"
            } else {
                switch authorizationRequestStatus {
                case .shouldRequest:
                    self.hasRequestedHealthData = false
                    status = "Authorization requested for all specified data types."
                case .unknown:
                    status = "Authorization request status could not be determined because an error occurred."
                case .unnecessary:
                    self.hasRequestedHealthData = true
                    status = "Authorization already requested for all specified data types."
                default:
                    break
                }
            }
            
            print(status)
        }
    }
    
    func requestHealthKitPermissions() {
        print("Requesting HealthKit authorization...")
        
        if !HKHealthStore.isHealthDataAvailable() {
            return
        }
        
        self.healthStore.requestAuthorization(toShare: self.allTypes, read: self.allTypes) { (success, error) in
            var status: String = ""
            
            if let error = error {
                status = "HealthKit Authorization Error: \(error.localizedDescription)"
            } else {
                if success {
                    if self.hasRequestedHealthData {
                        status = "You've already requested access to health data."
                    } else {
                        status = "HealthKit authorization request was successful!"
                    }
                    
                    self.hasRequestedHealthData = true
                } else {
                    status = "HealthKit authorization did not complete successfully."
                }
            }
            
            print(status)
        }
    }
}
