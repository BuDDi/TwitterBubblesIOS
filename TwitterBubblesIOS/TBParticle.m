//
//  TBParticle.m
//  TwitterBubblesIOS
//
//  Created by Buddi on 07.02.14.
//  Copyright (c) 2014 BudWorks. All rights reserved.
//

#import "TBParticle.h"

@interface TBParticle()
{
    id<Drawable> _shape;
    GLKVector3 _force;
    GLfloat drag;
    GLfloat lifeTime;       // lifetime in seconds
    
}
- (void)destroy;
@end

@implementation TBParticle

- (id)initWithShape:(id<Drawable>)shape
{
    self = [super init];
    if (self) {
        _shape = shape;
    }
    return self;
}

-(void)update:(GLfloat)elapsedMillis
{
    GLfloat elapsedSec = elapsedMillis / 1000.0f;
    // reduce lifeTime
    lifeTime -= elapsedSec;
    if (lifeTime <= 0) {
        [self destroy];
    }
    [self move:elapsedSec ];
    // 15 degrees per second rotation
    GLfloat anglePerSec = 15 * elapsedSec;
    
    [self rotateZ:-anglePerSec];
}

-(void) move:(GLfloat) elapsedSec {
    // reduce force by drag
    GLfloat currentLength = GLKVector3Length(_force);
    GLfloat newLength = (currentLength - (drag * elapsedSec))
    / currentLength;
    newLength = newLength >= 0 ? newLength : 0;
    _force = GLKVector3MultiplyScalar(_force, newLength);
    
    // scale force per second
    GLKVector3 perSecForce = GLKVector3MultiplyScalar(_force, elapsedSec);
    // translate by meters? per second
    [self translate:perSecForce];
}

-(void)draw:(GLKMatrixStackRef)matrixStack
{
    [_shape draw:matrixStack];
}

- (void)addForce:(GLKVector3)force
{
    _force = GLKVector3Add(_force, force);
}

- (void)destroy
{
    
}
@end
