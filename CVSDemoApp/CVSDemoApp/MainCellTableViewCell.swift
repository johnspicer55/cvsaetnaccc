//
//  MainCellTableViewCell.swift
//  CVSDemoApp
//
//  Created by John Spicer on 2021-09-29.
//

import UIKit

class MainCellTableViewCell: UITableViewCell {
    @IBOutlet var theImageView: UIImageView!
    @IBOutlet var theTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        theImageView.image = nil
        theTitle.text = ""
    }
    
    func setupCell(item: FlkrItem, cache: NSCache<NSNumber, UIImage>, index: Int) {
        guard let url = URL(string: item.media["m"] ?? "") else { return  }
        theTitle.text = item.title
        
        if let cachedImage = cache.object(forKey: NSNumber(value: index)) {
            //print("Using a cached image for item: \(index)")
            self.theImageView.image = cachedImage
        } else {
            //print("Fetching an image")
            downloadImage(from: url, cache: cache, index: index)}
        }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, cache: NSCache<NSNumber, UIImage>, index: Int) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(response?.suggestedFilename ?? url.lastPathComponent)
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                let theImage = UIImage(data: data)
                self?.theImageView.image = theImage
                cache.setObject(theImage ?? UIImage(), forKey: NSNumber(value: index))
            }
        }
    }
}
