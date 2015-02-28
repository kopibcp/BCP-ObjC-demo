//
//  foundbeacon.h
//  BCP
//
//  Created by Sam on 23/4/14.
//  Copyright (c) 2014 BCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface foundbeacon : NSObject
@property (strong) NSString* UUID;
@property (strong) NSNumber* BeaconMajor;
@property (strong) NSNumber* BeaconMinor;
@property (nonatomic) CLProximity proximity;
@property (nonatomic) CLLocationAccuracy accuracy;
@property (strong) NSDate* foundtime;

@end
