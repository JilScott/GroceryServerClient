//
//  Networking.m
//  GroceryStore
//
//  Created by Jilian Scott on 5/18/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "Networking.h"

@implementation Networking

+ (id)sharedNetworking
{
    static Networking *sharedNetworking = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetworking = [[self alloc] init];
    });
    return sharedNetworking;
}

- (id)init
{
    if (self = [super init]) {
        //someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
    }
    return self;
}

@end
