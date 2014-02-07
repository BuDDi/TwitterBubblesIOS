//
//  TBSphere.h
//  TwitterBubblesIOS
//
//  Created by Buddi on 03.02.14.
//  Copyright (c) 2014 BudWorks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBTypes.h"

@interface TBSphere : NSObject

- (id)initWithRadius:(GLfloat)radius andParts:(GLuint) parts;
-(void) draw;
-(void) tearDown;
@end
