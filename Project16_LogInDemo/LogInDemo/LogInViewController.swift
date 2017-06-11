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
  var user:User!
  
  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    addGradientForBackground()
    hideKeyboardWhenTappedAround()
    applyRadiusToButtons()
    changeLogInButtonImageTintColor()
    
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
        self.showAlertWith(message: "Log In Success")
        self.user = User(userInfo: user!)
        print(self.user.email)
        print(self.user.uid)
      }
      
    })
  }

  func showAlertWith(message:String) {
    
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { action in
      
    })
    alertController.addAction(okAction)
    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    alertController.addAction(cancelAction)
    
    self.present(alertController, animated: true, completion: nil)
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