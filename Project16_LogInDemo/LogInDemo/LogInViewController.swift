//
//  ViewController.swift
//  LogInDemo
//
//  Created by siwook on 2017. 6. 5..
//  Copyright © 2017년 siwook. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

// MARK : - Constants

struct Constants {
  static let OkActionTitle = "Ok"
  static let CancelActionTitle = "Cancel"
  static let LogInSuccessMessage = "Log In Success"
  static let PasswordLimitCount = 15
}

// MARK : - LogInViewController: UIViewController

class LogInViewController: UIViewController {

  // MARK : - Property 
  
  @IBOutlet weak var logInButton: UIButton!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var emailCheckerImageView: UIImageView!
  @IBOutlet weak var passwordCheckerImageView: UIImageView!
  @IBOutlet weak var facebookLogInButton: UIButton!
  @IBOutlet weak var googleLogInButton: UIButton!
  
  let color1 = UIColor(colorLiteralRed: 2/255, green: 124/255, blue: 136/255, alpha: 1.0) // 027C88
  let color2 = UIColor(colorLiteralRed: 4/255, green: 162/255, blue: 151/255, alpha: 1.0) // 04A297
  let inputValidator = InputValidator()
  var user:User!
  var emailValidateResult = false
  var passwordValidateResult = false
  
  
  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    addGradientForBackground()
    hideKeyboardWhenTappedAround()
    applyRadiusToButtons()
    changeLogInButtonImageTintColor()
    setCheckImageViewHiddenStatus()
    
  }
  
  func setCheckImageViewHiddenStatus() {
    emailCheckerImageView.isHidden = true
    passwordCheckerImageView.isHidden = true
  }
  
  func changeLogInButtonImageTintColor() {
    
    let image = logInButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
    logInButton.imageView?.image = image
    logInButton.imageView?.tintColor = color2
    
  }
  
  func applyRadiusToButtons() {
    
    logInButton.layer.cornerRadius = logInButton.frame.width/2
    logInButton.layer.masksToBounds = true
    
    facebookLogInButton.layer.cornerRadius = facebookLogInButton.frame.size.height/2
    googleLogInButton.layer.cornerRadius = googleLogInButton.frame.size.height/2
  }
  
  func addGradientForBackground() {
    
    let gradientLayer = CAGradientLayer()
    
    gradientLayer.frame = self.view.bounds
    gradientLayer.colors = [color1.cgColor,color2.cgColor]
    gradientLayer.startPoint = CGPoint(x:1, y:1)
    gradientLayer.endPoint = CGPoint(x:0, y:1)
    
    self.view.layer.insertSublayer(gradientLayer, at: 0)
    
  }
  
  // MARK : - Target Actions 
  
  @IBAction func tappedLogInButton(_ sender: UIButton) {
  
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    view.addSubview(activityIndicator)
    activityIndicator.center = view.center
    activityIndicator.startAnimating()
    
    FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!,completion: { (user, error) in
      
      activityIndicator.removeFromSuperview()
      
      if error != nil {
        self.showAlertWith(message: (error?.localizedDescription)!)
      } else {
        self.showAlertWith(message: Constants.LogInSuccessMessage)
        self.user = User(userInfo: user!)
      }
    })
  }

  // MARK : - Show Alert Message
  
  func showAlertWith(message:String) {
    
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: Constants.OkActionTitle, style: .default, handler: { action in
      
    })
    alertController.addAction(okAction)
   
    self.present(alertController, animated: true, completion: nil)
  }
}

// MARK : - LogInViewController : UITextFieldDelegate 

extension LogInViewController : UITextFieldDelegate {
  
  // MARK : - UITextFieldDelegate Delegate Methods
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let textFieldText: NSString = (textField.text ?? "") as NSString
    let textAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
   
    if textField == emailTextField {
      validateEmail(text:textAfterUpdate)
    } else if textField == passwordTextField {
  
      guard textAfterUpdate.characters.count <= Constants.PasswordLimitCount else {
        return false
      }
      validatePassword(text:textAfterUpdate)
    }
    
    setButtonStatusBasedOnValidateResult(validationResult: (emailValidateResult, passwordValidateResult))
    
    return true
  }
  
  func validateEmail(text:String) {
    emailValidateResult = inputValidator.validateEmail(text: text)
    emailCheckerImageView.isHidden = !emailValidateResult
  }
  
  func validatePassword(text:String) {
    passwordValidateResult = inputValidator.validatePassword(text: text)
    passwordCheckerImageView.isHidden = !passwordValidateResult
  }
  
  func setButtonStatusBasedOnValidateResult(validationResult:(email:Bool,password:Bool)) {
    
    if validationResult.email && validationResult.password {
      logInButton.isEnabled = true
      logInButton.backgroundColor = UIColor.white
    } else {
      logInButton.isEnabled = false
      logInButton.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    }
  }
}

// MARK : - LogInViewController Extension

extension LogInViewController {
  
  func hideKeyboardWhenTappedAround() {
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.dismissKeyboard))
    view.addGestureRecognizer(tapRecognizer)
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
}
