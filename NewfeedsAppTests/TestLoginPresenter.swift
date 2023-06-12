//
//  TestLoginPresenter.swift
//  NewfeedsAppTests
//
//  Created by Minh Tan Vu on 05/06/2023.
//

import Foundation
import Quick
import Nimble
import Mockingbird

@testable import NewfeedsApp

class TestLoginPresenter: QuickSpec {
    override class func spec() {
        describe("Login") {
            /**
             Step 1:  Declare an instance of LoginPresenter
             */
            var sut: LoginPresenter!
            
            ///Declare an instance of LoginDisplay
            var loginDisplayMock: LoginDisplayMock!
            
            /**
             Will run before each test case
             */
            beforeEach {
                loginDisplayMock = mock(LoginDisplay.self)
                sut = LoginPresenterImpl(loginVC: loginDisplayMock, authRepository: AuthRepositoryImpl(authAPIService: AuthAPIServiceImpl()))
            }
            
            /**
             Group test cases
             */
            context("Login form validate") {
                it("Check username empty") {
                    /**
                     input: empty username
                     action: .login(username, password)
                     expect: show user an error message : "Username is required"
                     */
                    let username = ""
                    
                    //Action
                    sut.login(username: username, password: "testPassword")
                    
                    //Expect
                    verify(loginDisplayMock.validateFailure(message: "Username is required")).wasCalled()
                    
                }
                it("Check password empty") {
                    let password = ""
                    sut.login(username: "testUsername", password: password)
                    verify(loginDisplayMock.validateFailure(message: "Password is require")).wasCalled()
                }
                
                
            }
        }
    }
}
