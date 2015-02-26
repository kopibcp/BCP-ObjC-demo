//
//  MobileUpdate.m
//  DMop
//
//  Created by Sam on 21/4/14.
//  Copyright (c) 2014 DMop. All rights reserved.
//

#import "MobileUpdate.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "AFNetworking.h"

// Set this to your beacon API Key
static NSString * const mobileURLString = @"http://dev.bcp.io/token";

@implementation MobileUpdate
+ (MobileUpdate *)sharedMobileClient
{
    static MobileUpdate *_sharedMobileClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMobileClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:mobileURLString]];
    });
    
    return _sharedMobileClient;
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

- (void)updateMobileAtLocation:(CLLocation *)location
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString* dt = appDelegate.devicetoken;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    parameters[@"CLIENTID"]=@"DI0NYT1kqWfyQAJU";
    parameters[@"SECRET"]=@"8evcrCcmRsKzZglV";
    parameters[@"USERID"]=appDelegate.userid;
    parameters[@"LATITUDE"] =  [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    parameters[@"LONGITUDE"] = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    parameters[@"DEVICEID"]= dt;
    parameters[@"FORMAT"] = @"json";
        
    NSLog(@"MobileUpdate Posting!");
        
    [self POST:@"" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(MobileUpdate:didUpdateMobile:)]) {
            [self.delegate MobileUpdate:self didUpdateMobile:responseObject];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(MobileUpdate:didFailWithError:)]) {
            [self.delegate MobileUpdate:self didFailWithError:error];
        }
    }];
}


@end
