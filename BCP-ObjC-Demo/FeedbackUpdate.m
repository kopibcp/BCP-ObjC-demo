//
//  FeedbackUpdate.m
//  DMop
//
//  Created by Sam on 25/4/14.
//  Copyright (c) 2014 DMop. All rights reserved.
//

#import "FeedbackUpdate.h"

// Set this to your beacon API Key
static NSString * const mobileAPIKey = @"iOS";
static NSString * const mobileURLString = @"http://dev.bcp.io/retail/feedback";

@implementation FeedbackUpdate
+ (FeedbackUpdate *)sharedFeedbackClient
{
    static FeedbackUpdate *_sharedFeedbackClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFeedbackClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:mobileURLString]];
    });
    
    return _sharedFeedbackClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void)updateFeedback:(NSString*) apitoken : (NSString*) feedbackid
{
    
    if (apitoken !=nil)
    {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"FEEDBACKID"] = feedbackid;
        parameters[@"FORMAT"] = @"json";
        parameters[@"access_token"] = apitoken;
        
        [self GET:@"" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([self.delegate respondsToSelector:@selector(FeedbackUpdate:didUpdateFeedback:)]) {
                [self.delegate FeedbackUpdate:self didUpdateFeedback:responseObject];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if ([self.delegate respondsToSelector:@selector(FeedbackUpdate:didFailWithError:)]) {
                [self.delegate FeedbackUpdate:self didFailWithError:error];
            }
        }];
    }
}
@end
