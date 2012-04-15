//
//  HKPost.m
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012. All rights reserved.
// 
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "HKPost.h"
#import "HKAPI.h"
#import "NSDate+RailsDate.h"

@implementation HKPost

@synthesize link = _link;
@synthesize title = _title;
@synthesize path = _path;
@synthesize commentCount = _commentCount;
@synthesize comments = _comments;

- (id)initWithObjectId:(NSInteger)objectId 
                  link:(NSString*)link
                 title:(NSString*)title 
          commentCount:(NSInteger)commentCount
                posted:(NSDate*)posted 
                 votes:(NSInteger)votes
                  text:(NSString*)text
                 voted:(BOOL)voted
                  path:(NSString*)path
                  andUser:(HKUser*)user {
    
    self = [super initWithObjectId:objectId 
                            posted:posted 
                             votes:votes 
                              text:text 
                             voted:voted
                           andUser:user];
    if (self) {
        _link = link;
        _title = title;
        _path = path;
        _commentCount = commentCount;
    }
    
    return self;
}

- (NSURL*)URLwithLinkOrdPath {
    NSURL *url;
    if ([self.link isEqualToString:@""]) {
        url = [NSURL URLWithString:[kHKBaseAPIURL stringByAppendingString:self.path]];
    } else {
        url = [NSURL URLWithString:self.link];
    }
    return url;
}

+ (HKPost*)postFromJSON:(id)json {
    NSInteger commentCount = [[json objectForKey:@"comment_count"] intValue];
    NSString *createdAt = [json objectForKey:@"created_at"];
    NSInteger objectId = [[json objectForKey:@"id"] intValue];
    NSString *link = [json objectForKey:@"link"];
    NSString *text = [json objectForKey:@"text"];
    NSString *title = [json objectForKey:@"title"];
    NSString *path = [json objectForKey:@"path"];
    NSInteger upvotes = [[json objectForKey:@"up_votes"] intValue];
    BOOL voted = [[json objectForKey:@"voted"] boolValue];
    NSDate *posted = [NSDate dateForRailsDateString:createdAt];
    HKUser *user = [HKUser userFromJSON:[json objectForKey:@"user"]];
    
    HKPost *post = [[HKPost alloc] initWithObjectId:objectId 
                                               link:link 
                                              title:title 
                                       commentCount:commentCount 
                                             posted:posted 
                                              votes:upvotes 
                                               text:text
                                              voted:voted
                                               path:path
                                            andUser:user];
    return post;
}

@end
