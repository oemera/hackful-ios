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
@property (nonatomic, strong, readonly) NSString* path;
@property (nonatomic, readonly) NSInteger commentCount;
@property (nonatomic, strong) NSArray* comments;

- (id)initWithObjectId:(NSInteger)objectId 
                  link:(NSString*)link
                 title:(NSString*)title
          commentCount:(NSInteger)commentCount
                posted:(NSDate*)posted
                 votes:(NSInteger)votes
                  text:(NSString*)text
                 voted:(BOOL)voted
                  path:(NSString*)path
                  andUser:(HKUser*)user;

- (NSURL*)URLwithLinkOrdPath;

+ (HKPost*)postFromJSON:(id)json;

@end
