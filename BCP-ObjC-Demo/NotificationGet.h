//
//  NotificationUpdate.h
//  BCP
//
//  Created by Sam on 25/4/14.
//  Copyright (c) 2014 BCP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"

@protocol NotificationUpdateDelegate;
@interface NotificationUpdate : AFHTTPSessionManager

@property (nonatomic, weak) id<NotificationUpdateDelegate>delegate;

+ (NotificationUpdate *)sharedFeedbackClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)updateFeedback:(id) response : (NSString*) feedbackid;

@end

@protocol NotificationUpdateDelegate <NSObject>
@optional
-(void)NotificationUpdate:(NotificationUpdate *)client didUpdateFeedback:(NSDictionary*)response;
-(void)NotificationUpdate:(NotificationUpdate *)client didFailWithError:(NSError *)error;
@end
