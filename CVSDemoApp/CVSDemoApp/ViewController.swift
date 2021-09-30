//
//  ViewController.swift
//  CVSDemoApp
//
//  Created by John Spicer on 2021-09-29.
//

import UIKit

var searchResults = [FlkrItem]()

class ViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    
    var flkrData: Flkr? = nil
    var searching = false
    
    let cache = NSCache<NSNumber, UIImage>()
    let utilityQueue = DispatchQueue.global(qos: .utility)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.searchBar.setShowsCancelButton(true, animated: true)

        // get our data
        loadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchResults.count
        } else {
            return self.flkrData?.items.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myMainCell", for: indexPath) as! MainCellTableViewCell
        
        if searching {
            // Configure the cell...
            let item = searchResults[indexPath.row]
            cell.setupCell(item: item, cache: cache, index: indexPath.row)
            return cell
        }
        else {
            // Configure the cell...
            guard let item = self.flkrData?.items[indexPath.row] else { return UITableViewCell() }
            cell.setupCell(item: item, cache: cache, index: indexPath.row)
            return cell
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            // Close keyboard when you select cell
            self.searchBar.searchTextField.endEditing(true)
            let selectedIndex = tableView.indexPath(for: sender as! UITableViewCell)!
            if searching {
                let item = searchResults[selectedIndex.row]
                let cachedImage = cache.object(forKey: NSNumber(value: selectedIndex.row)) ?? UIImage()
                let detailView = segue.destination as! DetailViewController
                detailView.setData(item: item, image: cachedImage)
           }
            else {
                guard let item = self.flkrData?.items[selectedIndex.row] else { return }
                guard let cachedImage = cache.object(forKey: NSNumber(value: selectedIndex.row)) else { return }

                let detailView = segue.destination as! DetailViewController
                detailView.setData(item: item, image: cachedImage)
            }
            // in either case, we are no longer searching
            searching = false
        }
    }
    
    func loadData() {
        let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=porcupine")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
          
            do {
                self.flkrData = try JSONDecoder().decode(Flkr.self, from: data)
 
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    // MARK: - Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = self.flkrData?.items.filter( { $0.title.range(of: searchText, options: .caseInsensitive) != nil} ) ?? []

        searching = true
        // this is a wee bit nasty - forcing a refetch
        // there is probably a better way!
        self.cache.removeAllObjects()
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        self.searchBar.text = ""
        self.searchBar.endEditing(true)

        tableView.reloadData()
    }
}

