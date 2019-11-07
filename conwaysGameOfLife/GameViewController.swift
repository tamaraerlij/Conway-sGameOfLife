//
//  GameViewController.swift
//  conwaysGameOfLife
//
//  Created by Tamara Erlij on 06/11/19.
//  Copyright © 2019 Tamara Erlij. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import Foundation

class GameViewController: UIViewController {
    
    var sceneView: SCNView!
    var scene = SCNScene()
    
    public var boolmatrix: [[Bool]] = Array(repeating: Array(repeating: false, count: 8), count: 8)
    public var nodesMatrix: [[SCNNode]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        sceneView = SCNView(frame:self.view.frame)
        self.view = sceneView
        sceneView.scene = scene
        sceneView.backgroundColor = .black
        
        var cameraNode: SCNNode!
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 4.5, y:0, z: 25)
        scene.rootNode.addChildNode(cameraNode)
        setUpMatrix()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchScreen(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func touchScreen(_ gestureRecognize: UIGestureRecognizer){
        let touched = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(touched, options: [:])
        if hitResults.count > 0{
            let result = hitResults[0]
            for j in 0...7 {
                for i in 0...7{
                    if nodesMatrix[i][j] == result.node {
                        boolmatrix[i][j] = true
                        print(boolmatrix)
                        print(nodesMatrix)
                        nodesMatrix[i][j].geometry?.firstMaterial?.diffuse.contents = UIColor.red
                    }
                }
            }
        }
    }
    
    
    
    func setUpMatrix() {
        var geometry: SCNGeometry
        geometry = SCNBox(width: self.view.frame.size.width / 420, height: self.view.frame.size.width / 420, length: 0.5, chamferRadius: 0)
        
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        for j in 0...7 {
            var row: [SCNNode] = []
            for i in 0...7{
                let node = SCNNode(geometry: geometry)
                scene.rootNode.addChildNode(node)
                node.position.x = Float(Double(i) * 1.2)
                node.position.y = Float(Double(-j) * 1.2)
                
                row.append(node)
            }
            nodesMatrix.append(row)
        }
        
    }
    
    
}
