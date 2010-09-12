//
//  MaskTestTrantision.m
//  TransitionTest
//
//  Created by Hezi Cohen on 9/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyMaskTransition.h"


@implementation MyMaskTransition

-(CCIntervalAction*)maskActionWithDuration:(ccTime)t
{
	CCIntervalAction *action = [CCEaseIn actionWithAction:[CCScaleBy actionWithDuration:t scale:0.1f] rate:5];
	
	return action;
}

-(HZMaskSprite*) maskSprite
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	
	HZMaskSprite *mask = [HZMaskSprite spriteWithFile:@"mask.png"];
	[mask setScale:2.0f];
	mask.position = ccp(size.width/2, size.height/2);

	return mask;
}

@end
