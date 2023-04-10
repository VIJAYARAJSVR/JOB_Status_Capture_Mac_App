//
//  JOB_Status_CaptureApp.swift
//  JOB_Status_Capture
//
//  Created by Web_Dev on 4/10/23.
//

import SwiftUI

@main
struct JOB_Status_CaptureApp: App {
    var body: some Scene {
        WindowGroup {
            MainView() .frame(minWidth: 800, idealWidth: 800, maxWidth: 800,
                              minHeight: 950, idealHeight: 950, maxHeight: 950,
                              alignment: .center)
        }
    }
}
