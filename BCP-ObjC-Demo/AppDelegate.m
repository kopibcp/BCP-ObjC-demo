//
//  AppDelegate.m
//  BCP-ObjC-Demo
//
//  Created by Sam on 25/2/15.
//  Copyright (c) 2015 kopi. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "LocationUpdate.h"
#import "BeaconUpdate.h"
#import "NSData+Conversion.h"
#import "foundbeacon.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize locationManager;
@synthesize location;
@synthesize devicetoken;
@synthesize userid;
@synthesize fbeacons;
@synthesize apitoken;
@synthesize fbeacon;
@synthesize signedup;
@synthesize registered;
@synthesize offers;
@synthesize recommends;
@synthesize bcpregion;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Let the device know we want to receive push notifications
#ifdef __IPHONE_8_0
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
#else
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    
#endif
    devicetoken= [[NSString alloc]init];
    userid= [[NSString alloc]init];
    userid=@"103008337";
    fbeacons= [[NSMutableArray alloc]init];
    
    signedup=[[NSString alloc]init];
    signedup=@"";
    registered=false;
    
    offers = [[NSMutableArray alloc] init];
    recommends= [[NSMutableArray alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = 500;
    [locationManager requestAlwaysAuthorization];
    if([CLLocationManager locationServicesEnabled]) {
        // Location Services Are Enabled
        switch([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                // User has not yet made a choice with regards to this application
                [locationManager requestAlwaysAuthorization];
                break;
            case kCLAuthorizationStatusRestricted:
                // This application is not authorized to use location services.  Due
                // to active restrictions on location services, the user cannot change
                // this status, and may not have personally denied authorization
                break;
            case kCLAuthorizationStatusDenied:
                // User has explicitly denied authorization for this application, or
                // location services are disabled in Settings
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                
                // User has authorized this application to use location services
                [locationManager startUpdatingLocation];
                
                // Override point for customization after application launch.
                location = [[CLLocation alloc] init];
                
                // Create iBeacon region
                bcpregion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"] identifier: @"bcpdemo"];
                bcpregion.notifyEntryStateOnDisplay = YES;
                [locationManager startMonitoringForRegion:bcpregion];
                [locationManager requestStateForRegion:bcpregion];

                break;
        }
    } else {
        // Location Services Disabled
    }
    
    
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus) status
{
    //Authorization changed
    if (status==kCLAuthorizationStatusAuthorizedAlways)
    {
        
        
        [locationManager startUpdatingLocation];
        // Override point for customization after application launch.
        location = [[CLLocation alloc] init];
        // Create iBeacon region
        
        bcpregion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"] identifier: @"bcpdemo"];
        bcpregion.notifyEntryStateOnDisplay = YES;
        [locationManager startMonitoringForRegion:bcpregion];
        [locationManager requestStateForRegion:bcpregion];
        
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    location=locations.lastObject;
    // If the location is more than 5 minutes old, ignore it
    if([location.timestamp timeIntervalSinceNow] > 300)
        return;
    
//    NSLog(@"%@", location.description);
    //if token is not nil send to server with location
    
    if (([devicetoken length]>0)&&(registered!=true))
    {
        registered=true;
        LocationUpdate *client = [LocationUpdate sharedMobileClient];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        client.delegate = appDelegate;
        [client updateMobileAtLocation:location];
    }
}
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLBeaconRegion *)region
{
    
    if(state == CLRegionStateInside) {
        NSLog(@"locationManager didDetermineState INSIDE for %@", region.identifier);
        [locationManager startRangingBeaconsInRegion:region];
        
    }
    else if(state == CLRegionStateOutside) {
        NSLog(@"locationManager didDetermineState OUTSIDE for %@", region.identifier);
        [locationManager stopRangingBeaconsInRegion:region];
        
    }
    else {
        NSLog(@"locationManager didDetermineState OTHER for %@", region.identifier);
        
    }
    
    
}
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
}
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
}
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSInteger found=0;
    NSMutableArray *discardedItems = [NSMutableArray array];
    
    if (apitoken!=nil)
    {
        BeaconUpdate *bupdate = [BeaconUpdate sharedBeaconClient];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        bupdate.delegate = appDelegate;
        
        // First remove any beacons no longer on the list.
        // Check if anything in the list is no longer ranged. Remove it.
        for (foundbeacon *fb in fbeacons)
        {
            found=0;
            for (CLBeacon *beacon in beacons)
            {
                if (fb!=nil)
                {
                    if (([fb.UUID isEqualToString:beacon.proximityUUID.UUIDString])&&(fb.BeaconMajor.intValue==beacon.major.intValue)&&(fb.BeaconMinor.intValue==beacon.minor.intValue))
                    {
                        found=1;
                    }
                }
            }
            if (found==0)
            {
                [discardedItems addObject:fb];
                NSLog(@"Discarding %lu",(unsigned long)[discardedItems count]);
            }
            
        }
        [fbeacons removeObjectsInArray:discardedItems];
        
        for (CLBeacon *beacon in beacons)
        {
            found=0;
            
            // Send trackbeacon if still around for 5 mins.
            
            // Loop to see if NSmutablearray has the same beacon for more than 5 mins, if so sent to api server again.
            for (foundbeacon *fb in fbeacons)
            {
                if (fb!=nil)
                {
                    if (([fb.UUID isEqualToString:beacon.proximityUUID.UUIDString])&&(fb.BeaconMajor.intValue==beacon.major.intValue)&&(fb.BeaconMinor.intValue==beacon.minor.intValue))
                    {
                        found=1;
                        // Check to see if matching beacon, if match, check time > 5
                        
                        // If time > 10 mins, refresh timer
                        if ([fb.foundtime timeIntervalSinceNow]  > 300)
                        {
                            fb.foundtime=[NSDate date];
                            [bupdate updateBeaconFound: appDelegate.apitoken : beacon.proximityUUID.UUIDString : beacon.major : beacon.minor : beacon.rssi : beacon.accuracy : appDelegate.location : userid ];
                            NSLog(@"Resent to server");
                        }
                    }
                }
                
            }
            // First time found, send info to api now.
            if (found==0)
            {
                if ((beacon.proximity == CLProximityNear)||(beacon.proximity == CLProximityImmediate))
                {
                    [bupdate updateBeaconFound: appDelegate.apitoken : beacon.proximityUUID.UUIDString : beacon.major : beacon.minor : beacon.rssi : beacon.accuracy : appDelegate.location : userid ];
                    NSLog(@"First time pass to server");
                    // put beacon in the nsmutablearray
                    fbeacon= [[foundbeacon alloc]init];
                    fbeacon.UUID=beacon.proximityUUID.UUIDString;
                    fbeacon.BeaconMajor=beacon.major;
                    fbeacon.BeaconMinor=beacon.minor;
                    fbeacon.accuracy=beacon.accuracy;
                    fbeacon.proximity=beacon.proximity;
                    fbeacon.foundtime=[NSDate date];
                    [fbeacons addObject:fbeacon];
                    
                    NSLog(@"UUID: %@",beacon.proximityUUID.UUIDString);
                    NSLog(@"Major: %@",[NSString stringWithFormat:@"%@", beacon.major]);
                    NSLog(@"Minor: %@",[NSString stringWithFormat:@"%@", beacon.minor]);
                    NSLog(@"Accuracy: %@",[NSString stringWithFormat:@"%f", beacon.accuracy]);
                    
                    if (beacon.proximity == CLProximityUnknown) {
                        NSLog(@"Unknown Proximity");
                    } else if (beacon.proximity == CLProximityImmediate) {
                        NSLog(@"Immediate");
                    } else if (beacon.proximity == CLProximityNear) {
                        NSLog(@"Near");
                    } else if (beacon.proximity == CLProximityFar) {
                        NSLog(@"Far");
                    }
                    NSLog(@"RSSI: %@",[NSString stringWithFormat:@"%li", (long)beacon.rssi]);
                    
                }
                
            }
            else
            {
                found=0;
            }
            
        }
    }
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)dt
{
    
    devicetoken = [dt hexadecimalString];
    
    if (([devicetoken length]>0)&&(location.coordinate.latitude!=0.00)&&(location.coordinate.longitude!=0.00)&&(registered!=true))
    {
        
        registered=true;
        NSLog(@"My token is: %@, Lat: %f,Long: %f", devicetoken,location.coordinate.latitude,location.coordinate.longitude);
        
        LocationUpdate *client = [LocationUpdate sharedMobileClient];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        client.delegate = appDelegate;
        [client updateMobileAtLocation:location];
    }
    
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)responseData
{
    
    NSNumber *temp=[[responseData valueForKey:@"aps"] valueForKey:@"alert"];
    if (temp!=nil)
    {
        NSLog(@"Received notification %@",temp);
        //    NSLog(@"Received notification %@",userInfo);
        NotificationUpdate *client = [NotificationUpdate sharedFeedbackClient];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        client.delegate = appDelegate;
        [client updateFeedback:apitoken:[temp stringValue]];
    }
    
    
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)LocationUpdate:(LocationUpdate *)client didUpdateMobile:(id)token
{
    NSLog(@"App access token is: %@", [token valueForKey:@"token"]);
    apitoken=[token valueForKey:@"token"];
}

