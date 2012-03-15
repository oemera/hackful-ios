//
//  HKListDelegate.h
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKList.h"

@protocol HKListDelegate <NSObject>

@optional
- (void)listFinishedLoading:(HKList *)list;
- (void)listFinishedLoading:(HKList *)list withError:(NSError*)error;

@end
