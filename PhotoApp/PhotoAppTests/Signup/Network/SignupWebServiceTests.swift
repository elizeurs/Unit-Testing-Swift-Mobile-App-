//
//  SignupWebServiceTests.swift
//  PhotoAppTests
//
//  Created by Elizeu RS on 29/07/22.
//

import XCTest
@testable import PhotoApp

class SignupWebServiceTests: XCTestCase {
  
  var sut: SignupWebService!
  var signFormRequestModel: SignupFormRequestModel!
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    let urlSession = URLSession(configuration: config)
    sut = SignupWebService(urlString: SignupConstants.signupURLString, urlSession: urlSession)
    signFormRequestModel = SignupFormRequestModel(firstName: "Sergey", lastName: "Kargopolov", email: "test@test.com", password: "12345678")
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    // becauser you created the objects inside setup, you need to release those resources inside tearDown
    sut = nil
    signFormRequestModel = nil
    // need to reset this stabResponseDate, 'cause it's a static one.
    MockURLProtocol.stubResponseData = nil
    MockURLProtocol.error = nil
  }
  
  func testSignupWebService_WhenGivenSuccessfullResponse_ReturnsSuccess() {
    
    // Arrange
    let jsonString = "{\"status\":\"ok\"}"
    MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
    
    let expectation = self.expectation(description: "Signup Web Service Response Expectation")
    
    // Act
    sut.signup(withForm: signFormRequestModel) { (signupResponseModel, error) in
      
      // Assert
      //"{\"status\":\"ok\"}"
      XCTAssertEqual(signupResponseModel?.status, "ok")
      expectation.fulfill()
    }
    
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testSignupWebService_WhenReceivedDifferentJSONResponse_ErrorTookPlace() {
    // Arrange
    let jsonString = "{\"path\":\"/users\", \"error\":\"Internal Server Error\"}"
    MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
    
    let expectation = self.expectation(description: "Signup() method expectation for a response that contains a different JSON structure")
    
    // Act
    sut.signup(withForm: signFormRequestModel) { (signupResponseModel, error) in
      
      // Assert
      XCTAssertNil(signupResponseModel, "The response model for a request containing unknown JSON response, should have been nil")
      XCTAssertEqual(error, SignupError.invalidResponseModel, "The signup() method did not return expected error")
      expectation.fulfill()
    }
    
    self.wait(for: [expectation], timeout: 5)
  }
  
  func testSignupWebservice_WhenEmptyURLStringProvided_ReturnsError() {
    
    // Arrange
    let expectation = self.expectation(description: "An empty request URL string expectation")
    
    sut = SignupWebService(urlString: "")
    
    // Act
    sut.signup(withForm: signFormRequestModel) { (signupResponseModel, error) in
      
      // Assert
      XCTAssertEqual(error, SignupError.invalidRequestURLString, "The signup() method did not return an expected error for an invalidRequestURLString error")
      // add one more assertion, to make sure the signup assertion response model here is nill. signupResponseModel is the SignupResponseModel object.
      XCTAssertNil(signupResponseModel, "When an invalidRequestURLString takes place, the response model must be nil")
      // i want this expectation to fulfill only inside of my signup method closure.
      expectation.fulfill()
    }
    
    self.wait(for: [expectation], timeout: 2)
  }
  
  func testSignupWebService_WhenURLRequestFails_ReturnsErrorMessageDescription() {
    
    // Arrange
    let expectation = self.expectation(description: "A failed Request expectation")
    let errorDescription = "A localized description of an error"
    
    // lesson 55
    // XCTAssertEqual failed: ("Optional(PhotoApp.SignupError.failedRequest(description: "The operation couldn’t be completed. (PhotoApp.SignupError error 0.)"))") is not equal to ("Optional(PhotoApp.SignupError.failedRequest(description: "A localized description of an error"))")
    //    MockURLProtocol.error = SignupError.failedRequest(description: errorDescription)
    MockURLProtocol.error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription])
    
    
    // Act
    sut.signup(withForm: signFormRequestModel) { (signupResponseModel, error) in
      // Assert
      XCTAssertEqual(error, SignupError.failedRequest(description: errorDescription), "The signup method did not return an expecter error for the Failed Request")
      //      XCTAssertEqual(error?.localizedDescription, errorDescription)
      expectation.fulfill()
    }
    
    self.wait(for: [expectation], timeout: 2)
  }
}
