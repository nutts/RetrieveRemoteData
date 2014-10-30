//
//  IAHTTPCommunication.h
//  ChuckNorrisRater
//
//  Created by Sui LI on 10/29/14.
//  Copyright (c) 2014 Piano Little Classroom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAHTTPCommunication : NSObject <NSURLSessionDelegate>

-(void) retrieveURL:(NSURL *)url successBlock:(void (^) (NSData *))successBlock;

-(void)postURL:(NSURL *)url params:(NSDictionary *)params successBlock:(void (^)(NSData *))successBlock;
@end
