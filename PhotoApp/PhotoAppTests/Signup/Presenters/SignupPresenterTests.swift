//
//  SignupPresenterTests.swift
//  PhotoAppTests
//
//  Created by Elizeu RS on 02/08/22.
//

import XCTest
@testable import PhotoApp

class SignupPresenterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
  
  func testSignupPresenter_WhenInformationProvided_WillValidateEachProperty() {
    // Arrange
    let signupFormModel = SignupFormModel(firstName: "Sergey",
                                          lastName: "Kargopolov",
                                          email: "test@test.com",
                                          password: "12345678",
                                          repeatPassword: "12345678")
    let mockSignupModelValidator = MockSignupModelValidator()
    let sut = SignupPresenter(formModelValidator: mockSignupModelValidator)
    
    // Act
    sut.processUserSignup(formModel: signupFormModel)
    
    // Assert
    XCTAssertTrue(mockSignupModelValidator.isFirstNameValidated, "First name was not validated")
    XCTAssertTrue(mockSignupModelValidator.isLastNameValidated, "Last name was not validated")
    XCTAssertTrue(mockSignupModelValidator.isEmailFormatValidated, "Email format was not validated")
    XCTAssertTrue(mockSignupModelValidator.isPasswordValidated, "Password was not validated")
    XCTAssertTrue(mockSignupModelValidator.isPasswordEqualityValidated, "Did not validate, if passwords match")
  }
  
  func testSignupPresenter_WhenGivenValidFormModel_ShouldCallSignupMethod()  {
    // Arrange
    let signupFormModel = SignupFormModel(firstName: "Sergey",
                                          lastName: "Kargopolov",
                                          email: "test@test.com",
                                          password: "12345678",
                                          repeatPassword: "12345678")
    
    let mockSignupModelValidator = MockSignupModelValidator()
    
    let mockSignupWebService = MockSignupWebService()
    
    // Act
    let sut = SignupPresenter(formModelValidator: mockSignupModelValidator)
    sut.processUserSignup(formModel: signupFormModel)
    
    // Assert
    XCTAssertTrue(mockSignupWebService.isSignupMethodCalled, "The signup() method was not called in the SignupWebService class")
  }
}
