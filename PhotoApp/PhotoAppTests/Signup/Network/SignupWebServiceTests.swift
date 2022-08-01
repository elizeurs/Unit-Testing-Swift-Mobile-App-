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
      XCTAssertEqual(error, SignupErrors.responseModelParsingError, "The signup() method did not return expected error")
      expectation.fulfill()
    }
    
    self.wait(for: [expectation], timeout: 5)
  }
}
