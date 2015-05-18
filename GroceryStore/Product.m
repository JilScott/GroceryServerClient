//
//  Product.m
//  GroceryStore
//
//  Created by Jilian Scott on 5/13/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "Product.h"

@interface Product ()

@property (strong, nonatomic) NSString *productName;

@property (strong, nonatomic) NSString *quantity;

@end
@implementation Product

- (id)initWithProductName:(NSString *)productName andQuantity:(NSNumber *)quantity
{
    self = [super init];
    if (self) {
        self.productName = productName;
        self.quantity = [NSString stringWithFormat:@"%@", quantity];
    }
    return self;
}

+ (NSArray *)createInventoryFromResponseDict:(NSDictionary *)jsonDict {
    
    NSMutableArray *inventory = [NSMutableArray new];
    
    for (NSString *productName in jsonDict) {
        Product *newProduct = [[Product alloc] initWithProductName:productName andQuantity:jsonDict[productName]];
        
        [inventory addObject:newProduct];
    }
    
    return inventory;
}
@end
