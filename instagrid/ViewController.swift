//
//  ViewController.swift
//  instagrid
//
//  Created by agougaut on 25/10/2021.
//

import UIKit

enum Layout: UInt8 {
    case top  = 0b1011
    case down = 0b1110
    case all  = 0b1111
}

class ViewController: UIViewController {

    @IBOutlet weak var configurations: UIStackView!
    @IBOutlet weak var grid: UIStackView!
    
    private var currentLayout = Layout.top
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply the current layout configuration
        applyLayout(currentLayout)
        
        // Assign the gesture for all subviews in
        // the `configurations` stackview
        let gestureLayout1 = UITapGestureRecognizer(target: self, action: #selector(handleGestureLayoutTop))
        configurations.subviews[0].addGestureRecognizer(gestureLayout1)
        
        let gestureLayout2 = UITapGestureRecognizer(target: self, action: #selector(handleGestureLayoutDown))
        configurations.subviews[1].addGestureRecognizer(gestureLayout2)
        
        let gestureLayout3 = UITapGestureRecognizer(target: self, action: #selector(handleGestureLayoutAll))
        configurations.subviews[2].addGestureRecognizer(gestureLayout3)
        
        for stack in grid.subviews {
            for view in stack.subviews {
                let gestureImage = UITapGestureRecognizer(target: self, action: #selector(handleGestureImage))
                view.addGestureRecognizer(gestureImage)
            }
        }
    }
    
    @objc func handleGestureImage() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @objc func handleGestureLayoutTop() {
        currentLayout = .top
        applyLayout(currentLayout)
    }
    
    @objc func handleGestureLayoutDown() {
        currentLayout = .down
        applyLayout(currentLayout)
    }
    
    @objc func handleGestureLayoutAll() {
        currentLayout = .all
        applyLayout(currentLayout)
    }
    
    private func applyLayoutConfig(_ index: Int)
    {
        for i in 0..<configurations.subviews.count {
            configurations.subviews[i].subviews[1].isHidden = (i != index)
        }
    }
    
    func applyLayout(_ layout: Layout) {
        var gridViews: [UIView] = []
        
        for stack in grid.subviews {
            gridViews.append(contentsOf: (stack as? UIStackView)?.subviews ?? [])
        }
        
        for index in 0..<gridViews.count {
            let mask = UInt8((1 << (gridViews.count - 1 - index)))
            gridViews[index].isHidden = ((layout.rawValue & mask) == 0)
        }
        
        switch layout {
            case .top:  applyLayoutConfig(0)
            case .down: applyLayoutConfig(1)
            case .all:  applyLayoutConfig(2)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

