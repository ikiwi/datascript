//
//  Data.h
//  datascript
//
//  Created by Kalai Wei on 10/28/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject
{
    NSString *name;
    NSString *title;
    NSString *stopid;
    NSString *direction;
}
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *stopid;
@property (strong, nonatomic) NSString *direction;

+(void)writeToTextFile:(NSString*)content dir:(NSString*)dir;
@end
