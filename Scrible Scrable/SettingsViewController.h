//
//  SettingsViewController.h
//  Scrible Scrable
// My Favorite Drawing App
//  Created by Nutech Systems on 12/15/14.
//  Copyright (c) 2014 Nutech Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate <NSObject>
-(void) willCloseSettingsWithBrush:(CGFloat)brush andOpacity:(CGFloat)opacity andRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;
@end

@interface SettingsViewController : UIViewController

@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;
@property (nonatomic)CGFloat brush;
@property (nonatomic)CGFloat opacity;
@property (weak, nonatomic) IBOutlet UISlider *brushControl;
@property (weak, nonatomic) IBOutlet UISlider *opacityControl;
@property (weak, nonatomic) IBOutlet UIImageView *brushPreview;
@property (weak, nonatomic) IBOutlet UIImageView *opacityPreview;
@property (weak, nonatomic) IBOutlet UILabel *brushValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *opacityValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *redControl;
@property (weak, nonatomic) IBOutlet UISlider *greenControl;
@property (weak, nonatomic) IBOutlet UISlider *blueControl;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;
@end
