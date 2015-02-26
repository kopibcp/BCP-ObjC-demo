//
//  BeaconUpdate.h
//  DMop
//
//  Created by Sam on 21/4/14.
//  Copyright (c) 2014 DMop. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import "AFHTTPSessionManager.h"

@protocol BeaconUpdateDelegate;
@interface BeaconUpdate: AFHTTPSessionManager

@property (nonatomic, weak) id<BeaconUpdateDelegate>delegate;

+ (BeaconUpdate *)sharedBeaconClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)updateBeaconFound:(NSString*) apitoken : (NSString*) UUID : (NSNumber*) major : (NSNumber*) minor : (NSInteger) RSSI : (float) accuracy : (CLLocation *)location : (NSString*) USERID;

@end

@protocol BeaconUpdateDelegate <NSObject>
@optional
-(void)BeaconUpdate:(BeaconUpdate *)client didUpdateBeacon:(id)response;
-(void)BeaconUpdate:(BeaconUpdate *)client didFailWithError:(NSError *)error;
@end
