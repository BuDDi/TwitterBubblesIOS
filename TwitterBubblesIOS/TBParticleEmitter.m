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

- (void) setupWithHost:(NSString*)host onPort:(int)port
{
    [socketIOClient connectToHost:host onPort:port];
}

- (void) socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveMessage() >>> data: ");
}

@end
