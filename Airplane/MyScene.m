//
//  MyScene.m
//  Airplane
//
//  Created by Jesus Magana on 7/9/14.
//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        //CoreMotion
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = .2;
        
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                 withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                     [self outputAccelertionData:accelerometerData.acceleration];
                                                     if(error)
                                                     {
                                                         NSLog(@"%@", error);
                                                     }
                                                 }];
        
        //init several sizes used in all scene
        screenRect = [[UIScreen mainScreen] bounds];
        screenHeight = screenRect.size.height;
        screenWidth = screenRect.size.width;
        
        //adding the airplane
        _plane = [SKSpriteNode spriteNodeWithImageNamed:@"PLANE 8 N.png"];
        _plane.scale = 0.6;
        _plane.zPosition = 2;
        _plane.position = CGPointMake(screenWidth/2, 15+_plane.size.height/2);
        [self addChild:_plane];
        
        _planeShadow = [SKSpriteNode spriteNodeWithImageNamed:@"PLANE 8 SHADOW.png"];
        _planeShadow.scale = 0.6;
        _planeShadow.zPosition = 1;
        _planeShadow.position = CGPointMake(screenWidth/2+15, 0+_planeShadow.size.height/2);
        [self addChild:_planeShadow];
        
        _propeller = [SKSpriteNode spriteNodeWithImageNamed:@"PLANE PROPELLER 1.png"];
        _propeller.scale = 0.2;
        _propeller.position = CGPointMake(screenWidth/2, _plane.size.height+10);
        
        SKTexture *propeller1 = [SKTexture textureWithImageNamed:@"PLANE PROPELLER 1.png"];
        SKTexture *propeller2 = [SKTexture textureWithImageNamed:@"PLANE PROPELLER 2.png"];
        
        SKAction *spin = [SKAction animateWithTextures:@[propeller1,propeller2] timePerFrame:0.1];
        SKAction *spinForever = [SKAction repeatActionForever:spin];
        [_propeller runAction:spinForever];
        
        [self addChild:_propeller];
        
        //adding the background
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"airPlanesBackground"];
        background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:background];
        
        //adding the smokeTrail
        NSString *smokePath = [[NSBundle mainBundle] pathForResource:@"trail" ofType:@"sks"];
        _smokeTrail = [NSKeyedUnarchiver unarchiveObjectWithFile:smokePath];
        _smokeTrail.position = CGPointMake(screenWidth/2, 15);
        [self addChild:_smokeTrail];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    
    if(fabs(acceleration.x) > fabs(currentMaxAccelX))
    {
        currentMaxAccelX = acceleration.x;
    }
    if(fabs(acceleration.y) > fabs(currentMaxAccelY))
    {
        currentMaxAccelY = acceleration.y;
    }
}

-(void)update:(NSTimeInterval)currentTime{
    //NSLog(@"one second");
    
    
    float maxY = screenWidth - _plane.size.width/2;
    float minY = _plane.size.width/2;
    
    
    float maxX = screenHeight - _plane.size.height/2;
    float minX = _plane.size.height/2;
    
    float newY = 0;
    float newX = 0;
    
    if(currentMaxAccelX > 0.05){
        newX = currentMaxAccelX * 10;
        _plane.texture = [SKTexture textureWithImageNamed:@"PLANE 8 R.png"];
    }
    else if(currentMaxAccelX < -0.05){
        newX = currentMaxAccelX*10;
        _plane.texture = [SKTexture textureWithImageNamed:@"PLANE 8 L.png"];
    }
    else{
        newX = currentMaxAccelX*10;
        _plane.texture = [SKTexture textureWithImageNamed:@"PLANE 8 N.png"];
    }
    
    newY = 6.0 + currentMaxAccelY *10;
    
    float newXshadow = newX+_planeShadow.position.x;
    float newYshadow = newY+_planeShadow.position.y;
    
    newXshadow = MIN(MAX(newXshadow,minY+15),maxY+15);
    newYshadow = MIN(MAX(newYshadow,minX-15),maxX-15);
    
    float newXpropeller = newX+_propeller.position.x;
    float newYpropeller = newY+_propeller.position.y;
    
    newXpropeller = MIN(MAX(newXpropeller,minY),maxY);
    newYpropeller = MIN(MAX(newYpropeller,minX+(_plane.size.height/2)-5),maxX+(_plane.size.height/2)-5);
    
    newX = MIN(MAX(newX+_plane.position.x,minY),maxY);
    newY = MIN(MAX(newY+_plane.position.y,minX),maxX);
    
    
    _plane.position = CGPointMake(newX, newY);
    _planeShadow.position = CGPointMake(newXshadow, newYshadow);
    _propeller.position = CGPointMake(newXpropeller, newYpropeller);
    
    _smokeTrail.position = CGPointMake(newX,newY-(_plane.size.height/2));
}

@end
