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
- (void) setupWithHost:(NSString*)host onPort:(int)port;
@end

@implementation TBParticleEmitter

- (id)init
{
    self = [super init];
    if (self) {
        socketIOClient = [[SocketIO alloc] initWithDelegate:self];
        [self setupWithHost:@"localhost" onPort:3001];
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
