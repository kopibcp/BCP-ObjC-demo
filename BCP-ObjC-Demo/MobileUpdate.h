//
//  MobileUpdate.h
//  DMop
//
//  Created by Sam on 21/4/14.
//  Copyright (c) 2014 DMop. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>

@protocol MobileUpdateDelegate;
@interface MobileUpdate : AFHTTPSessionManager

@property (nonatomic, weak) id<MobileUpdateDelegate>delegate;

+ (MobileUpdate *)sharedMobileClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)updateMobileAtLocation:(CLLocation *)location;

@end

@protocol MobileUpdateDelegate <NSObject>
@optional
-(void)MobileUpdate:(MobileUpdate *)client didUpdateMobile:(id)token;
-(void)MobileUpdate:(MobileUpdate *)client didFailWithError:(NSError *)error;
@end
