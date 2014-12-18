//
//  SettingsViewController.m
//  Scrible Scrable
//
//  Created by Nutech Systems on 12/15/14.
//  Copyright (c) 2014 Nutech Systems Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewController.h"

@interface SettingsViewController ()

@end


@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Chalkduster" size:17.0], NSFontAttributeName, nil];
    [_closeSettings setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [_cancelButton setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    self.opacityControl.value = _opacity;
    self.brushControl.value = _brush;
}

-(void)viewWillAppear:(BOOL)animated
{
    int redIntValue = self.red *255;
    self.redControl.value = redIntValue;
    [self sliderChange:self.redControl];
    
    int greenIntValue = self.green *255;
    self.greenControl.value = greenIntValue;
    [self sliderChange:self.greenControl];
    
    int blueIntValue = self.blue *255;
    self.blueControl.value = blueIntValue;
    [self sliderChange:self.blueControl];
    
    self.brushControl.value = self.brush;
    [self sliderChange:self.brushControl];
    
    self.opacityControl.value = self.opacity;
    [self sliderChange:self.opacityControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderChange:(UISlider *)sender
{
    UISlider *changedSlider = (UISlider *) sender;
    
    if (changedSlider == self.brushControl) {
        
        self.brush = self.brushControl.value;
        self.brushValueLabel.text = [NSString stringWithFormat:@"%.1f", self.brush];
        
    } else if(changedSlider == self.opacityControl) {
        
        self.opacity = self.opacityControl.value;
        self.opacityValueLabel.text = [NSString stringWithFormat:@"%.1f", self.opacity];
        
    }else if (changedSlider == self.redControl) {
            
            self.red = self.redControl.value/255;
            self.redLabel.text = [NSString stringWithFormat:@"R: %d", (int)self.redControl.value];
    }else if (changedSlider == self.greenControl) {
            
            self.green = self.greenControl.value/255;
            self.greenLabel.text = [NSString stringWithFormat:@"G: %d", (int)self.greenControl.value];
    }else if (changedSlider == self.blueControl) {
            
            self.blue = self.blueControl.value/255;
            self.blueLabel.text = [NSString stringWithFormat:@"B: %d", (int)self.blueControl.value];
    }
    
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, self.opacity);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

#pragma mark - SettingsViewControllerDelegate methods


- (IBAction)closeSettings:(id)sender
{
    _brush = self.brushControl.value;
    _opacity = self.opacityControl.value;
    [self.delegate willCloseSettingsWithBrush:_brush andOpacity:_opacity andRed:_red andGreen:_green andBlue:_blue];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancelButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}
@end
