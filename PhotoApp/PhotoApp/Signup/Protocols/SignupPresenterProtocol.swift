//
//  SignupPresenterProtocol.swift
//  PhotoApp
//
//  Created by Elizeu RS on 08/08/22.
//

import Foundation

protocol SignupPresenterProtocol: AnyObject {
  init(formModelValidator: SignupModelValidatorProtocol, webservice: SignupWebServiceProtocol, delegate: signupViewDelegateProtocol)
  func processUserSignup(formModel: SignupFormModel)
}
