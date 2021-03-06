//
//  SignUpViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christopher Chu on 7/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField! //username
    
    @IBOutlet weak var passwordTextField: UITextField! //password
    
    @IBOutlet weak var studentOrParent: UISwitch! //switch deciding whether user is a student of parent
    
    @IBOutlet weak var profilePicture: UIImageView! //the user's profile picture
    
    @IBOutlet weak var phoneNumber: UITextField!
    
     var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView() //sets up activity indicator
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //set the text fields to modify to belong to this particular view controller
        usernameTextField.delegate = self
        passwordTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "backFromSignUp", sender: self)
    }
    
    
    @IBAction func uploadProfilePicture(_ sender: Any) {
        activityIndicator.center = self.view.center //center of view controller
        activityIndicator.hidesWhenStopped = true //gets rid of indicator when page is ready
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white //sets the color of the activity indicator to gray
        view.addSubview(activityIndicator) //adds the activity indicator to the view
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents() //prevents the user from interacting with the screen
        let imagePicker = UIImagePickerController() //sets up in image picker so the user picks profile picture from his/her photo
                                                    //library
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil) //present the image controller
        self.activityIndicator.stopAnimating()// if there is no error, stop animating the wait button
        //and move on to the next window.
        UIApplication.shared.endIgnoringInteractionEvents() //allow the user to interact with the screen again
    }
    
    
    /*
     Method that decides what to do once the user finishes picking profile picture
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            profilePicture.image = image //set the camera roll image to the profile image
        }
        
        self.dismiss(animated: true, completion: nil) //get rid of the image picker controller
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
        
        activityIndicator.center = self.view.center //center of view controller
        activityIndicator.hidesWhenStopped = true //gets rid of indicator when page is ready
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray //sets the color of the activity indicator to gray
        view.addSubview(activityIndicator) //adds the activity indicator to the view
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents() //prevents the user from interacting with the screen
        
        let user = PFUser() //attempt create a new user
        
        //username and password are in their respective text boxes
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        
        user.signUpInBackground(block: { (user, error) in //try to sign up the user
            if error != nil{
                self.activityIndicator.stopAnimating() //if there is an error, allow the user to try again
                // self.createAlert(title: "Error", message: "Cannot Log In.")
                UIApplication.shared.endIgnoringInteractionEvents() 
            } else {
                
                PFUser.current()?["phoneNumber"] = self.phoneNumber.text
                
                PFUser.current()?["isFemale"] = self.studentOrParent.isOn //upload the is student/parent information on the parse server
                
              let imageData = UIImageJPEGRepresentation(self.profilePicture.image!, 0.5)
              PFUser.current()?["profilePicture"] = PFFile(name: "PhotoBooth.png", data: imageData!) //saves the profile picture of the user in the parse server
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if error != nil{
                        self.createAlert(title: "Error", message: "Failed to Save Form") //if there is an error saving the picture or info, display a notification
                    } else {
                        print("Data Saved.") //debugger
                        self.performSegue(withIdentifier: "signUpFinished", sender: self) //if all the data is saved correctly, move to the welcome user screen
                        self.activityIndicator.stopAnimating() //if there is an error, allow the user to try again
                       // self.createAlert(title: "Error", message: "Cannot Log In.")
                        UIApplication.shared.endIgnoringInteractionEvents() //allow the user to interact with the screen again
                        //self.createAlert(title: "Success", message: "User signed up")
                    }
                })
            }
            
            })
        
        
        
    }
    
    /*
     This create alert method presents an alert with a title presented on the top and message on the bottom,
     usually for errors.
     */
    
    func createAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil) //bottom button of the alert for the user to dismiss
        }))
        
        self.present(alert, animated: true, completion: nil) //actually present (pop out) the notification when needed
        
    }
    /*
     The next two functions simply dismiss the username and password keyboard when return is hit.
 */
    
    func dismissKeyboard(){
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder() //dismissess all the text fields
        phoneNumber.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        passwordTextField.resignFirstResponder() //dismissess all the text fields
        phoneNumber.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder() //dismissess all the text fields
        phoneNumber.resignFirstResponder() //resigns the request text field when the screen is touched
    }

}
