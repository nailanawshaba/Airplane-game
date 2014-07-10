//
//  MyScene.h
//  Airplane
//

//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
}

@property SKSpriteNode *plane;

@end
