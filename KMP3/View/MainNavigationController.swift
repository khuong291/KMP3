//
//  MainNavigationController.swift
//  KMP3
//
//  Created by KhuongPham on 1/26/18.
//

import UIKit

final class MainNavigationController: UINavigationController {
    override open var shouldAutorotate: Bool {
        return visibleViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return visibleViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return visibleViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
    override var prefersStatusBarHidden: Bool {
        return visibleViewController?.prefersStatusBarHidden ?? super.prefersStatusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return visibleViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }
}
