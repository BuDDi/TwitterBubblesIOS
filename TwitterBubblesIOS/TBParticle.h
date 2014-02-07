//
//  TBParticle.h
//  TwitterBubblesIOS
//
//  Created by Buddi on 07.02.14.
//  Copyright (c) 2014 BudWorks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBNode.h"

@interface TBParticle : TBNode

- (id)initWithShape:(id<Drawable>)shape;
- (void)addForce:(GLKVector3)force;

@end
