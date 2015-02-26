//
//  FeedbackUpdate.h
//  DMop
//
//  Created by Sam on 25/4/14.
//  Copyright (c) 2014 DMop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"

@protocol FeedbackUpdateDelegate;
@interface FeedbackUpdate : AFHTTPSessionManager

@property (nonatomic, weak) id<FeedbackUpdateDelegate>delegate;

+ (FeedbackUpdate *)sharedFeedbackClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)updateFeedback:(id) response : (NSString*) feedbackid;

@end

@protocol FeedbackUpdateDelegate <NSObject>
@optional
-(void)FeedbackUpdate:(FeedbackUpdate *)client didUpdateFeedback:(NSDictionary*)response;
-(void)FeedbackUpdate:(FeedbackUpdate *)client didFailWithError:(NSError *)error;
@end
