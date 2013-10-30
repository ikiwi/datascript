//
//  Stops.h
//  datascript
//
//  Created by Kalai Wei on 10/28/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stops : NSObject
{
    NSString *name;
    NSString *title;
    NSString *stopid;
}
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *stopid;

+ (id)stopsId:(NSString *)name title:(NSString *)title stopid:(NSString *)stopid;

@end
