//
//  ViewController.m
//  ChuckNorrisRater
//
//  Created by Sui LI on 10/29/14.
//  Copyright (c) 2014 Piano Little Classroom. All rights reserved.
//

#import "ViewController.h"
#import "IAHTTPCommunication.h"
#import "AFNetworking.h"
#import "RestKit.h"
#import "RKTweet.h"


@interface ViewController (){
    NSNumber * jokeID;
}
@end

@implementation ViewController

- (IBAction)thumbUp:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://example.com/rater/vote"];
    IAHTTPCommunication *http =[[IAHTTPCommunication alloc]init];
    
    NSDictionary *params = @{@"joke_id":jokeID, @"vote":@(1)};
    
    [http postURL:url params:params successBlock: ^(NSData *response){
        NSLog(@"Voted Up");
    }];

}

- (IBAction)thumbDown:(id)sender {
    NSURL *url =[NSURL URLWithString:@"http://example.com/rater/vote"];
    IAHTTPCommunication *http = [[IAHTTPCommunication alloc]init];
    NSDictionary *params = @{@"joke_id":jokeID, @"vote":@(-1)};
    [http postURL:url params:params successBlock:^(NSData *response){
        NSLog(@"Vote Down");
    }];

}
- (IBAction)callByAFNetworking:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://httpbin.org/ip"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:url];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
//    
//    [manager GET:@"/resources" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
//        NSLog(@"IP Address:%@", [responseObject valueForKeyPath:@"origin"]);  //What is
//    
//    } failure:nil];
    
    [manager GET:@"/ip" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"IP Address:%@", [responseObject valueForKeyPath:@"origin"]);
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error %@", error);
    }];
}

- (IBAction)callRestKit:(id)sender {
    
    //This sample Twitter API is out of service;
    
    
    RKObjectMapping *mapping =[RKObjectMapping mappingForClass:[RKTweet class]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"user.name":@"username",
        @"user.id": @"userID",
        @"text":@"text"
                                                  
                                                  }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/public_timeline.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc]initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"The Public timeline Tweets:%@", [mappingResult array]);
        RKTweet *tweet =[mappingResult firstObject];
        NSLog(@"the first tweet is %@", tweet);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error:%@", error);
    }];
    
    [operation start];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self retrieveRandomJokes:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)retrieveRandomJokes:(id)sender
{
    IAHTTPCommunication *http =[[IAHTTPCommunication alloc]init];
    NSURL *url = [NSURL URLWithString:@"http://api.icndb.com/jokes/random"];
    
    [http retrieveURL:url successBlock:^(NSData *response){
        NSError *error =nil;
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
        
        if(!error)
        {
            NSDictionary *value = data[@"value"];
            if(value && value[@"joke"])
            {
                jokeID = value[@"id"];
                NSLog(value[@"joke"]);
                [self.jokeLabel setText:value[@"joke"]];
            }
       }
    }];

}
@end
