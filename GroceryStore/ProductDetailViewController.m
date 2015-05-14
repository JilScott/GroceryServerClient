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
    sessionConfig.HTTPAdditionalHeaders = @{
                                            @"product"       : self.productName,
                                            @"Content-Type"  : @"application/json"
                                            };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:productURL]];
    URLRequest.HTTPMethod = @"DELETE";
    
    //create task
    NSURLSessionDataTask *deleteProduct = [session dataTaskWithRequest:URLRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
                NSHTTPURLResponse *httpResp =
                (NSHTTPURLResponse *) response;
                if (httpResp.statusCode == 200) {
                    NSError *jsonError;
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        
                    if (!jsonError) {
                        NSLog(@"%@", jsonDict);
                        dispatch_async(dispatch_get_main_queue(), ^{
        
                            //update UI
                            self.productQuantityLabel.text = @"0";

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
