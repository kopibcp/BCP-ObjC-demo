//
//  NotificationUpdate.m
//  BCP
//
//  Created by Sam on 25/4/14.
//  Copyright (c) 2014 BCP. All rights reserved.
//

#import "NotificationGet.h"

// Set this to your beacon API Key

static NSString * const mobileURLString = @"http://api.bcp.io/notificationget";

@implementation NotificationSetup
+ (NotificationSetup *)sharedFeedbackClient
{
    static NotificationUpdate *_sharedFeedbackClient = nil;
    
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

- (void)setupNotification:(NSString*) apitoken : (NSString*) notificationid
{
    
    if (apitoken !=nil)
    {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"NOTIFICATIONID"] = notificationid;
        parameters[@"FORMAT"] = @"json";
        parameters[@"access_token"] = apitoken;
        
        [self GET:@"" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([self.delegate respondsToSelector:@selector(NotificationUpdate:didUpdateFeedback:)]) {
                [self.delegate NotificationUpdate:self didUpdateFeedback:responseObject];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if ([self.delegate respondsToSelector:@selector(NotificationUpdate:didFailWithError:)]) {
                [self.delegate NotificationUpdate:self didFailWithError:error];
            }
        }];
    }
}
@end
