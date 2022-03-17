//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Ji Wang on 3/13/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var tweetTextLabel: UILabel!
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!

    var tweetId: Int = -1

    var favorited: Bool = false
    var retweeted: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func retweet(_ sender: Any) {
        if !retweeted {
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
                self.retweeted = true
            }, failure: { error in
                print("Retweet failed.")
                print(error.localizedDescription)
            })
        } else {
            TwitterAPICaller.client?.unretweet(tweetId: tweetId, success: {
                self.retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
                self.retweeted = false
            }, failure: { error in
                print("Retweet failed.")
                print(error.localizedDescription)
            })
        }
    }

    @IBAction func favoriteTweetButtonClicked(_ sender: Any) {
        if !favorited {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
                self.favorited = true
            }, failure: { (error: Error) in
                print("FavoriteTweet failed.")
                print(error.localizedDescription)
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
                self.favorited = false
            }, failure: { (error: Error) in
                print("UnfavoriteTweet failed.")
                print(error.localizedDescription)
            })
        }
    }
}
