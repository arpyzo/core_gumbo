// Copyright (c) 2015 Robert Pyzalski
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit

class Draw2D: UIView {
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        drawSky(rect, context, colorSpace)
        drawMountains(rect, context, colorSpace)

        drawEllipse(CGRectMake(125, 230, 9, 14), 0, context);
        drawEllipse(CGRectMake(115, 236, 10, 12), 300, context);
        drawEllipse(CGRectMake(120, 246, 9, 14), 5, context);
        drawEllipse(CGRectMake(128, 246, 9, 14), 350, context);
        drawEllipse(CGRectMake(133, 236, 11, 14), 80, context);
    }
    
    func drawSky(rect: CGRect, _ context: CGContextRef, _ colorSpace: CGColorSpaceRef) {
        let baseColor = CGColorCreate(colorSpace, [148/255, 158/255, 183/255, 1])
        let middleStop = CGColorCreate(colorSpace,[127/255, 138/255, 166/255, 1])
        let farStop = CGColorCreate(colorSpace, [96/255, 111/255, 144/255, 1])
        
        CGContextSaveGState(context)
        
        let colors: CFArray = [baseColor, middleStop, farStop]
        let locations: [CGFloat] = [0.0, 0.1, 0.25]
        
        let gradient = CGGradientCreateWithColors(colorSpace, colors, locations)
        
        let startPoint = CGPointMake(rect.size.height / 2, 0)
        let endPoint = CGPointMake(rect.size.height / 2, rect.size.width)
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)
        
        CGContextRestoreGState(context)
    }
    
    func drawMountains(rect: CGRect, _ context: CGContextRef, _ colorSpace: CGColorSpaceRef) {
        let darkColor = CGColorCreate(colorSpace, [1/255, 93/255, 67/255, 1])
        let lightColor = CGColorCreate(colorSpace,[63/255, 109/255, 79/255, 1])
        
        let colors: CFArray = [darkColor, lightColor]
        let locations: [CGFloat] = [0.1, 0.2]

        let gradient = CGGradientCreateWithColors(colorSpace, colors, locations)

        let startPoint = CGPointMake(rect.size.height / 2, 100)
        let endPoint = CGPointMake(rect.size.height / 2, rect.size.width)

        CGContextSaveGState(context)
        
        // Background Mountains
        let backgroundMountains = CGPathCreateMutable()
        CGPathMoveToPoint(backgroundMountains, nil, -5, 157)
        CGPathAddQuadCurveToPoint(backgroundMountains, nil, 30, 129, 77, 157)
        CGPathAddCurveToPoint(backgroundMountains, nil, 190, 210, 200, 70, 303, 125)
        CGPathAddQuadCurveToPoint(backgroundMountains, nil, 340, 150, 350, 150)
        CGPathAddQuadCurveToPoint(backgroundMountains, nil, 380, 155, 410, 145)
        CGPathAddCurveToPoint(backgroundMountains, nil, 500, 100, 540, 190, 672, 165)
        CGPathAddLineToPoint(backgroundMountains, nil, 672, rect.size.width)
        CGPathAddLineToPoint(backgroundMountains, nil, -5, rect.size.width)
        CGPathCloseSubpath(backgroundMountains)
        
        CGContextAddPath(context, backgroundMountains)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextStrokePath(context)
        
        CGContextAddPath(context, backgroundMountains)
        CGContextClip(context)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)
        CGContextSetLineWidth(context, 4)
        
        // Foreground Mountains
        let foregroundMountains = CGPathCreateMutable()
        CGPathMoveToPoint(foregroundMountains, nil, -5, 190)
        CGPathAddCurveToPoint(foregroundMountains, nil, 160, 250, 200, 140, 303, 190)
        CGPathAddCurveToPoint(foregroundMountains, nil, 430, 250, 550, 170, 672, 210)
        CGPathAddLineToPoint(foregroundMountains, nil, 672, 230)
        CGPathAddCurveToPoint(foregroundMountains, nil, 300, 260, 140, 215, -5, 225)
        CGPathCloseSubpath(foregroundMountains)
        
        CGContextAddPath(context, foregroundMountains)
        CGContextClip(context)
        CGContextSetFillColorWithColor(context, darkColor)
        CGContextFillRect(context, CGRectMake(0, 170, 672, 90))
        
        CGContextAddPath(context, foregroundMountains)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextStrokePath(context)

        CGContextRestoreGState(context)
    }
    
    func drawEllipse(rect: CGRect, _ degrees: NSInteger, _ context: CGContextRef) {
        CGContextSaveGState(context);
        
        let flowerPetal = CGPathCreateMutable();
        
        let midX = CGRectGetMidX(rect);
        let midY = CGRectGetMidY(rect);
        
        var transfrom: CGAffineTransform = CGAffineTransformConcat(
                CGAffineTransformConcat(CGAffineTransformMakeTranslation(-midX, -midY),
                                        CGAffineTransformMakeRotation(degreesToRadians(degrees))),
                CGAffineTransformMakeTranslation(midX, midY))
        
        CGPathAddEllipseInRect(flowerPetal, &transfrom, rect)
        CGContextAddPath(context, flowerPetal)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextStrokePath(context)
        
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextAddPath(context, flowerPetal)
        CGContextFillPath(context)
        
        CGContextRestoreGState(context)
    }
    
    func degreesToRadians(degrees: NSInteger) -> CGFloat {
        return CGFloat(M_PI) * CGFloat(degrees) / 180.0
    }
}
