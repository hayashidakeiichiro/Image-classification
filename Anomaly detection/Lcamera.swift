//
//  Lcamera.swift
//  Anomaly detection
//
//  Created by 林田計一郎 on 2022/04/14.
//

import UIKit
import DKImagePickerController

class Lcamera: UIViewController {
    
    

    @IBOutlet weak var imgview1: UIImageView!
    var imagelist:[UIImage]=[]
    var i = 0
    
    @IBOutlet weak var listview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func selectPhoto(_ sender: Any) {
        let pickerController = DKImagePickerController()
        // 選択可能な枚数を20にする
        pickerController.maxSelectableCount = 100
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            
            // 選択された画像はassetsに入れて返却されるのでfetchして取り出す
            for asset in assets {
                asset.fetchFullScreenImage(completeBlock: { (image, info) in
                    // ここで取り出せる
                    self.imagelist.append(image!)
                    self.imgview1.image = image
                    self.i+=1
                })
            }
        }
        self.present(pickerController, animated: true) {}
       
    }
    
    @IBAction func toLbtn(_ sender: Any) {
        self.performSegue(withIdentifier: "toL", sender: nil)
        imagelist=[]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toL" {
                let nextview = segue.destination as! LViewController
                nextview.ilist = imagelist
            }
        }
    
    
    
}


