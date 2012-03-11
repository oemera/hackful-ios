//
//  HKPost.h
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKEntry.h"

@class HKUser;

@interface HKPost : HKEntry

@property (nonatomic, strong, readonly) NSString* link;
@property (nonatomic, strong, readonly) NSString* title;
@property (nonatomic, readonly) NSInteger commentCount;

- (id)initWithObjectId:(NSInteger)objectId 
                  link:(NSString*)link
                 title:(NSString*)title
          commentCount:(NSInteger)commentCount
                posted:(NSDate*)posted
                 votes:(NSInteger)votes
                  text:(NSString*)text
                  andUser:(HKUser*)user;

@end
