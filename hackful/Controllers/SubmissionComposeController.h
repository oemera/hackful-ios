//
//  SubmissionComposeController.h
//  hackful
//
//  Created by Ömer Avci on 12.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ComposeController.h"
#import "HKAPI.h"

@interface SubmissionComposeController : ComposeController <HKAPIDelegate> {
    UITextField *titleField;
    UITextField *urlField;
}

@end
