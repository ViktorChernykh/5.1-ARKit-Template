//
//  ViewController.swift
//  ARKit Template
//
//  Created by Viktor on 22/03/2019.
//  Copyright © 2019 Viktor Chernykh. All rights reserved.
//
//  The house model is by tomaszcgb (https://free3d.com/user/tomaszcgb)
//  from https://free3d.com/3d-model/buildinghouse-04-40137.html

import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    private var node = SCNNode()
    
    /// Name of the node with the house
    let nodeName = "House"
    
    /// True if the house is shown
    var nodeShown = false
    
    /// Move the point inside the model around which it should rotate by this vector
    let rotationPoint = SCNVector3(2, 0, -5)
    
    /// Scale to take the model back to normal size
    let sceneScale: Float = 0.05
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable default lighting
        sceneView.autoenablesDefaultLighting = true
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Add tap and swipe gesture recognizers
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    /// Add pan, pinch, and tap gesture recognizers
    func addGestureRecognizers() {
        // Add panoramic gesture recognizer
        let panoramic = UIPanGestureRecognizer(target: self, action: #selector(panHandler(_:)))
        panoramic.delegate = self
        sceneView.addGestureRecognizer(panoramic)
        
        // Add pinch handler recognizer
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler(_:)))
        pinch.delegate = self
        sceneView.addGestureRecognizer(pinch)
        
        // Add tap gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        tap.delegate = self
        sceneView.addGestureRecognizer(tap)
    }
    
    /// Handle pan gesture
    @objc func panHandler(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: sceneView)
        
        rotateNode(by: Float(translation.x) / 100)
        moveNode(by: -Float(translation.y) / 100)
        
        recognizer.setTranslation(.zero, in: sceneView)
    }
    
    /// Handle pinch gesture
    @objc func pinchHandler(_ recognizer: UIPinchGestureRecognizer) {
        let scale = Float(1 / recognizer.scale)
        
        // Find the node with the house name
        if let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true),
            let pov = sceneView.pointOfView {
            
            // Original (camera) position
            let x1 = pov.position.x
            let z1 = pov.position.z
            
            // Target (house) position
            let x2 = node.position.x
            let z2 = node.position.z
            
            // Get the house new position
            node.position.x = x1 + scale * (x2 - x1)
            node.position.z = z1 + scale * (z2 - z1)
        }
        
        recognizer.scale = 1
    }
    
    /// Handle tap gestures
    @objc func tapHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            if nodeShown {
                removeNode()
            } else {
                loadScene()
            }
            
            // Revert the house is shown flag
            nodeShown = !nodeShown
        }
    }
    
    /// Remove the house from the scene
    func removeNode() {
        // Find the node with the house name
        if let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true) {
            node.removeFromParentNode()
        }
    }
    
    /// Move house up and down (on Y axis)
    func moveNode(by delta: Float) {
        // Find the node with the house name
        if let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true) {
            node.position.y += delta / 3.0
        }
    }
    
    /// Rotate house around vertical (Y) axis
    func rotateNode(by angle: Float) {
        // Find the node with the name
        if let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true) {
            node.eulerAngles.y += angle
        }
    }
    
    // MARK: - Custom Methods
    func loadScene() {
        let sceneFile = "art.scnassets/building.scn"
        guard let scene = SCNScene(named: sceneFile) else { return }
        
        node = scene.rootNode
        
        // Name the node so we can find it later
        node.name = nodeName
        
        node.position = SCNVector3(0, -0.5, -1.5)
        node.scale = SCNVector3(sceneScale, sceneScale, sceneScale)
        
        // get nodes
        let buildingWalls   = node.childNode(withName: "building_walls",  recursively: false)
        let foundationWall  = node.childNode(withName: "foundation_wall", recursively: false)
        let chimney         = node.childNode(withName: "chimney",         recursively: false)
        let roof            = node.childNode(withName: "roof",            recursively: false)
        let roofPlate       = node.childNode(withName: "roof_plate",      recursively: false)
        let boards          = node.childNode(withName: "boards",          recursively: false)
        let boards001       = node.childNode(withName: "boards_001",      recursively: false)
        
        let roofTexture = UIImage(contentsOfFile: "art.scnassets/textures/roof_02_color.jpg")
        let wallColor = UIColor.init(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(0.80), alpha: 1)
        let boardsColor = UIColor.init(red: CGFloat(0.6), green: CGFloat(0.2), blue: CGFloat(0.2), alpha: 1)
        // set colors
        buildingWalls!.geometry?.firstMaterial?.diffuse.contents = wallColor
        foundationWall!.geometry?.firstMaterial?.diffuse.contents = wallColor
        chimney!.geometry?.firstMaterial?.diffuse.contents = wallColor
        roof!.geometry?.firstMaterial?.diffuse.contents = roofTexture
        roofPlate!.geometry?.firstMaterial?.diffuse.contents = roofTexture
        boards!.geometry?.firstMaterial?.diffuse.contents = boardsColor
        boards001!.geometry?.firstMaterial?.diffuse.contents = boardsColor
        
        sceneView.scene.rootNode.addChildNode(node)
    }
    
}
