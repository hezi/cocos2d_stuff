//
//  HZActionableMaskTransition.mm
//
//  Created by Hezi Cohen on 8/27/10.
//  Copyright 2010 HeziCohen.com All rights reserved.
//

#import "HZActionableMaskTransition.h"

@implementation HZActionableMaskTransition

-(void) draw
{
	// override draw since both scenes (textures) are rendered in 1 scene
}

-(CCIntervalAction*)maskActionWithDuration:(ccTime)t
{
	// Override This!
	// Add your own action.
	return nil;
}

-(HZMaskSprite*)maskSprite
{
	// Override This!
	// Add your own mask.
	return nil;
}

-(id) initWithDuration:(ccTime)t scene:(CCScene*)s  
{
	NSAssert( s != nil, @"Argument scene must be non-nil");
	
	if( (self=[super initWithDuration:t scene:s]) ) {
		
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		// create the second render texture for outScene
		outTexture_ = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];
		outTexture_.sprite.anchorPoint= ccp(0.5f,0.5f);
		outTexture_.position = ccp(size.width/2, size.height/2);
		outTexture_.anchorPoint = ccp(0.5f,0.5f);
		
		// render outScene to its texturebuffer
		[outTexture_ begin];
		[outScene visit];
		[outTexture_ end];
		[self addChild:outTexture_];
		
		// create the first render texture for inScene
		inTexture_ = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];
		inTexture_.sprite.anchorPoint= ccp(0.5f,0.5f);
		inTexture_.position = ccp(size.width/2, size.height/2);
		inTexture_.anchorPoint = ccp(0.5f,0.5f);
		
		// render inScene to its texturebuffer
		[inTexture_ begin];
		[inScene visit];
		[inTexture_ end];
		[inTexture_ retain];
		
		maskSprite_ = [self maskSprite];
		
		[maskSprite_ setOwner: self];
		[maskSprite_ setBlendFunc: (ccBlendFunc) { GL_ZERO, GL_ONE_MINUS_SRC_ALPHA }];
		[maskSprite_ retain];
		[self addChild:maskSprite_];
		
		renderLayer_ = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];
		[renderLayer_ retain];
		renderLayer_.position =  ccp( size.width /2 , size.height/2 );
		[self addChild:renderLayer_];
		
		CCIntervalAction * layerAction = [CCSequence actions:
										  (CCIntervalAction*)[self maskActionWithDuration:t],
										  [CCCallFunc actionWithTarget:self selector:@selector(hideOutShowIn)],
										  [CCCallFunc actionWithTarget:self selector:@selector(finish)], nil];
		[maskSprite_ runAction:layerAction];
	}
	return self;
}

// clean up on exit
-(void) onExit
{
	// remove our layer and release all containing objects 
	[self removeChildByTag:1 cleanup:NO];
	[inTexture_ release];
	[super onExit];	
}

-(void)renderCallback
{
	//Update the render texture
	[renderLayer_ begin];
	[inTexture_ visit];
	[maskSprite_ visit];
	[renderLayer_ end];
}

@end


@implementation HZMaskSprite

@synthesize owner=owner_;

-(void) visit
{
	// limit drawing to alpha
	glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
	[super visit];
	glColorMask(1.0f, 1.0f, 1.0f, 1.0f);

}

- (void) setPosition:(CGPoint)pos
{
	[super setPosition:pos];
	[owner_ renderCallback];
}

- (void) setScaleX:(float)s
{
	[super setScaleX:s];
	[owner_ renderCallback];
	
}

- (void) setScaleY:(float)s
{
	[super setScaleY:s];
	[owner_ renderCallback];
	
}

- (void) setScale:(float)s
{
	[super setScale:s];
	[owner_ renderCallback];
	
}

- (void) setRotation:(float)rot
{
	[super setRotation:rot];
	[owner_ renderCallback];
}



@end