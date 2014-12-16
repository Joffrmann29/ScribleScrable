//
//  ViewController.h
//  Scrible Scrable
//
//  Created by Nutech Systems on 12/11/14.
//  Copyright (c) 2014 Nutech Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "SettingsViewController.h"

@interface ViewController : UIViewController<SettingsViewControllerDelegate>{

    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    BOOL mouseSwipe;

}
@property (nonatomic) float brush;
@property (nonatomic) float opacity;
@property (strong, nonatomic) UIImageView *tempDrawImage;
@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIImageView *photoView;
@end

