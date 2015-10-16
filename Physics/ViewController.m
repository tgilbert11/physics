//
//  ViewController.m
//  Physics
//
//  Created by Taylor H. Gilbert on 6/22/13.
//  Copyright (c) 2013 Taylor H. Gilbert. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize balls;
@synthesize lastAccel;

-(NSString *)nameFromIndex:(int)index
{
    NSString *name;
    switch (index) {
        case 0:
            name = @"black.png";
            break;
        case 1:
            name = @"blue.png";
            break;
        case 2:
            name = @"brown.png";
            break;
        case 3:
            name = @"green.png";
            break;
        case 4:
            name = @"orange.png";
            break;
        case 5:
            name = @"pink.png";
            break;
        case 6:
            name = @"purple.png";
            break;
        case 7:
            name = @"red.png";
            break;
        case 8:
            name = @"sky.png";
            break;
        case 9:
            name = @"teal.png";
            break;
        case 10:
            name = @"white.png";
            break;
        case 11:
            name = @"yellow.png";
            break;
            
        default:
            break;
    }
    return name;
}


- (void)viewDidLoad
{
    [UIAccelerometer sharedAccelerometer].delegate = self;
    [UIAccelerometer sharedAccelerometer].updateInterval = 0.02;
    
    bool test = NO;
    
    if (test) {
        if (!self.balls) {
            self.balls = [[NSMutableArray alloc] init];
            
            Ball *ball1 = [[Ball alloc] initWithImage:[UIImage imageNamed:@"green.png"]];
            ball1.frame = CGRectMake(50, 258, 60, 60);
            ball1.velocity = CGPointMake(1,0);
            [self.balls addObject:ball1];
            [self.view addSubview:ball1];
            
            Ball *ball2 = [[Ball alloc] initWithImage:[UIImage imageNamed:@"green.png"]];
            ball2.frame = CGRectMake(200, 200, 60, 60);
            ball2.velocity = CGPointMake(-1,0);
            [self.balls addObject:ball2];
            [self.view addSubview:ball2];
        }
    }
    else {
        if (!self.balls) {
            self.balls = [[NSMutableArray alloc] init];
            for (int i=0; i<12; i++) {
                Ball *newBall = [[Ball alloc] initWithImage:[UIImage imageNamed:[self nameFromIndex:i]]];
                
                double proposedX, proposedY;
                int count = 0;
                bool badSpot = true;
                while (badSpot) {
                    
                    proposedX = arc4random()/4294967296.0 * 260;
                    proposedY = arc4random()/4294967296.0 * 508;
                    badSpot = false;
                    
                    for (Ball *otherBall in balls) {
                        if (sqrt(pow(otherBall.center.x - proposedX, 2) + pow(otherBall.center.y - proposedY, 2)) < 60) {
                            badSpot = true;
                        }
                            
                    }
                    if (count > 10) {
                        NSLog(@"too many");
                        return;
                    }
                }
                
                
                newBall.frame = CGRectMake(proposedX, proposedY, 60, 60);
                newBall.velocity = CGPointMake(arc4random()/4294967296.0, arc4random()/4294967296.0);                
                [self.balls addObject:newBall];
                [self.view addSubview:newBall];
            }
        }
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.007 target:self selector:@selector(moveBall) userInfo:nil repeats:YES];
    //[timer fire];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    self.lastAccel = acceleration;
}

-(void)moveBall
{
    for (Ball *ball in balls) {
        double cor = 0.8;
        for (Ball *otherBall in balls) {
            if ([ball isEqual:otherBall]) {
                continue;
            }
            double dist = sqrt(pow(ball.center.x - otherBall.center.x,2) + pow(ball.center.y - otherBall.center.y,2));
            if (dist < 60) {
                double dvx = ball.velocity.x - otherBall.velocity.x;
                double dvy = ball.velocity.y - otherBall.velocity.y;
                
                double dxx = ball.center.x - otherBall.center.x;
                double dxy = ball.center.y - otherBall.center.y;
                
                double thetaX = atan2(dxx, dxy);
                double thetaV = atan2(dvx, dvy);
                double dtheta = thetaV - thetaX;
                
                double magC = sqrt(pow(dvx, 2) + pow(dvy, 2)) * cos(dtheta);
                
                double xC = magC * sin(thetaX);
                double yC = magC * cos(thetaX);
                
                ball.velocity = CGPointMake(ball.velocity.x - xC*cor, ball.velocity.y - yC*cor);
                otherBall.velocity = CGPointMake(otherBall.velocity.x + xC*cor, otherBall.velocity.y + yC*cor);
                
                double amtToMoveBall = (60 - sqrt(pow(ball.center.x - otherBall.center.x,2) + pow(ball.center.y - otherBall.center.y,2)));
                ball.center = CGPointMake(ball.center.x + amtToMoveBall*sin(thetaX), ball.center.y + amtToMoveBall*cos(thetaX));
                otherBall.center = CGPointMake(otherBall.center.x - amtToMoveBall*sin(thetaX), otherBall.center.y - amtToMoveBall*sin(thetaX));
                
            }
        }
        
        double accelFactor = 0.01;
        ball.velocity = CGPointMake(ball.velocity.x + lastAccel.x*accelFactor, ball.velocity.y - lastAccel.y*accelFactor);
        
        double newXVelocity = ball.velocity.x*7;
        double newYVelocity = ball.velocity.y*7;
        
        double newX = ball.center.x + newXVelocity;
        double newY = ball.center.y + newYVelocity;
        
        if (newX < 30) { newX = 30; ball.velocity = CGPointMake(-ball.velocity.x*cor, ball.velocity.y); }
        if (newX > 290) { newX = 290; ball.velocity = CGPointMake(-ball.velocity.x*cor, ball.velocity.y);}
        if (newY < 30) { newY = 30; ball.velocity = CGPointMake(ball.velocity.x, -ball.velocity.y*cor);}
        if (newY > 538) { newY = 538; ball.velocity = CGPointMake(ball.velocity.x, -ball.velocity.y*cor);}
        
        [ball setCenter:CGPointMake(newX, newY)];
        
    }
    
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
