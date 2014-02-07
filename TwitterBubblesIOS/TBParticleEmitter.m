//
//  TBParticleEmitter.m
//  TwitterBubblesIOS
//
//  Created by Buddi on 07.02.14.
//  Copyright (c) 2014 BudWorks. All rights reserved.
//

#import "TBParticleEmitter.h"

@interface TBParticleEmitter()
{
    SocketIO* socketIOClient;
}

@end

@implementation TBParticleEmitter

- (id)init
{
    self = [super init];
    if (self) {
        socketIOClient = [[SocketIO alloc] initWithDelegate:self];
    }
    return self;
}

- (void) setupWithHost:(int)host andPort:(int)port
{
    socketIOClient connectToHost:@"localhost" onPort:<#(NSInteger)#>
}

@end
