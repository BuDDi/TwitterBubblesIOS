//
//  TBScene.m
//  TwitterBubblesIOS
//
//  Created by Buddi on 07.02.14.
//  Copyright (c) 2014 BudWorks. All rights reserved.
//

#import "TBScene.h"
#import "TBNode.h"

@interface TBScene()
{
    GLKMatrixStackRef matrixStack;
    TBNode* rootNode;
}

@end

@implementation TBScene


- (id)init
{
    self = [super init];
    if (self) {
        rootNode = [[TBNode alloc ] init];
        matrixStack = GLKMatrixStackCreate(NULL);
    }
    return self;
}

- (void)dealloc
{
    rootNode = nil;
}

-(void) draw
{
    [rootNode draw:matrixStack];
}

@end
