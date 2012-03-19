//
//  CommentComposeController.h
//  hackful
//
//  Created by Ömer Avci on 18.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ComposeController.h"
#import "HKAPI.h"

@class HKEntry;

@interface CommentComposeController : ComposeController <HKAPIDelegate> {
    UITextField *titleField;
}

@property (nonatomic, strong, readonly) HKEntry *entry;

- (id)initWithEntry:(HKEntry*)entry;

@end
