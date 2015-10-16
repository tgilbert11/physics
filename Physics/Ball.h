//
//  Ball.h
//  Physics
//
//  Created by Taylor H. Gilbert on 6/23/13.
//  Copyright (c) 2013 Taylor H. Gilbert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ball : UIImageView
{
    CGPoint velocity;
    bool didJustCollide;
}

@property (nonatomic) CGPoint velocity;
@property (nonatomic) bool didJustCollide;

@end
