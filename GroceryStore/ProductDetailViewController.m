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
@property (weak, nonatomic) IBOutlet UIStepper *stepperOutlet;

@property (strong, nonatomic) NSMutableURLRequest *URLRequest;
@property (strong, nonatomic) NSString *URLString;
@property (strong, nonatomic) NSURLSession *session;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.productTitleLabel.text = self.productName;
    self.productQuantityLabel.text = [NSString stringWithFormat:@"Current quantity is: %@", self.quantity];
}

- (IBAction)stepped:(UIStepper *)sender
{
    
    self.quantityAdjustmentLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
    
}

- (IBAction)removeAllStock:(id)sender
{
    
    //create session
    [self createSessionWithURLComponent:@"inventory"];
    [self createURLRequestWithHTTPMethod:@"DELETE"];
    
    //create task
    NSURLSessionDataTask *deleteProduct = [self.session dataTaskWithRequest:self.URLRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [self createAndHandleURLResponse:response withData:data];
    }];
    
    //resume
    [deleteProduct resume];
}

- (IBAction)restockProduct:(id)sender
{ //add
    //TODO? Can't stock product not currently/previously in inventory (201)
    [self createSessionWithURLComponent:@"inventory"];
    [self createURLRequestWithHTTPMethod:@"POST"];
    [self implementProductAdjustment];
    
}

- (IBAction)purchaseProduct:(id)sender
{ //subtract
    
    [self createSessionWithURLComponent:@"purchase"];
    [self createURLRequestWithHTTPMethod:@"POST"];
    [self implementProductAdjustment];
}

- (void)createSessionWithURLComponent:(NSString *)URLComponent
{
    
    //create session
    self.URLString = [NSString stringWithFormat:@"http://127.0.0.1:5000/api/%@/%@", URLComponent, self.productName];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
}

- (void)createURLRequestWithHTTPMethod:(NSString *)method
{
    //URL request
    self.URLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.URLString]];
    self.URLRequest.HTTPMethod = method;
    [self.URLRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    //specify amount to add
    NSDictionary *quantityDict = @{@"quantity" : @(self.stepperOutlet.value)};
    
    NSData *quantityToPass = [NSJSONSerialization
                              dataWithJSONObject:quantityDict
                              options:NSJSONWritingPrettyPrinted
                              error:nil];
    [self.URLRequest setHTTPBody:quantityToPass];
}

- (void)implementProductAdjustment
{
    NSURLSessionDataTask *restock = [self.session
                                     dataTaskWithRequest:self.URLRequest
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    [self createAndHandleURLResponse:response withData:data];
                                     }];
    [restock resume];
}

- (void)createAndHandleURLResponse:(NSURLResponse *)response withData:(NSData *)data
{
    
    NSHTTPURLResponse *httpResp =
    (NSHTTPURLResponse *) response;
    if (httpResp.statusCode == 200 || httpResp.statusCode == 201) {
        
        NSError *jsonError;
        
        NSDictionary *jsonDict = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingAllowFragments
                                  error:&jsonError];
        
        if (jsonDict) {
            NSLog(@"%@", jsonDict);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //update UI
                self.productQuantityLabel.text = [NSString stringWithFormat:@"Current quantity is: %@", jsonDict[self.productName]];
                
            });
        }
    }
}

@end
