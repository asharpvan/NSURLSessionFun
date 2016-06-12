//
//  ViewController.m
//  Boilerplate
//
//  Created by agatsa on 4/1/16.
//  Copyright © 2016 Agatsa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(instancetype) init {
    
    self = [super init];
    if(self) {
       
        [self setTitle:@"Title"];
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    // Do any additional setup after loading the view, typically from a nib.
//    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
//    NSString * completePath = @"https://hackerearth.0x10.info/api/isecure?type=json&query=list_product";
//    
//    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:completePath] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        if (!error) {
//            
//            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:
//                                                NSJSONReadingAllowFragments| NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:&error];
//            
//         
//            NSLog(@"responseDictionary : %@",responseDictionary);
//        }
//        else {
//            
//            NSLog(@"error : %@",[error localizedDescription]);
//            
//        }
//        
//    }];
//    //start Task
//    [task resume];
    
    
    
//Calling calls serially
    NSURLSession *session = [NSURLSession sharedSession];
    
    __block NSURLSessionTask *task1 = nil;
    __block NSURLSessionTask *task2 = nil;
    __block NSURLSessionTask *task3 = nil;
    
    task1 = [session dataTaskWithURL:[NSURL URLWithString:@"https://github.com"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // CHECK ERROR
        NSLog(@"1 %@",response);
        [task2 resume];
    }];
    task2 = [session dataTaskWithURL:[NSURL URLWithString:@"https://apple.com"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // CHECK ERROR
                NSLog(@"2 %@",response);
        [task3 resume];
    }];
    task3 = [session dataTaskWithURL:[NSURL URLWithString:@"https://google.com"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // CHECK ERROR
                NSLog(@"3 %@",response);
    }];
    
    [task1 resume];
    
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
