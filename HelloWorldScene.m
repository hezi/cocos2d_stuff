//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "SecondScene.h"
#import "HZActionableMaskTransition.h"
#import "MyMaskTransition.h"

// HelloWorld implementation
@implementation FirstScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	FirstScene *layer = [FirstScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		// create and initialize a Label
		CCLabel* label = [CCLabel labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild:[CCColorLayer layerWithColor:ccc4(0, 255, 0, 255) ]z:-1];
		[self addChild: label];
		
		[self schedule:@selector(transitionToSecondFrame:) interval:3.0f];
	}
	return self;
}

- (void)transitionToSecondFrame:(ccTime)t
{
	CGSize size = [[CCDirector sharedDirector] winSize];

	[[CCDirector sharedDirector] replaceScene:[MyMaskTransition transitionWithDuration:5 scene:[SecondScene scene]]];
	[self unschedule:@selector(transitionToSecondFrame:)];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
