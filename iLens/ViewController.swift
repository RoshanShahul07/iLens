//
//  ViewController.swift
//  iLens
//
//  Created by Roshan on 21/02/19.
//  Copyright © 2019 Roshan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) 
        
      
        let configuration = ARImageTrackingConfiguration()
        
    
        
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "SchoolImages", bundle: Bundle.main)
        {
            configuration.trackingImages = trackedImages
            configuration.maximumNumberOfTrackedImages = 1
            
            
        }
        
        
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        sceneView.session.pause()
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        
        guard let validAnchor = anchor as? ARImageAnchor else { return }
        
        
        node.addChildNode(createdVideoPlayerNodeFor(validAnchor.referenceImage))
        
    }
    
    
   
    func createdVideoPlayerNodeFor(_ target: ARReferenceImage) -> SCNNode{
        
        
        let videoPlayerNode = SCNNode()
        
        
        let videoPlayerGeometry = SCNPlane(width: target.physicalSize.width, height: target.physicalSize.height)
        var videoPlayer = AVPlayer()
        
        
        if let targetname = target.name,
            let validURL = Bundle.main.url(forResource: targetname, withExtension: "mp4", subdirectory: "art.scnassets") {
            videoPlayer = AVPlayer(url: validURL)
            videoPlayer.play()
        }
        
        
        videoPlayerGeometry.firstMaterial?.diffuse.contents = videoPlayer
        videoPlayerNode.geometry = videoPlayerGeometry
        
        
        videoPlayerNode.eulerAngles.x = -.pi / 2
        
        return videoPlayerNode
        
    }
    

   
}

