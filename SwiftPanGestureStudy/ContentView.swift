//
//  ContentView.swift
//  SwiftPanGestureStudy
//
//  Created by Frank Su on 2020-04-05.
//  Copyright © 2020 frankusu. All rights reserved.
//

import SwiftUI

class ViewController : UIViewController {
    let fileImage : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "file"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        image.heightAnchor.constraint(equalToConstant: 60).isActive = true
        image.isUserInteractionEnabled = true
        return image
    }()
    let recycleImage : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "garbage"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        image.heightAnchor.constraint(equalToConstant: 60).isActive = true
        image.isUserInteractionEnabled = true
        return image
    }()
    //since we know that its guranteeded in the view, we can force unwrap
    var fileImageOrigin : CGPoint!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(fileImage)
        view.addSubview(recycleImage)
        setupImages()
        fileImageOrigin = fileImage.center
        setupPan(view: fileImage)
    }
    
    func setupPan(view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        //we are guranteed that the view is set up since it's in view did load
        let fileView = sender.view!
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began, .changed:
            fileView.center = CGPoint(x: fileView.center.x + translation.x, y: fileView.center.y + translation.y)
            sender.setTranslation(.zero, in: view)
            
            if fileView.frame.intersects(recycleImage.frame) {
                print("File on garbo")
                fileView.alpha = 0.0
            }
        case .ended:
            fileView.center = fileImageOrigin
        default:
            print("Not doing stuff")
        }
    }
    func setupImages() {
        NSLayoutConstraint.activate([
            fileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            recycleImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            recycleImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        
    }
}

struct AppsView : UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AppsView>) -> UIViewController {
        let controller = ViewController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AppsView>) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
    }
}
