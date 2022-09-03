//
//  ViewController.swift
//  ConcurrancyTest
//
//  Created by YADU MADHAVAN on 30/08/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    @IBOutlet var imageView4: UIImageView!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var slider: UISlider!
    @IBOutlet var sliderValueLabel: UILabel!
    var queueType: QueueType = .normal
    
    var queue = OperationQueue()
    
    let imageUrl = ["https://images.pexels.com/photos/5591708/pexels-photo-5591708.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2", "https://images.pexels.com/photos/9873600/pexels-photo-9873600.jpeg?auto=compress&cs=tinysrgb&w=800", "https://images.pexels.com/photos/194096/pexels-photo-194096.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2", "https://images.pexels.com/photos/2096543/pexels-photo-2096543.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func downloadButtonACtion(_ sender: Any) {
        self.clearImages()
        self.download()
    }
    
    @IBAction func cancelButtonACtion(_ sender: Any) {
        
    }
    
    @IBAction func sliderACtion(_ sender: Any) {
        self.sliderValueLabel.text = "\((sender as? UISlider)?.value ?? 0)"
    }
    
    func clearImages() {
        self.imageView1.image = nil
        self.imageView2.image = nil
        self.imageView3.image = nil
        self.imageView4.image = nil
    }
    
    func download() {
        self.queueType = .blockOperation
        switch queueType {
        case .normal:
            self.regularDownload()
        case .concurrent:
            self.concurrrentQueue()
        case .serial:
            self.serialQueue()
        case .operation:
            self.operationQueue()
        case .blockOperation:
            self.blockOperationQueue()
        }
    }
    
    private func regularDownload() {
        let image1 = Downloader.downloadImageWithUrl(url: self.imageUrl[0])
        self.imageView1.image = image1
        
        let image2 = Downloader.downloadImageWithUrl(url: self.imageUrl[1])
        self.imageView2.image = image2
        
        let image3 = Downloader.downloadImageWithUrl(url: self.imageUrl[2])
        self.imageView3.image = image3
        
        let image4 = Downloader.downloadImageWithUrl(url: self.imageUrl[3])
        self.imageView4.image = image4
    }
    
    private func concurrrentQueue() {
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            let image1 = Downloader.downloadImageWithUrl(url: self.imageUrl[0])
            DispatchQueue.main.async {
                self.imageView1.image = image1
            }
        }
        queue.async {
            let image2 = Downloader.downloadImageWithUrl(url: self.imageUrl[1])
            DispatchQueue.main.async {
                self.imageView2.image = image2
            }
        }
        queue.async {
            let image3 = Downloader.downloadImageWithUrl(url: self.imageUrl[2])
            DispatchQueue.main.async {
                self.imageView3.image = image3
            }
        }
        queue.async {
            let image4 = Downloader.downloadImageWithUrl(url: self.imageUrl[3])
            DispatchQueue.main.async {
                self.imageView4.image = image4
            }
        }
    }
    
    private func serialQueue() {
        let queue = DispatchQueue(label: "com.armia.ConcurrancyTest", qos: .default)
        queue.async {
            let image1 = Downloader.downloadImageWithUrl(url: self.imageUrl[0])
            DispatchQueue.main.async {
                self.imageView1.image = image1
            }
        }
        queue.async {
            let image2 = Downloader.downloadImageWithUrl(url: self.imageUrl[1])
            DispatchQueue.main.async {
                self.imageView2.image = image2
            }
        }
        queue.async {
            let image3 = Downloader.downloadImageWithUrl(url: self.imageUrl[2])
            DispatchQueue.main.async {
                self.imageView3.image = image3
            }
        }
        queue.async {
            let image4 = Downloader.downloadImageWithUrl(url: self.imageUrl[3])
            DispatchQueue.main.async {
                self.imageView4.image = image4
            }
        }
    }
    
    private func operationQueue() {
        let queue = OperationQueue()
        queue.addOperation { () -> Void in
            let image1 = Downloader.downloadImageWithUrl(url: self.imageUrl[0])
            OperationQueue.main.addOperation {
                self.imageView1.image = image1
            }
        }
        queue.addOperation { () -> Void in
            let image2 = Downloader.downloadImageWithUrl(url: self.imageUrl[1])
            OperationQueue.main.addOperation {
                self.imageView2.image = image2
            }
        }
        queue.addOperation { () -> Void in
            let image3 = Downloader.downloadImageWithUrl(url: self.imageUrl[2])
            OperationQueue.main.addOperation {
                self.imageView3.image = image3
            }
        }
        queue.addOperation { () -> Void in
            let image4 = Downloader.downloadImageWithUrl(url: self.imageUrl[3])
            OperationQueue.main.addOperation {
                self.imageView4.image = image4
            }
        }
    }
    private func blockOperationQueue() {
        self.queue = OperationQueue()
        let operation1 = BlockOperation {
            let image1 = Downloader.downloadImageWithUrl(url: self.imageUrl[0])
            OperationQueue.main.addOperation {
                self.imageView1.image = image1
            }
        }
        operation1.completionBlock = {
            print("Operation 1 completed, cancelled: \(operation1.isCancelled)")
        }
        let operation2 = BlockOperation {
            let image2 = Downloader.downloadImageWithUrl(url: self.imageUrl[1])
            OperationQueue.main.addOperation {
                self.imageView2.image = image2
            }
        }
        operation2.completionBlock = {
            print("Operation 2 completed, cancelled: \(operation2.isCancelled)")
        }
        let operation3 = BlockOperation {
            let image3 = Downloader.downloadImageWithUrl(url: self.imageUrl[2])
            OperationQueue.main.addOperation {
                self.imageView3.image = image3
            }
        }
        operation3.completionBlock = {
            print("Operation 3 completed, cancelled: \(operation3.isCancelled)")
        }
        let operation4 = BlockOperation {
            let image4 = Downloader.downloadImageWithUrl(url: self.imageUrl[3])
            OperationQueue.main.addOperation {
                self.imageView4.image = image4
            }
        }
        operation4.completionBlock = {
            print("Operation 4 completed, cancelled: \(operation4.isCancelled)")
        }
        
        operation2.addDependency(operation1)
        operation3.addDependency(operation2)
        operation4.addDependency(operation3)
        
        queue.addOperation(operation1)
        queue.addOperation(operation2)
        queue.addOperation(operation3)
        queue.addOperation(operation4)
    }
}

class Downloader {
    class func downloadImageWithUrl(url: String) -> UIImage! {
        let data = NSData.init(contentsOf: NSURL(string: url)! as URL)
        return UIImage(data: data! as Data)
    }
}

enum QueueType {
    case normal
    case concurrent
    case serial
    case operation
    case blockOperation
}

