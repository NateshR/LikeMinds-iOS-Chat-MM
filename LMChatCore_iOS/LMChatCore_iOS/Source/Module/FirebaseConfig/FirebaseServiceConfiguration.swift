//
//  FirebaseServiceConfiguration.swift
//  LikeMindsChat
//
//  Created by Pushpendra Singh on 18/07/22.
//

import Foundation
import FirebaseMessaging
import FirebaseCore
import FirebaseDatabase
import LikeMindsChat

struct FirebaseServiceConfiguration {
    
    private static let appName = "likemindschatsdk"
    
    static let firebaseDatabase: Database =  {
        // Retrieve a previous created named app.
        guard let secondary = FirebaseApp.app(name: appName)
        else {
            assert(false, "Could not retrieve secondary app")
            return Database.database()
        }
        // Retrieve a Real Time Database client configured against a specific app.
        return Database.database(app: secondary)
    }()
    
    static func setupFirebaseAppService() {
        switch BuildManager.environment {
        case .devtest:
            setupFirebaseBetaService()
            break
        case .production:
            setupFirebaseProdService()
            break
        default:
            break
        }
    }
    
   private static func setupFirebaseBetaService() {
        // Configure with manual options. Note that projectID and apiKey, though not
        // required by the initializer, are mandatory.
        let secondaryOptions = FirebaseOptions(
            googleAppID: "1:983690302378:ios:00ee53e9ab9afe851b91d3",
            gcmSenderID: "983690302378"
        )
//       secondaryOptions.apiKey = ServiceAPI.firebaseApiKey
        secondaryOptions.projectID = "collabmates-beta"
        // The other options are not mandatory, but may be required
        // for specific Firebase products.
        secondaryOptions.bundleID = "com.CollabMates.app.dev"
//        secondaryOptions.trackingID = "UA-12345678-1"
        secondaryOptions.clientID = "983690302378-0f07f2iljj54c6i5ics7u85609p2t6gm.apps.googleusercontent.com"
        secondaryOptions.databaseURL = "https://collabmates-beta.firebaseio.com"
        secondaryOptions.storageBucket = "collabmates-beta.appspot.com"
        secondaryOptions.androidClientID = "983690302378-4j1q89en4q1pj9m2icf3kq9p6gtckv1f.apps.googleusercontent.com"
//        secondaryOptions.deepLinkURLScheme = "myapp://"
        secondaryOptions.appGroupID = nil
        // Configure an alternative FIRApp.
        FirebaseApp.configure(name: appName, options: secondaryOptions)
    }
    
   private static func setupFirebaseProdService() {
        // Configure with manual options. Note that projectID and apiKey, though not
        // required by the initializer, are mandatory.
        let secondaryOptions = FirebaseOptions(
            googleAppID: "1:645716458793:ios:20c306a563c4c6ebac8b38",
            gcmSenderID: "645716458793"
        )
//        secondaryOptions.apiKey = ServiceAPI.firebaseApiKey
        secondaryOptions.projectID = "collabmates-3d601"
        // The other options are not mandatory, but may be required
        // for specific Firebase products.
        secondaryOptions.bundleID = "com.CollabMates.app"
//        secondaryOptions.trackingID = "UA-12345678-1"
        secondaryOptions.clientID = "645716458793-vbdei2ei981shj40sj49vl8kj48bnkia.apps.googleusercontent.com"
        secondaryOptions.databaseURL = "https://collabmates-3d601.firebaseio.com"
        secondaryOptions.storageBucket = "collabmates-3d601.appspot.com"
        secondaryOptions.androidClientID = "645716458793-90cjqh9pu7udf0r7heaa5dam2pambo3u.apps.googleusercontent.com"
//        secondaryOptions.deepLinkURLScheme = "myapp://"
        secondaryOptions.appGroupID = nil
        // Configure an alternative FIRApp.
        FirebaseApp.configure(name: appName, options: secondaryOptions)
    }
}
