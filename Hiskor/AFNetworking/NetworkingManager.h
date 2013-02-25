//
//  NetworkingManager.h
//  Hiskor
//
//  Created by Landon on 2/21/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkingResponseHandler <NSObject>

- (void)networkingResponseReceived:(id)response ForMessage:(NSDictionary *)message;
- (void)networkingResponseFailedForMessage:(NSDictionary *)message error:(NSError *)error;

@end

@interface NetworkingManager : NSObject

+ (void)sendDictionary:(NSDictionary *)dictionary responseHandler:(id<NetworkingResponseHandler>)responseHandler;

@end
