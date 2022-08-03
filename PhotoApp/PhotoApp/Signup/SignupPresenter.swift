//
//  SignupPresenter.swift
//  PhotoApp
//
//  Created by Elizeu RS on 03/08/22.
//

import Foundation

class SignupPresenter {
  
  private var formModelValidator: SignupModelValidatorProtocol
  
  init(formModelValidator: SignupModelValidatorProtocol) {
    self.formModelValidator = formModelValidator
  }
  
  func processUserSignup(formModel: SignupFormModel) {
    
    if !formModelValidator.isFirstNameValid(firstName: formModel.firstName) {
      return
    }
    
    if !formModelValidator.isLastNameValid(lastName: formModel.lastName) {
      return
    }
    
    if !formModelValidator.isValidEmailFormat(email: formModel.email) {
      return
    }
    
    if  !formModelValidator.isPasswordValid(password: formModel.email) {
      return
    }
    
    if !formModelValidator.doPasswordsMatch(password: formModel.password, repeatPassword: formModel.repeatPassword) {
      return
    }
  }
}
