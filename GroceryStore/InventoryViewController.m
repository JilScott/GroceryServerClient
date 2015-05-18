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
#import "ProductTableView.h"

#import "ProductDetailViewController.h"

@interface InventoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *productArray;
@property (weak, nonatomic) IBOutlet ProductTableView *productTableView;


@end

@implementation InventoryViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [self populateProductArray];
}

- (ProductTableViewCell *)tableView:(ProductTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductTableViewCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
    
    Product *product = [self.productArray objectAtIndex:indexPath.row];
    
    productCell.productTitleLabel.text = product.productName;
    productCell.productQuantityLabel.text = product.quantity;
    
    return productCell;
}

- (NSInteger)tableView:(ProductTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productArray.count;
}

- (void)populateProductArray {
    self.productArray = [NSArray new];
    
    //create session
    NSString *inventoryURL = @"http://127.0.0.1:5000/api/inventory";
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];

    //create task
    NSURLSessionDownloadTask *getProduct = [session downloadTaskWithURL:[NSURL URLWithString:inventoryURL] completionHandler:^(NSURL *location,
                                                                                                                               NSURLResponse *response,
                                                                                                                               NSError *error) {
        NSHTTPURLResponse *httpResp =
        (NSHTTPURLResponse *) response;
        if (httpResp.statusCode == 200) {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location] options:NSJSONReadingAllowFragments error:&jsonError];
            
            if (!jsonError) {
                NSLog(@"%@", jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.productArray = [Product createInventoryFromResponseDict:jsonDict];
                    [self.productTableView reloadData];
                });
            }
        }
        
    }];
    
    //resume
    [getProduct resume];
    
    //handle data --> json & error
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"productDetail"]) {
        
        Product *selectedProduct = [self.productArray objectAtIndex:self.productTableView.indexPathForSelectedRow.row];
        
        ProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.productName = selectedProduct.productName;
        productDetailVC.quantity = selectedProduct.quantity;
    }
}
@end
