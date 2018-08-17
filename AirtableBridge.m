//
//  AirtableBridge.m
//  AirtableBridgeObjC
//
//  Created by Danilo Campos on 8/16/18.
//  Copyright © 2018 Danilo Campos. All rights reserved.
//

#import "AirtableBridge.h"

NSString *defaultApiRoot = @"https://api.airtable.com/v0";

@interface AirtableBridge ()

@property (copy) NSString *baseId;
@property (copy)NSString *apiKey;
@property (copy) NSString *apiRoot;

@property (readonly) NSURL *baseUrl;

@end

@implementation AirtableBridge



- (instancetype)initWithBaseId:(NSString *)baseId apiKey:(NSString *)key {
    self = [super init];
    if (self) {
        self.baseId = baseId;
        self.apiKey = key;
        self.apiRoot = defaultApiRoot;
    }
    return self;
}

+ (instancetype)bridgeWithBaseId:(NSString *)baseId apiKey:(NSString *)key {
    return [[AirtableBridge alloc] initWithBaseId:baseId apiKey:key];
}

-(NSURL *)baseUrl {
    return [[NSURL URLWithString:defaultApiRoot] URLByAppendingPathComponent:self.baseId];
}

- (NSURL *)urlForTableName:(NSString *)tableName queryDictionary:(NSDictionary *)queryDictionary {
    NSURL *tableUrl = [self.baseUrl URLByAppendingPathComponent:tableName];
    NSURLComponents *components = [NSURLComponents componentsWithURL:tableUrl resolvingAgainstBaseURL:YES];
    
    NSArray *queryItems = @[];
    
    for (NSString *key in queryDictionary) {
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:queryDictionary[key]];
        queryItems = [queryItems arrayByAddingObject:item];
    };
    
    components.queryItems = queryItems;
    
    return components.URL;
}

- (NSURLRequest *)authorizedRequestWithURL:(NSURL *)url {
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:url].mutableCopy;
    request.allHTTPHeaderFields = @{ @"Authorization" : [@"Bearer " stringByAppendingString:self.apiKey] };
    
    return request;
}

- (NSURLSessionDataTask *)loadTable:(NSString *)tableName
                           atOffset:(NSString *)offset
                         maxRecords:(NSInteger)maxRecords
                           viewName:(NSString *)viewName
                  completionHandler:(void (^)(NSDictionary *results, NSString *offset, NSError *error))handler {
    
    if (viewName == nil) {
        viewName = @"Grid view";
    }
    
    NSMutableDictionary *queryItems = @{
                                 @"maxRecords"  : [NSNumber numberWithInteger:maxRecords].stringValue,
                                 @"view" : viewName,
                                 }.mutableCopy;
    
    if (offset) {
        queryItems[@"offset"] = offset;
    }
    
    NSURL *url = [self urlForTableName:tableName queryDictionary:queryItems];
    NSURLRequest *request = [self authorizedRequestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (error) {
                                          NSLog(@"Error %@", error);
                                          handler(nil, nil, error);
                                      } else {
                                          
                                          NSError *parseError = nil;
                                          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:0
                                                                                                 error:&parseError];
                                          
                                          NSMutableDictionary *results = @{}.mutableCopy;
                                          
                                          for (NSDictionary *dictionary in json[@"records"]) {
                                              [results setObject:dictionary[@"fields"] forKey:dictionary[@"id"]];
                                          }
                                          handler(results, json[@"offset"], nil);
                                      }
                                  }];
    
    [task resume];
    return task;
}

- (NSURLSessionDataTask *)loadRecordWithId:(NSString *)recordId
                                 tableName:(NSString *)tableName
                         completionHandler:(void (^)(NSDictionary *results, NSError *error))handler {
   
    NSURL *url = [self.baseUrl URLByAppendingPathComponent:tableName];
    url = [url URLByAppendingPathComponent:recordId];
    NSURLRequest *request = [self authorizedRequestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (error) {
                                          NSLog(@"Error %@", error);
                                          handler(nil, error);
                                      } else {
                                          
                                          NSError *parseError = nil;
                                          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:0
                                                                                                 error:&parseError];
                                          
                                          handler(json[@"fields"], nil);
                                      }
                                  }];
    
    [task resume];
    return task;
}

@end
