//
//  TMDemoConfig.swift
//  IMSDK
//
//  Created by Joey on 2022/9/28.
//

import Foundation
import UIKit



//color
let color_d8d8d8: UIColor = TMDemo_RGBA(R: 216, G: 216, B: 216, A: 1.0)



func TMDemo_RGBA(R: Int, G: Int, B: Int, A: CGFloat = 1) -> UIColor {
    return UIColor(red: (CGFloat(R) / 255.0), green: (CGFloat(G) / 255.0), blue: (CGFloat(B) / 255.0), alpha: A)
}


//width

let screenWidth: CGFloat = UIScreen.main.bounds.size.width
let screenHeight: CGFloat = UIScreen.main.bounds.size.height

