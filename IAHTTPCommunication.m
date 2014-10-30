//
//  IAHTTPCommunication.m
//  ChuckNorrisRater
//
//  Created by Sui LI on 10/29/14.
//  Copyright (c) 2014 Piano Little Classroom. All rights reserved.
//

#import "IAHTTPCommunication.h"

@interface IAHTTPCommunication()

@property (nonatomic, copy) void (^successBlock)(NSData *);

@end

@implementation IAHTTPCommunication

-(void)retrieveURL:(NSURL *)url successBlock:(void (^)(NSData *)) successBlock
{
    self.successBlock= successBlock;
    
    NSURLRequest *request =[[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    
    [task resume];

}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.successBlock(data);
    });

}

-(void)postURL:(NSURL *)url params:(NSDictionary *)params successBlock:(void(^)(NSData *))successBlock
{
    self.successBlock = successBlock;
    
    NSMutableArray *parametersArray =[NSMutableArray arrayWithCapacity:[params count]];
    for(NSString *key in params)
    {
        [parametersArray addObject:[NSString stringWithFormat:@"%@=%@", key, params[key]]];
        
    }
    
    NSString *postBodyString =[parametersArray componentsJoinedByString:@"&"];
    NSData *postBodyData = [NSData dataWithBytes:[postBodyString UTF8String] length:[postBodyString length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    [request setHTTPBody:postBodyData];
    
    NSURLSessionConfiguration *conf =[NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    
    [task resume];
    


}

@end
