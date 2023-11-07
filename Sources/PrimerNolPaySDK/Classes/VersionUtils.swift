//
//  VersionUtils.swift
//  PrimerNolPaySDK
//
//  Created by Boris on 7.11.23..
//

import Foundation

struct VersionUtils {
    
    /**
     Returns the version string of the _wrapper_ sdk in the format `"major.minor.patch"`
     
     The version specified as `PrimerNolPayVersion` in the file `"sources/version.swift"` will be returned.
     */
    static var wrapperSDKVersionNumber: String {
        PrimerNolPayVersion
    }
    
    /**
     Returns the version string of the _wrapped_ sdk in the format `"major.minor.patch"`
     
     The version specified as `TransitSDKVersion` in the file `"sources/version.swift"` will be returned.
     */
    static var transitSDKVersionNumber: String {
        TransitSDKVersion
    }
}
