//
//  InventoryViewController.m
//  GroceryStore
//
//  Created by Jilian Scott on 5/13/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "InventoryViewController.h"
#import "Product.h"
#import "ProductTableViewCell.h"

#import "ProductDetailViewController.h"

@interface InventoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *productArray;
@property (weak, nonatomic) IBOutlet UITableView *productTableView;

@end

@implementation InventoryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self populateProductArray];
}

- (ProductTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProductTableViewCell *productCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductTableViewCell class]) forIndexPath:indexPath];
    
    Product *product = self.productArray[indexPath.row];
    
    productCell.productTitleLabel.text = product.productName;
    productCell.productQuantityLabel.text = product.quantity;
    
    return productCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productArray.count;
}

- (void)populateProductArray
{
    //create session
    NSString *inventoryURL = @"http://127.0.0.1:5000/api/inventory";
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];

    //create task
    NSURLSessionDataTask *getProduct = [session dataTaskWithURL:[NSURL URLWithString:inventoryURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse =
        (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode == 200) {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            
            if (jsonDict) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.productArray = [Product createInventoryFromResponseDict:jsonDict];
                    [self.productTableView reloadData];                });
            }
        }
        
    }];

    //resume
    [getProduct resume];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"productDetail"]) {
        
        Product *selectedProduct = self.productArray[self.productTableView.indexPathForSelectedRow.row];
        
        ProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.productName = selectedProduct.productName;
        productDetailVC.quantity = selectedProduct.quantity;
    }
}

@end
