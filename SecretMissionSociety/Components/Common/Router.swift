//
//  Router.swift
//  HalaMotor
//
//  Created by mac on 22/08/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

enum Router: String {
    
    static let BASE_SERVICE_URL = "http://appsmsjuegos.com/Quiz/webservice/"
    static let BASE_IMAGE_URL = "https://appsmsjuegos.com/uploads/images/"
    
    case logIn
    case signUp
    case get_term_conditions
    case forgot_password
    case get_profile
    case update_profile
    case get_banner
    case get_event
    case event_apply_code


    public func url() -> String {
        switch self {
        case .logIn:
            return Router.oAuthRoute(path: "login?")
        case .signUp:
            return Router.oAuthRoute(path: "signup?")
        case .get_term_conditions:
            return Router.oAuthRoute(path: "get_term_conditions")
        case .forgot_password:
            return Router.oAuthRoute(path: "forgot_password")
        case .get_profile:
            return Router.oAuthRoute(path: "get_profile")
        case .update_profile:
            return Router.oAuthRoute(path: "update_profile")
        case .get_banner:
            return Router.oAuthRoute(path: "get_banner")
        case .get_event:
            return Router.oAuthRoute(path: "get_event")
        case .event_apply_code:
            return Router.oAuthRoute(path: "event_apply_code")

        }
    }
    
    private static func oAuthRoute(path: String) -> String {
        return Router.BASE_SERVICE_URL + path
    }
    
}
