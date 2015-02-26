//
//  BeaconUpdate.m
//  DMop
//
//  Created by Sam on 21/4/14.
//  Copyright (c) 2014 DMop. All rights reserved.
//

#import "BeaconUpdate.h"
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"

// Set this to your beacon API Key
static NSString * const mobileAPIKey = @"iOS";
static NSString * const mobileURLString = @"https://api.bcp.io/updatebeacon";

@implementation BeaconUpdate
+ (BeaconUpdate *)sharedBeaconClient
{
    static BeaconUpdate *_sharedBeaconClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedBeaconClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:mobileURLString]];
    });
    
    return _sharedBeaconClient;
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

- (void)updateBeaconFound:(NSString*) apitoken : (NSString*) UUID : (NSString*) major : (NSNumber*) minor : (NSInteger) RSSI : (float) accuracy : (CLLocation *)location : (NSString*) USERID
{
    
    if (apitoken !=nil)
    {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"MEMBERID"] = USERID;
        parameters[@"UUID"] = UUID;
        parameters[@"MAJOR"] = major;
        parameters[@"MINOR"] = minor;
        parameters[@"LATITUDE"] =  [NSString stringWithFormat:@"%f",location.coordinate.latitude];
        parameters[@"LONGITUDE"] = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
        
        parameters[@"RSSI"] = [NSNumber numberWithInteger:RSSI];;
        //   parameters[@"ACCURACY"] = accuracy;
        parameters[@"TYPE"] = @"R";
        parameters[@"FORMAT"] = @"json";
        parameters[@"access_token"] = apitoken;
        
        [self GET:@"" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([self.delegate respondsToSelector:@selector(BeaconUpdate:didUpdateBeacon:)]) {
                [self.delegate BeaconUpdate:self didUpdateBeacon:responseObject];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if ([self.delegate respondsToSelector:@selector(BeaconUpdate:didFailWithError:)]) {
                [self.delegate BeaconUpdate:self didFailWithError:error];
            }
        }];
    }
}
@end
