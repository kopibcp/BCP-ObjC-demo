//
//  AppDelegate.h
//  BCP-ObjC-Demo
//
//  Created by Sam on 25/2/15.
//  Copyright (c) 2015 kopi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Corelocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@end

