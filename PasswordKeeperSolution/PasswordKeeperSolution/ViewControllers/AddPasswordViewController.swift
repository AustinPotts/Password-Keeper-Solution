//
//  AddPasswordViewController.swift
//  PasswordKeeperSolution
//
//  Created by Austin Potts on 11/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AddPasswordViewController: UIViewController {

    var password: Password?
    var passwordController: PasswordController?
    
    
    @IBOutlet weak var websiteTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    

    
    
    @IBAction func save(_ sender: Any) {
        
        guard let website = websiteTextField.text,
            let passwordString = passwordTextField.text,
            !website.isEmpty else {return}
        
        if let password = password{
            passwordController?.updatePassword(password: password, with: website, passwordString: passwordString)
        } else {
            passwordController?.createPassword(with: website, passwordString: passwordString, context: CoreDataStack.share.mainContext)
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    
    func updateViews(){
        title = password?.website ?? "Add Password"
        
        websiteTextField.text = password?.website
        passwordTextField.text = password?.passwordString
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
