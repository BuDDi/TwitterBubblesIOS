//
//  TBNode.m
//  TwitterBubblesIOS
//
//  Created by Buddi on 07.02.14.
//  Copyright (c) 2014 BudWorks. All rights reserved.
//

#import "TBNode.h"

@interface TBNode()
{
    NSMutableArray* childs;
}

@end

@implementation TBNode

@synthesize position=_position;

@synthesize rotation=_rotation;

- (id)init
{
    self = [super init];
    if (self) {
        _position = GLKVector3Make(0, 0, 0);
        _rotation = GLKVector3Make(0, 0, 0);
        childs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    childs = nil;
}

-(void) addChild:(TBNode*) child
{
    [childs addObject:child];
}

-(void) removeChild:(TBNode*)child
{
    [childs removeObject:child];
}


-(void) updateBase:(GLfloat) elapsedMillis
{
    if ([self respondsToSelector:@selector(update:)]) {
        [self update:elapsedMillis];
    }
    for (TBNode* child in childs) {
        [child updateBase:elapsedMillis];
    }
}

-(void) drawBase:(GLKMatrixStackRef) matrixStack
{
    GLKMatrixStackPush(matrixStack);
    GLKMatrixStackTranslate(matrixStack, _position.x, _position.y, _position.z);
    GLKMatrixStackRotateX(matrixStack, _rotation.x);
    GLKMatrixStackRotateY(matrixStack, _rotation.y);
    GLKMatrixStackRotateZ(matrixStack, _rotation.z);
    if ([self respondsToSelector:@selector(draw:)]) {
        [self draw:matrixStack];
    }
    for (TBNode* child in childs) {
        [child drawBase:matrixStack];
    }
    GLKMatrixStackPop(matrixStack);
}

- (void) translate:(GLKVector3)translation
{
    self.position = GLKVector3Add(self.position, translation);
}

- (void) rotateZ:(GLfloat) angleInDegrees
{
    self.rotation = GLKVector3Make(self.rotation.x, self.rotation.y, self.rotation.z + angleInDegrees);
}

@end
