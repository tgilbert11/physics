//
//  ViewController.h
//  Physics
//
//  Created by Taylor H. Gilbert on 6/22/13.
//  Copyright (c) 2013 Taylor H. Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ball.h"

@interface ViewController : UIViewController <UIAccelerometerDelegate>
{
    NSMutableArray *balls;
    UIAcceleration *lastAccel;
}

@property (strong, nonatomic) NSMutableArray *balls;
@property (strong, nonatomic) UIAcceleration *lastAccel;

@end
