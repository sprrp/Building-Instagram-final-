//
//  FeedViewController.swift
//  Building Instagram
//
//  Created by Surendra Pandey on 10/15/20.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    let refresh = UIRefreshControl()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh.addTarget(self, action: #selector(viewDidAppear), for: .valueChanged)
        self.tableView.refreshControl = refresh
       
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit - 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post  = posts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.captionLabel.text = post["caption"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url  = URL(string: urlString)!
        
        cell.photoView.af_setImage(withURL: url)
        
        
        return cell
    }
    

    

}
