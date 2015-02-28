//
//  AppDelegate.h
//  BCP-ObjC-Demo
//
//  Created by Sam on 25/2/15.
//  Copyright (c) 2015 kopi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Corelocation/CoreLocation.h>
#import "LocationUpdate.h"
#import "BeaconUpdate.h"
#import "foundbeacon.h"
#import "NotificationUpdate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate, MobileUpdateDelegate, BeaconUpdateDelegate, NotificationUpdateDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString* devicetoken;
@property (strong, nonatomic) NSString* userid;
@property (strong, nonatomic) NSMutableArray* fbeacons;
@property (strong, nonatomic) foundbeacon* fbeacon;
@property (strong, nonatomic) id apitoken;
@property (strong, nonatomic) NSString* signedup;
@property (nonatomic) BOOL registered;
@property (strong,nonatomic) NSMutableArray* offers;
@property (strong,nonatomic) NSMutableArray* recommends;
@property (strong,nonatomic) CLBeaconRegion *bcpregion;
@end

