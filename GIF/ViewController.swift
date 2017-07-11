//
//  ViewController.swift
//  GIF
//
//  Created by 张树青 on 2017/7/10.
//  Copyright © 2017年 zsq. All rights reserved.
//

import UIKit
import ImageIO
class ViewController: UIViewController {

    @IBOutlet weak var gifView: GifView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func decode(_ sender: UIButton) {
        
        let path: String? = Bundle.main.path(forResource: "plane", ofType: "gif")
        GifView.decodeGif(byUrl: path)
        
    }
    
    @IBAction func encode(_ sender: UIButton) {
        var images: Array<UIImage> = Array()
        for i in 0...66 {
            let imageName = "\(i).png"
            let image: UIImage = UIImage(named: imageName)!
            images.append(image)
        }
        GifView.encodeGif(byImages: images)
    }
    @IBAction func show(_ sender: UIButton) {
        gifView.showGif(named: "plane")
    }
   
    
    
}

