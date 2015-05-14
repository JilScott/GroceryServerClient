//
//  Product.h
//  GroceryStore
//
//  Created by Jilian Scott on 5/13/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (strong, nonatomic, readonly) NSString *productName;
@property (strong, nonatomic, readonly) NSString *quantity;

- (id)initWithProductName:(NSString *)productName andQuantity:(NSString *)quantity;
+ (NSArray *)createInventoryFromResponseDict:(NSDictionary *)jsonDict;

@end
