//
//  ViewController.m
//  Scrible Scrable
//
//  Created by Nutech Systems on 12/11/14.
//  Copyright (c) 2014 Nutech Systems Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *photoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearBarButton;
@property (strong, nonatomic) UIImage *image;

@property (nonatomic) CGFloat navBarHeight;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    _brush = 10.0;
    _opacity = 1.0;
    _navBarHeight = self.navigationController.navigationBar.bounds.size.height;
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Chalkduster" size:17.0], NSFontAttributeName, nil];
    [_saveButton setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    _tempDrawImage = [[UIImageView alloc] initWithFrame:[self imageFrame]];
    _mainImage = [[UIImageView alloc] initWithFrame:[self imageFrame]];

    [self refreshPhotoView];
}


-(void) refreshPhotoView{
    [_photoView removeFromSuperview];
    _photoView = [[UIImageView alloc] initWithFrame:[self imageFrame]];
    [_photoView setContentMode:UIViewContentModeScaleAspectFit];
    _photoView.image = _image;
    [self.view addSubview:_photoView];
    [_photoView addSubview:_mainImage];
    [_photoView bringSubviewToFront:_mainImage];
    [_photoView addSubview:_tempDrawImage];
    [_photoView bringSubviewToFront:_tempDrawImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    mouseSwipe = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    mouseSwipe = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];

    
    UIGraphicsBeginImageContext(_photoView.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, _photoView.bounds.size.width, _photoView.bounds.size.height)];

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _brush);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha: _opacity];
    UIGraphicsEndImageContext();
    
    [self.mainImage setNeedsDisplay];
    [self.tempDrawImage setNeedsDisplay];
    
    lastPoint = currentPoint;
}

-(CGRect)imageFrame
{
    CGFloat TBHeight = 44.0;

    CGRect imageFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TBHeight);
    return imageFrame;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!mouseSwipe) {
        UIGraphicsBeginImageContext(self.photoView.bounds.size);
        
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, _photoView.bounds.size.width, _photoView.bounds.size.height)];
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _brush);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.photoView.bounds.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, _photoView.bounds.size.width, _photoView.bounds.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, _photoView.bounds.size.width, _photoView.bounds.size.height) blendMode:kCGBlendModeNormal alpha:_opacity];

    
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
    
    [self.mainImage setNeedsDisplay];
    [self.tempDrawImage setNeedsDisplay];
}

- (IBAction)photoButton:(UIBarButtonItem *)sender
{
    //Pick an image from library
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    UIAlertController *camera = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *selectCamera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *photoLibrary =[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [camera addAction:cancel];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [camera addAction:selectCamera];
    }
    [camera addAction:photoLibrary];
    [self presentViewController:camera animated:YES completion:nil];
    
}

- (IBAction)saveButton:(UIBarButtonItem *)sender
{

    [_toolBar setHidden:YES];
    UIGraphicsBeginImageContext(self.photoView.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //Save the Image
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    UIAlertController *saved = [UIAlertController alertControllerWithTitle:nil message:@"Your image has been saved." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [_toolBar setHidden:NO];
    }];
    [saved addAction:ok];
    
    
    [self presentViewController:saved animated:YES completion:nil];
        
}

- (IBAction)clearButton:(UIBarButtonItem *)sender
{
    //Clear everything on displaying view
    _image = [UIImage imageNamed:@"whitePixel.png"];
    [self refreshPhotoView];
    self.mainImage.image = nil;
}

#pragma mark - Image Picker Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Retrieve picked image to PhotoView layer
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@", info);
    UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (photo.size.height < photo.size.width) {
        photo  = [UIImage imageWithCGImage:[photo CGImage] scale:1.0 orientation:UIImageOrientationLeft];
    }
    _image = [photo copy];
    [self refreshPhotoView];
    [self.view sendSubviewToBack:_photoView];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SettingsViewController * settingsVC = (SettingsViewController *)segue.destinationViewController;
    settingsVC.delegate = self;
    settingsVC.brush = _brush;
    settingsVC.opacity = _opacity;
    settingsVC.red = red;
    settingsVC.green = green;
    settingsVC.blue = blue;
}

- (void)willCloseSettingsWithBrush:(CGFloat)newBrush andOpacity:(CGFloat)newOpacity andRed:(CGFloat)newRed andGreen:(CGFloat)newGreen andBlue:(CGFloat)newBlue
{
    _brush = newBrush;
    _opacity = newOpacity;
    red = newRed;
    green = newGreen;
    blue = newBlue;
}
@end
