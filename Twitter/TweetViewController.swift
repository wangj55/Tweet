//
//  TweetViewController.swift
//  Twitter
//
//  Created by Ji Wang on 3/16/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    @IBOutlet var tweetText: UITextView!
    @IBOutlet var tweetButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetText.becomeFirstResponder()
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func tweet(_ sender: Any) {
        if !tweetText.text.isEmpty {
            TwitterAPICaller.client?.postTweet(tweetString: tweetText.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error: Error) in
                print("Error when posting tweet \(error)")
            })
        } else {
            // TODO: Keep "Tweet" button disabled when content is empty.
            // https://stackoverflow.com/questions/34206648/how-to-disable-a-button-if-a-text-field-is-empty
            dismiss(animated: true, completion: nil)
        }
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
