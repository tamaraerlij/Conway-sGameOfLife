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
    var timer = Timer()
    var dead: [(Int, Int)] = []
    var alive: [(Int, Int)] = []
    
    public var boolmatrix: [[Bool]] = Array(repeating: Array(repeating: false, count: 8), count: 8)
    public var nodesMatrix: [[SCNNode]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = SCNView(frame:self.view.frame)
        self.view = sceneView
        sceneView.scene = scene
        sceneView.backgroundColor = .black
        
        let startButton = UIButton()
        startButton.frame = CGRect(x: self.view.frame.size.width * 0.2, y: self.view.frame.size.width * 0.2, width: 100, height: 100)
        startButton.backgroundColor = .white
        startButton.setTitle("Start!", for: .normal)
        startButton.setTitleColor(.blue, for: .normal)
        startButton.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        startButton.layer.cornerRadius = 10
        self.view.addSubview(startButton)
        
        let stopButton = UIButton()
        stopButton.frame = CGRect(x: self.view.frame.size.width * 0.7, y: self.view.frame.size.width * 0.2, width: 100, height: 100)
        stopButton.backgroundColor = .white
        stopButton.setTitle("Stop!", for: .normal)
        stopButton.setTitleColor(.blue, for: .normal)
        stopButton.addTarget(self, action: #selector(stopButtonAction), for: .touchUpInside)
       stopButton.layer.cornerRadius = 10
        self.view.addSubview(stopButton)
        
        var cameraNode: SCNNode!
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 4.5, y:0, z: 25)
        scene.rootNode.addChildNode(cameraNode)
        setUpMatrix()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchScreen(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
    }
    @objc func startButtonAction(_ gestureRecognize: UIGestureRecognizer){
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.start), userInfo: nil, repeats: true)
        
    }
    
     @objc func stopButtonAction(_ gestureRecognize: UIGestureRecognizer){
        clean()
        for j in 0...7 {
            for i in 0...7{
                boolmatrix[i][j] = false
                dead.append((i,j))
            }
            newGrid()
            timer.invalidate()
        }
    }
    
    @objc func start() {
        clean()
        for j in 0...7 {
            for i in 0...7{
                decideTileLife(col: i, row: j)
            }
        }
        newGrid()
    }
    func newGrid() {
        for i in alive {
            boolmatrix[i.0][i.1] = true
            nodesMatrix[i.0][i.1].geometry?.firstMaterial?.diffuse.contents = UIColor.red
        }
        for i in dead {
            boolmatrix[i.0][i.1] = false
            nodesMatrix[i.0][i.1].geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        }
    }
    
    func clean() {
        dead.removeAll(keepingCapacity: false)
        alive.removeAll(keepingCapacity: false)
    }
    
    func countNeighbours(row: Int, col: Int) -> Int {
        var count: Int = 0
        let maxRow = boolmatrix.count - 1
        if (maxRow > 0) {
            let maxCol = boolmatrix[0].count - 1
            let x = max(0, row-1)
            let y = max(0, col-1)
            
            for x in x...min(row + 1, maxRow) {
                for y in y...min(col + 1, maxCol) {
                    if(x != row || y != col) {
                        if(boolmatrix[x][y]) {
                            count += 1
                        }
                    }
                }
            }
            
        }
        return count
    }
    
    func decideTileLife(col: Int, row: Int) {
        let tile = boolmatrix[row][col]
        let count = countNeighbours(row: row, col: col)
        
        if tile {
            if(count < 2) {
                dead.append((row, col))
            }
            else if(count >= 2 && count <= 3) {
                alive.append((row, col))
            }
            else {
                dead.append((row, col))
            }
        }
        else {
            if (count == 3) {
                alive.append((row, col))
            }
            
            else {
                dead.append((row,col))
            }
        }
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
    
    
    
    func setUpSquare(width: CGFloat, height: CGFloat, color: UIColor) -> SCNNode {
        var geometry: SCNGeometry
         geometry = SCNBox(width: width, height: height, length: 0.5, chamferRadius: 0)
        let square = SCNNode(geometry: geometry)
         geometry.firstMaterial?.diffuse.contents = color
        scene.rootNode.addChildNode(square)
        return square
    }
    

    
    @objc func setUpMatrix() {
        for j in 0...7 {
            var row: [SCNNode] = []
            for i in 0...7 {
                let node = setUpSquare(width: self.view.frame.size.width/420, height: self.view.frame.size.width/420, color: UIColor.blue)
                scene.rootNode.addChildNode(node)
                node.position.x = Float(Double(i) * 1.2)
                node.position.y = Float(Double(-j) * 1.2)
                row.append(node)
            }
            nodesMatrix.append(row)
        }
        
    }
    
}
