//
//  TBNode.h
//  TwitterBubblesIOS
//
//  Created by Buddi on 07.02.14.
//  Copyright (c) 2014 BudWorks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBTypes.h"
@protocol Drawable
@optional
-(void) draw:(GLKMatrixStackRef) matrixStack;
@end

@protocol Updatable
@optional
-(void) update:(GLfloat) elapsedMillis;
@end

@interface TBNode : NSObject <Drawable, Updatable>

@property GLKVector3 position;

@property GLKVector3 rotation;

- (void) addChild:(TBNode*) child;

- (void) removeChild:(TBNode*)child;

- (void) translate:(GLKVector3)translation;

- (void) rotateZ:(GLfloat) angleInDegrees;

//-(void) update:(GLfloat) elapsedMillis;

//-(void) draw:(GLKMatrixStackRef) matrixStack;

@end
