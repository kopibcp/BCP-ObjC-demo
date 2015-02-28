//
//  LocationUpdate.m
//  BCP
//
//  Created by Sam on 21/4/14.
//  Copyright (c) 2014 BCP. All rights reserved.
//

#import "LocationUpdate.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "AFNetworking.h"

// Set this to your beacon API Key
static NSString * const mobileURLString = @"http://token.bcp.io/token";

@implementation LocationUpdate
+ (LocationUpdate *)sharedMobileClient
{
    static LocationUpdate *_sharedMobileClient = nil;
    
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
        
    NSLog(@"LocationUpdate Posting!");
        
    [self POST:@"" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(LocationUpdate:didUpdateMobile:)]) {
            [self.delegate LocationUpdate:self didUpdateMobile:responseObject];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(LocationUpdate:didFailWithError:)]) {
            [self.delegate LocationUpdate:self didFailWithError:error];
        }
    }];
}


@end
