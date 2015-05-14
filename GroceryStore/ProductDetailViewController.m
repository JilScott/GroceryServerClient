//
//  ProductDetailViewController.m
//  GroceryStore
//
//  Created by Jilian Scott on 5/13/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productQuantityLabel;

@property (weak, nonatomic) IBOutlet UILabel *quantityAdjustmentLabel;

@end
@implementation ProductDetailViewController

- (void)viewDidLoad {
    self.productTitleLabel.text = self.productName;
    self.productQuantityLabel.text = [NSString stringWithFormat:@"Current quantity is: %@", self.quantity];
}
- (IBAction)stepped:(UIStepper *)sender {
    
    self.quantityAdjustmentLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
    
}

- (IBAction)removeAllStock:(id)sender {
    
    //create session
    NSString *productURL = [NSString stringWithFormat:@"http://127.0.0.1:5000/api/inventory/%@", self.productName];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    //create task
    NSURLSessionDownloadTask *deleteProduct = [session downloadTaskWithURL:[NSURL URLWithString:productURL] completionHandler:^(NSURL *location,
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
                    
                    //update UI
                    self.productQuantityLabel.text = @"0";
                    
                    
                    // need delegate to [self.productTableView reloadData];
                });
            }
        }
        
    }];
    
    //resume
    [deleteProduct resume];
}
- (IBAction)updateQuantity:(id)sender {
}

@end
