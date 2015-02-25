//
//  DataViewController.h
//  BCP-ObjC-Demo
//
//  Created by Sam on 25/2/15.
//  Copyright (c) 2015 kopi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;

@end

