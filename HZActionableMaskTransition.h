//
//  HZActionableMaskTransition.h
//
//  Created by Hezi Cohen on 8/27/10.
//  Copyright 2010 HeziCohen.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HZMaskSprite : CCSprite {
	id owner_;
}

@property (readwrite, nonatomic, assign) id owner;

@end

@interface HZActionableMaskTransition : CCTransitionScene {
	HZMaskSprite *maskSprite_;
	CCIntervalAction *maskAction_;
	CCRenderTexture *renderLayer_;
	CCRenderTexture *inTexture_;
	CCRenderTexture *outTexture_;	
}

-(CCIntervalAction*)maskActionWithDuration:(ccTime)t;
-(HZMaskSprite*)maskSprite;

@end
