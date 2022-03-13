//
//  LoginViewController.swift
//  Twitter
//
//  Created by Ji Wang on 3/13/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let loginUrl = "https://api.twitter.com/oauth/request_token"
        
        
        TwitterAPICaller.client?.login(url: loginUrl, success: {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { _ in
            print("Could not login")
        })
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
