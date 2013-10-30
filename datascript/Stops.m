//
//  Stops.m
//  datascript
//
//  Created by Kalai Wei on 10/28/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "Stops.h"

@implementation Stops
@synthesize name;
@synthesize title;
@synthesize stopid;

+ (id)stopsId:(NSString *)name title:(NSString *)title stopid:(NSString *)stopid
{
    Stops *newStop = [[self alloc] init];
    newStop.name = name;
    newStop.title = title;
    newStop.stopid = stopid;
    return newStop;
}

@end
