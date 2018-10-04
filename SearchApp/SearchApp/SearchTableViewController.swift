//
//  SearchTableViewController.swift
//  SearchApp
//
//  Created by Mac on 10/1/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

struct ItunesApp:Decodable{
    let artworkUrl100:String
    let trackName: String
    let sellerName:String
    let formattedPrice: String
    let kind:String
    let primaryGenreName: String
    
}

struct Response: Decodable{
    var resultCount: Int
    var results: [ItunesApp]
}

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    //MARK: INFO SCREEN
    @IBOutlet var inforView: UIView!
    @IBOutlet weak var inforImage: UIImageView!
    @IBOutlet weak var inforName: UILabel!
    @IBOutlet weak var inforType: UILabel!
    @IBOutlet weak var inforGenre: UILabel!
    @IBOutlet weak var inforCompany: UILabel!
    @IBOutlet weak var inforPrice: UILabel!
    
    
    let endpoint="https://itunes.apple.com/search"
    let limit=200
    let entity="software"
    var filteredArray = [ItunesApp]()
    var shouldShowSearchResults = false
    var appData = [ItunesApp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        inforView.layer.cornerRadius = 10
        inforView.layer.masksToBounds = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func createSearchBar(){
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter your search"
        searchBar.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if shouldShowSearchResults {
            let imageData:NSData = NSData(contentsOf: URL(string: filteredArray[indexPath.row].artworkUrl100)!)!
            let image = UIImage(data: imageData as Data)
            cell.textLabel?.text = filteredArray[indexPath.row].trackName
            cell.detailTextLabel?.text = filteredArray[indexPath.row].sellerName
            cell.imageView?.image = image
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filteredArray.count
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    searchBar.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = filteredArray[indexPath.row]
        let imageData:NSData = NSData(contentsOf: URL(string: filteredArray[indexPath.row].artworkUrl100)!)!
        let image = UIImage(data: imageData as Data)
        inforImage.image=image!
        inforName.text=data.trackName
        inforCompany.text=data.sellerName
        inforType.text=data.kind
        inforGenre.text=data.primaryGenreName
        inforPrice.text=data.formattedPrice
        inforView.center=view.center
        view.addSubview(inforView)
    }
    
    @IBAction func closeInforPopUp(_ sender: UIButton) {
        inforView.removeFromSuperview()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        shouldShowSearchResults = true
        searchBar.endEditing(true)
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != ""
        {
            fetchData(searchText: searchText);
        }
        else
        {
            shouldShowSearchResults = false
            filteredArray = [ItunesApp]()
            self.tableView.reloadData()
        }
    }
    
    func fetchData(searchText:String)  {
        guard let url = URL(string: "\(endpoint)?term==\(searchText)&limit=\(limit)&entity=\(entity)")else {return}
        
        let fetchingTask = URLSession.shared.dataTask(with: url){(data, response, error) in
            
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let responseObject = try JSONDecoder().decode(Response.self, from: dataResponse)
                self.filteredArray = responseObject.results
                self.reload(itemArray: self.filteredArray)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }

        fetchingTask.resume()
    }
    func reload(itemArray:[ItunesApp]) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

