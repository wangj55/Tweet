//
//  TweetViewController.swift
//  Twitter
//
//  Created by Ji Wang on 3/16/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var tweetText: UITextView!
    @IBOutlet var tweetButton: UIBarButtonItem!
    @IBOutlet var wordCountLabel: UILabel!
    let characterLimit: Int = 280
    var twitterBlue: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedTweet()
        tweetText.becomeFirstResponder()
        tweetText.delegate = self
        wordCountLabel.text = "\(tweetText.text.count)/\(characterLimit)"
        twitterBlue = wordCountLabel.textColor
    }

    @IBAction func cancel(_ sender: Any) {
        saveTweet()
    }

    /// Post tweet.
    @IBAction func tweet(_ sender: Any) {
        if !tweetText.text.isEmpty {
            TwitterAPICaller.client?.postTweet(tweetString: tweetText.text, success: {
                // flush saved tweet text
                if UserDefaults.standard.object(forKey: "tweetText") != nil {
                    UserDefaults.standard.removeObject(forKey: "tweetText")
                }

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

    /// Manages the word limit of tweet.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = NSString(string: textView.text).replacingCharacters(in: range, with: text)
        wordCountLabel.text = "\(newText.count)/\(characterLimit)"
        wordCountLabel.textColor = newText.count == characterLimit ? .red : self.twitterBlue
        return newText.count < characterLimit
    }

    /// Pop up an alert and save the current tweet that is not finished if it is not empty.
    func saveTweet() {
        if !tweetText.text.isEmpty {
            let saveAlert = UIAlertController(title: "Save Tweet", message: "Do you want to save this tweet as draft?", preferredStyle: UIAlertController.Style.alert)

            saveAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                UserDefaults.standard.set(self.tweetText.text, forKey: "tweetText")
                self.dismiss(animated: true, completion: nil)
            }))

            saveAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))

            view.endEditing(true)
            present(saveAlert, animated: true, completion: nil)
        }
    }

    /// Load tweet content if saved last time.
    func loadSavedTweet() {
        let savedText = UserDefaults.standard.string(forKey: "tweetText") ?? ""
        if !savedText.isEmpty {
            tweetText.text = savedText
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