- (void)LocationUpdate:(LocationUpdate *)client didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Updating Mobile"
                                                        message:[NSString stringWithFormat:@"%@",error]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}
- (void)BeaconUpdate:(BeaconUpdate *)client didUpdateBeacon:(id)response
{
    NSLog(@"Beacon response is: %@", response);
}

- (void)BeaconUpdate:(BeaconUpdate *)client didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Updating Beacon"
                                                        message:[NSString stringWithFormat:@"%@",error]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)NotificationUpdate:(NotificationUpdate *)client didUpdateFeedback: (NSDictionary*) response
{
    NSError* error;
    NSData* top;
    
    if([NSJSONSerialization isValidJSONObject:response])
    {
        top =[[[response valueForKey:@"hana"] valueForKey:@"response"] dataUsingEncoding:NSUTF8StringEncoding];
        
        if (top!=nil)
        {
            NSMutableDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:top options:NSJSONReadingAllowFragments error:&error];
            if([NSJSONSerialization isValidJSONObject:jsonResponse])
            {
                NSLog(@"JSON OK");
            }else{
                NSLog(@"JSON NOT OK");
            }
            offers=[jsonResponse objectForKey:@"OFFERS"];
            recommends=[jsonResponse objectForKey:@"RECOMMENDS"];
            NSLog(@"Trackinfo: %@",[jsonResponse objectForKey:@"TRACKINFO"]);
            NSLog(@"Offer: %@",offers);
            NSLog(@"Recommend: %@",recommends);
            NSLog(@"Discounts: %@",[offers valueForKey:@"DESC"]);
            NSLog(@"Recommend2: %@",[recommends valueForKey:@"DESC"]);
            NSLog(@"Discount count: %lu",(unsigned long)[offers count]);
            NSLog(@"Recommend count: %lu",(unsigned long)[recommends count]);
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateOffer" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRecommend" object:nil];
        }
    }
    else
    {
        NSLog(@"dict is not JSON");
    }
    
    //    NSLog(@"Response:%@",[[response valueForKey:@"hana"] valueForKey:@"response"]);
    //        NSLog(@"Response:%@",[[[response valueForKey:@"hana"] valueForKey:@"response"] valueForKey:@"RECOMMENDS"]);
    //        NSDictionary* json=[NSJSONSerialization JSONObjectWithData:response
    //                                        options:NSJSONReadingAllowFragments
    //                                          error:&error];
    
    
    
    
    //   NSDictionary* json = [NSJSONSerialization
    //                          JSONObjectWithData:response //1
    //                         options:kNilOptions
    //                         error:&error];
    
    
}

- (void)NotificationUpdate:(NotificationUpdate *)client didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Updating feedback"
                                                        message:[NSString stringWithFormat:@"%@",error]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end
