//
//  CuotasModuleLandingModels.swift
//  Pods
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

enum CuotasModuleLanding {

    enum Basic {
        struct Request { }
        struct Response {
            let title: String
            let subtitle: String
        }
        struct ViewModel {
            let title: String
            let subtitle: String
        }
    }
}
