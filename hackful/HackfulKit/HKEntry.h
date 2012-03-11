//
//  HKEntry.h
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKUser.h"

@interface HKEntry : NSObject

@property (nonatomic, readonly) NSInteger objectId;
@property (nonatomic, strong, readonly) NSDate* posted;
@property (nonatomic, readonly) NSInteger votes;
@property (nonatomic, strong, readonly) NSString* text;
@property (nonatomic, strong, readonly) HKUser* user;

- (id)initWithObjectId:(NSInteger)objectId
                posted:(NSDate*)posted 
                 votes:(NSInteger)votes
                  text:(NSString*)text 
               andUser:(HKUser*)user;

@end
