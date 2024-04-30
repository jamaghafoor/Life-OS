//
//  DemoView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 05/01/24.
//

import SwiftUI
import _AuthenticationServices_SwiftUI


struct AuthView: View {
    var body: some View {
        SignInWithAppleButton(.continue) { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(_):
                print("Authorisation successful")
            case .failure(let error):
                print("Authorisation failed: \(error.localizedDescription)")
            }
        }
        // black button
        .signInWithAppleButtonStyle(.black)
        // white button
        .signInWithAppleButtonStyle(.white)
        // white with border
        .signInWithAppleButtonStyle(.whiteOutline)
    }
    
}

#Preview {
    AuthView()
}
