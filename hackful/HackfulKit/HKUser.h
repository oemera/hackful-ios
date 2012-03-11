//
//  HKUser.h
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface HKUser : NSObject

@property (nonatomic, readonly) NSInteger objectId;
@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, strong, readonly) NSString* email;

- (id)initWithId:(NSInteger)userId username:(NSString*)username andEmail:(NSString*)email;

@end
