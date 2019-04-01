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

class ViewController: UIViewController, ARSCNViewDelegate {
    
    private var node = SCNNode()

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        loadScene(sceneFile: "art.scnassets/building.scn")
        
        setupGestures()
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
    
    // Add UITapGestureRecognizer to view
    func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeTextures))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - ... Custom Methods
    func loadScene(sceneFile: String) {
        
        guard let scene = SCNScene(named: sceneFile) else { return }
        
        node = scene.rootNode
        
        node.position = SCNVector3(0, -0.5, -1.5)
        node.scale = SCNVector3(0.05, 0.05, 0.05)
        
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

    @objc func changeTextures(tapGesture: UITapGestureRecognizer) {
        node.runAction(.rotateBy(x: 0, y: .pi / 8, z: 0, duration: 0.5))
    }

}
