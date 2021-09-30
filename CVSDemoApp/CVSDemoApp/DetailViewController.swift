//
//  DetailViewController.swift
//  CVSDemoApp
//
//  Created by John Spicer on 2021-09-30.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var sizing: UILabel!
    @IBOutlet var webView: WKWebView! = WKWebView()
    @IBOutlet var scrollView: UIScrollView!
    
    var theItem: FlkrItem?
    var theCache: NSCache<NSNumber, UIImage>?
    var theImage: UIImage?
    //var theIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        itemTitle.text = theItem?.title
        image.image = theImage
        // size must be calculated
        sizing.text = "Size: w:\(image.image?.size.width ?? 0) h:\(image.image?.size.height ?? 0)"
        
        webView.loadHTMLString(theItem?.description ?? "", baseURL: nil)
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
    }
        
    func setData(item: FlkrItem, image: UIImage) {
        theItem = item
        theImage = image
    }
}
