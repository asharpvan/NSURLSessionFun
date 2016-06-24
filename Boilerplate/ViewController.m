//
//  ViewController.m
//  Boilerplate
//
//  Created by agatsa on 4/1/16.
//  Copyright © 2016 Agatsa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    
    NSMutableData *remoteData;
}

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
   
    UIButton *callSerially = [[UIButton alloc]initWithFrame:CGRectMake(10, 70 ,self.view.frame.size.width - (20), 60)];
    [callSerially setTitle:@"Serial Call" forState:UIControlStateNormal];
    [callSerially addTarget:self action:@selector(serialCall) forControlEvents:UIControlEventTouchUpInside];
    [callSerially setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:callSerially];
    
    UIButton *callbackButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 140 ,self.view.frame.size.width - (20), 60)];
    [callbackButton setTitle:@"via Call Back" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(viaCallback) forControlEvents:UIControlEventTouchUpInside];
    [callbackButton setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:callbackButton];
    
    UIButton *delegateButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 210 ,self.view.frame.size.width - (20), 60)];
    [delegateButton setTitle:@"via Delegate" forState:UIControlStateNormal];
    [delegateButton addTarget:self action:@selector(viaDelegate) forControlEvents:UIControlEventTouchUpInside];
    [delegateButton setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:delegateButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)serialCall {
    
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



-(NSURLSession *) createDelegateFreeSession {
    
    
    NSURLSessionConfiguration *customConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSString *customCachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/nsurlsessiondemo.cache"];
    
    NSURLCache *myCustomCache = [[NSURLCache alloc] initWithMemoryCapacity: 16384
                                                        diskCapacity: 268435456
                                                            diskPath: customCachePath];
    [customConfiguration setURLCache:myCustomCache];
    [customConfiguration setRequestCachePolicy:NSURLRequestReturnCacheDataElseLoad];

    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: customConfiguration
                                                                      delegate: nil
                                                                 delegateQueue: [NSOperationQueue mainQueue]];
    return delegateFreeSession;
    
}


-(NSURLSession *) createDelegateLoadedSession {
    
    
    NSURLSessionConfiguration *customConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSString *customCachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/nsurlsessiondemo.cache"];
    
    NSURLCache *myCustomCache = [[NSURLCache alloc] initWithMemoryCapacity: 16384
                                                              diskCapacity: 268435456
                                                                  diskPath: customCachePath];
    [customConfiguration setURLCache:myCustomCache];
    [customConfiguration setRequestCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    NSURLSession *delegateLoadedSession = [NSURLSession sessionWithConfiguration: customConfiguration
                                                                      delegate: self
                                                                 delegateQueue: nil];
    return delegateLoadedSession;
    
}


-(void)viaCallback {
    
    NSLog(@"viaCallback");
    
    NSURLSession *callbackSession = [self createDelegateFreeSession];
    
    NSString * completePath = @"https://hackerearth.0x10.info/api/isecure?type=json&query=list_product";
    
    NSURLSessionDataTask *task = [callbackSession dataTaskWithURL:[NSURL URLWithString:completePath] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:
                                                NSJSONReadingAllowFragments| NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:&error];
            
            
            NSLog(@"responseDictionary : %@",responseDictionary);
        }
        else {
            
            NSLog(@"error : %@",[error localizedDescription]);
            
        }
        
    }];
    //start Task
    [task resume];

}

-(void)viaDelegate {
    
    NSLog(@"viaDelegate");
    NSURLSession *delegateSession = [self createDelegateLoadedSession];
    NSString * completePath = @"https://hackerearth.0x10.info/api/isecure?type=json&query=list_product";
    NSURL *url = [NSURL URLWithString:completePath];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    NSURLSessionDownloadTask *task = [delegateSession downloadTaskWithRequest:urlRequest];
    NSURLSessionDataTask *task = [delegateSession dataTaskWithRequest:urlRequest];
    remoteData = [NSMutableData new];
    [task resume];
}


#pragma mark Download Task Delegate Methods
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
  
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSError *error = nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:
                                        NSJSONReadingAllowFragments| NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:&error];
    
    NSLog(@"%s",__func__);
    NSLog(@"responseDictionary : %@",responseDictionary);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
    NSLog(@"%s",__func__);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    int64_t progress = (totalBytesWritten / totalBytesExpectedToWrite);
    
    NSLog(@"totalBytesWritten : %lld%%",totalBytesWritten);
    NSLog(@"totalBytesExpectedToWrite : %lld%%",totalBytesExpectedToWrite);
    
    NSLog(@"\n\nProgress : %lld%%",progress);
}

#pragma mark Data Task Delegate Methods
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    [remoteData appendData:data];
    NSLog(@"%s",__func__);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse
                                        completionHandler:(void (^)(NSCachedURLResponse * __nullable cachedResponse))completionHandler{
    
    NSLog(@"%s",__func__);
    completionHandler(proposedResponse);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    if (error) {
   
        NSLog(@"%s : %@",__func__,error);
    
    }else {
        
        NSError *error = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:remoteData options:
                                            NSJSONReadingAllowFragments| NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:&error];
        NSLog(@"responseDictionary : %@",responseDictionary);
    }
}


@end
