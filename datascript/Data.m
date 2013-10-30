//
//  Data.m
//  datascript
//
//  Created by Kalai Wei on 10/28/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "Data.h"

NSString *ROUTESDIR = @"routes";

@implementation Data
@synthesize name;
@synthesize title;
@synthesize stopid;
@synthesize direction;

-(id)init
{
    self = [super init];
    if (self) {
        self.name = @"";
        self.title = @"";
        self.stopid = @"";
        self.direction = @"";
    }
    return self;
}

+(void) writeToTextFile:(NSString*)content dir:(NSString*)dir
{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *filename = [NSString stringWithFormat:@"%@/%@.txt",
                          documentsDirectory, dir];
    //save content to the documents directory
    [content writeToFile:filename
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
    
}

@end
