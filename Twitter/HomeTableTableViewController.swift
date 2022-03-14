//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Ji Wang on 3/13/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!

    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfTweets = 20
        loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func loadTweets() {
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]

        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String: Any], success: { (tweets: [NSDictionary]) in

            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            
            // stop refreshing since tweets are loaded
            if self.myRefreshControl.isRefreshing {
                self.myRefreshControl.endRefreshing()
            }

        }, failure: { error in
            print(error.localizedDescription)
            print("Could not retrieve tweets!")
        })
    }

    @objc func loadMoreTweets() {
        numberOfTweets += 20
        loadTweets()
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn") // update login/logout status
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell

        let tweet = tweetArray[indexPath.row]
        let user = tweet["user"] as! NSDictionary
        let profileImageUrl = URL(string: (user["profile_image_url_https"] as? String)!)

        cell.userNameLabel.text = user["name"] as? String
        cell.tweetTextLabel.text = tweet["text"] as? String
        if let imageData = try? Data(contentsOf: profileImageUrl!) {
            cell.profileImageView.image = UIImage(data: imageData)
        }

        return cell
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == numberOfTweets {
            loadMoreTweets()
        }
    }
}
