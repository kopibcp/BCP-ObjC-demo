//
//  LocationUpdate.h
//  BCP
//
//  Created by Sam on 21/4/14.
//  Copyright (c) 2014 BCP. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import "AFHTTPSessionManager.h"

@protocol LocationUpdateDelegate;
@interface LocationUpdate : AFHTTPSessionManager

@property (nonatomic, weak) id<MobileUpdateDelegate>delegate;

+ (LocationUpdate *)sharedMobileClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)updateMobileAtLocation:(CLLocation *)location;

@end

@protocol MobileUpdateDelegate <NSObject>
@optional
-(void)LocationUpdate:(LocationUpdate *)client didUpdateMobile:(id)token;
-(void)LocationUpdate:(LocationUpdate *)client didFailWithError:(NSError *)error;
@end
