//
//  ViewController.swift
//  IOS Exercise
//
//  Created by YOUSEF ALKHALIFAH on 21/08/1439 AH.
//  Copyright © 1439 YOUSEF ALKHALIFAH. All rights reserved.
//

import UIKit

struct jsonObject: Decodable {
     let articles: [Article]
}

class Article: Decodable {
    let title: String
    let content: String
    let image_url: String
    let website: String
    let authors: String
    let date: String
    let tags: [Tags]
}

class Tags: Decodable {
    let id: Int
    let label: String
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var articles: [Article] = []
    var detailedVC: DetailedViewController? = nil
    
    // lazy load so we don't take lots of memory initially
    lazy var refreshControl: UIRefreshControl = {
         let refreshControl = UIRefreshControl()
         refreshControl.backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
         refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
         return refreshControl
    }()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)

        getData()

        //assign the delegate and datasiuce to the tableview
        tableView.delegate = self
        tableView.dataSource = self
        

        tableView.refreshControl = refreshControl
        
        detailedVC = DetailedViewController()
    }
    
    @objc
    func onRefresh(){
        getData()
        refreshControl.endRefreshing()
    }
    
    func getData() {
        let jsonUrlString = "https://no89n3nc7b.execute-api.ap-southeast-1.amazonaws.com/staging/exercise"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // check response status is 200
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode != 200){
                    print("error \(httpResponse.statusCode)")
                    return
                }
            }
            
            guard let data = data else { return }
            do{
                let json =  try JSONDecoder().decode(jsonObject.self, from: data)
                if(self.articles.count > 0){// has data, means was called on refresh
                    self.articles.removeAll()
                }
                
                self.articles = json.articles
                
                // validate the data
                self.validateData()
                
                // update the tableView from the main thread after fetching the data.
                DispatchQueue.main.async() {
                    self.tableView.reloadData()
                }
                
            } catch let jsonErr {
                print("json error \(jsonErr)")
            }
            }.resume()
    }

    func validateData() {
        for (i,_) in articles.enumerated().reversed() {
            if articles[i].title == "" { // i shoul also check for the content
                articles.remove(at: i)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell

        cell.title.text = articles[indexPath.row].title
        cell.postImage.image =  UIImage(named: "placeholder")
        let imageURL = articles[indexPath.row].image_url
        if imageURL != "" {
             let url = URL(string: imageURL)
             cell.postImage.downloadImageFrom(url: url!, contentMode: UIViewContentMode.scaleToFill)
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedViewController") as? DetailedViewController
        {
            let cell = self.tableView.cellForRow(at: indexPath) as! CustomTableViewCell
            vc.postTitle = articles[indexPath.row].title
            vc.content = articles[indexPath.row].content
            vc.image = cell.postImage.image
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

}
// an extension to lazy load the images
extension UIImageView {
    func downloadImageFrom(url: URL, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask( with: url, completionHandler: {
            (data, response, error) -> Void in
           DispatchQueue.main.async() {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}

