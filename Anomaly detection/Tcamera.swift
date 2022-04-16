//
//  Tcamera.swift
//  Anomaly detection
//
//  Created by 林田計一郎 on 2022/04/14.
//

import UIKit
import AVKit
import VideoToolbox
import Vision

class Tcamera: UIViewController  , AVCaptureVideoDataOutputSampleBufferDelegate{
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var threshold: UISlider!
    
    @IBOutlet weak var rlabel: UILabel!
    @IBOutlet weak var tlabel: UILabel!
    var Feature:[Double] = []
    var key:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //print(Feature)
        
        let captureDevice = AVCaptureDevice.default(for: .video)
        let input = try? AVCaptureDeviceInput(device: captureDevice!)
        let capureSession = AVCaptureSession()
        
        if UserDefaults.standard.object(forKey: "key") != nil{
            self.key = UserDefaults.standard.array(forKey: "key") as! [String]
        }
        
        // セッションを開始する
     
        capureSession.addInput(input!)
        capureSession.startRunning()
        
        //ビデオのプレビューをビューに表示するようにする
        let previewLayer = AVCaptureVideoPreviewLayer(session: capureSession)
        let pvSize = self.view.frame.width
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        previewLayer.frame = CGRect(x: 0, y: 100, width: pvSize, height: pvSize*0.7)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        capureSession.addOutput(dataOutput)

    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let model = try? VNCoreMLModel(for: test2().model)
        let pixelBuffer:CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        var inpimg:CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &inpimg)
        
        let uiimg = UIImage(cgImage: inpimg!).rotatedBy(degree: 90)
        let inpimg2 = uiimg.cgImage
        var classification:[String:Double] = [:]
        var ans:String = "error"
       
        let request = VNCoreMLRequest(model: model!, completionHandler: {
            (finishReq, err) in
//            print(finishReq.results)
            
            let results = finishReq.results as? [VNCoreMLFeatureValueObservation]
            let firstObservation = results?.first
            let m: MLMultiArray = (firstObservation?.featureValue.multiArrayValue!)!
            let a0 = self.convertToArray(from: m)
            
            for i in self.key{
                let Feature = UserDefaults.standard.array(forKey: i) as! [Double]
                let a1 = zip(Feature,a0).map(-)
                let a2 = zip(a1,a1).map(*)
                let a3 = a2.reduce(0,+)
                classification.updateValue(a3, forKey: i)
                
            }
            if let minVal1 = classification.min(by: { a, b in a.value < b.value }) {
                ans = minVal1.key
            }
           
            // 識別結果と確率を表示する
            DispatchQueue.main.async {
                self.img1.image=uiimg
                self.rlabel.text=String(ans)
          
            }
        })
        
        try? VNImageRequestHandler(cgImage: inpimg2!, options: [:]).perform([request])
        
       
    }
    
    
    @IBAction func adjust(_ sender: UISlider) {
        self.tlabel.text = String(Int(sender.value*100))
    }
    
    func convertToArray(from mlMultiArray: MLMultiArray) -> [Double] {
        
        // Init our output array
        var array: [Double] = []
        
        // Get length
        let length = mlMultiArray.count
        
        // Set content of multi array to our out put array
        for i in 0...length - 1 {
            array.append(Double(truncating: mlMultiArray[[0,NSNumber(value: i)]]))
        }
        
        return array
    }
}

extension UIImage {

    func rotatedBy(degree: CGFloat) -> UIImage {
        let radian = -degree * CGFloat.pi / 180
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: self.size.width / 2, y: self.size.height / 2)
        context.scaleBy(x: 1.0, y: -1.0)

        context.rotate(by: radian)
        context.draw(self.cgImage!, in: CGRect(x: -(self.size.width / 2), y: -(self.size.height / 2), width: self.size.width, height: self.size.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return rotatedImage
    }

}
