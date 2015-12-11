//
//  ViewController.swift
//  ILYIFB
//
//  Created by Tsai Cheng Heng on 2015/12/1.
//  Copyright © 2015年 Tsai Cheng Heng. All rights reserved.
//

import UIKit
//import AeroGearHttp

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

//    @IBOutlet weak var FB_LoginButton: FBSDKLoginButton!
    
    @IBOutlet weak var Google_LoginButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        GIDSignIn.sharedInstance().uiDelegate = self
//        Google_LoginButton.delegate = self
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
        } else {
         
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile","email","user_friends"]
            loginView.delegate = self
            
            /*
            FB_LoginButton.readPermissions = ["public_profile","email","user_friends"]
            
            */
        }
        
        
    }

    @IBAction func LoginFromFacebook(sender: UIButton) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
       
        fbLoginManager.logInWithReadPermissions([], fromViewController: self) { (result, error) -> Void in
            
            if error == nil {
                
                let fbLoginResult : FBSDKLoginManagerLoginResult = result
                
                if (!fbLoginResult.isCancelled) {
                    
                    if (fbLoginResult.grantedPermissions.contains("email")) {
                        
                        // Do work
                        self.returnUserData()
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Facebook Delegate Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        print("User Logged In")
        
        if  error != nil {
            
            // process error
            print("Error : \(error)")
            
        } else if result.isCancelled {
            
            // Handle cancellations
            print("User Cancel Login")
            
        } else {
            
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            
            if result.grantedPermissions.contains("email")
            {
                // Do work
                self.returnUserData()
            }
            
            /*
            print("fetched user: \(result)")
            
            let userName : NSString = result.valueForKey("name") as! NSString
            print("User Name is: \(userName)")
            let userEmail : NSString = result.valueForKey("email") as! NSString
            print("User Email is: \(userEmail)")
            */
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        print("User Logged Out")
    }
    
    func returnUserData() {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
        
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            
            if  error != nil {
                
                // Process Error
                print("Error: \(error)")
                
            } else {
                
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is:\(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is:\(userEmail)")
            }
        }
    }
    
    @IBAction func SignInWithGoogle(sender: AnyObject) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!,
        presentViewController viewController: UIViewController!) {
            self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
        dismissViewController viewController: UIViewController!) {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
}

