//
//  SignUpViewController.swift
//  customLogin
//
//  Created by Choyunje on 2021/09/16.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        
    }
    
    func setUpElements() {
        
        // 에러 레이블 숨기기
        errorLabel.alpha = 0
        
        
        // 요소들 스타일 입히기.
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        
        
        
    }
    
// 필드와 필드의 유효성 데이터가 올바른지 확인하고 만약 모든것이 맞을 때 이 메소드는 nil을 반환하고 그렇지 않으면 오류메세지를 스트링 형식으로 반환합니다.
    func validateFields() -> String? {
        // 모든 필드가 올바르게 채워져있는지 확인합니다.
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "모든 필드를 입력하십시오."
        }
        
        // 암호가 안전한지 확인합니다.
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // 비밀번호가 충분히 안전하지 않습니다.
            return "비밀번호가 최소 8자 이상이여야 하고 특수문자와 숫자를 포함해야합니다."
        }
        
        return nil
    }

    
    
    @IBAction func signUpTapped(_ sender: Any) {
        // 필드의 유효성 검사하기
            let error = validateFields()
        if error != nil {
            // 필드가 뭔가 잘못된 에러라는 에러 메세지가 생성됩니다
         showError(error!)
            
        }else{
            // Create cleand vesions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // 사용자 생성하기
            Auth.auth().createUser(withEmail: email, password: password) { (result, err)  in
                // 에러 확인하기
                if err != nil {
                    
                    // 사용자 생성중 에러가 발생했습니다
                    self.showError("사용자 생성중에 에러가 발생했습니다.")
                    
                }else{
                    // 사용자 생성이 성공적으로 이루어졌으며 이름과 성을 저장
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "uid": result!.user.uid ]) { (error) in
                        
                        if error != nil {
                            // 에러 메세지 창 보여주기
                            self.showError("사용자 데이터를 저장하는중에 오류가 발생했습니다.")
                        }
                    }
                    // 홈화면으로 전환하기
                    self.transitionToHome()
                    
                }
            }
            
            
        }
    
        
        
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    func transitionToHome() {
        let homeViewController =
        storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?
        HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }

}

