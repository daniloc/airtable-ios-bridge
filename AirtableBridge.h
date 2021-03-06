//
//  AirtableBridge.h
//  AirtableBridgeObjC
//
//  Created by Danilo Campos on 8/16/18.
//  Copyright © 2018 Danilo Campos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirtableBridge : NSObject

@property (copy) NSString *baseID;
@property (copy) NSString *apiKey;

+ (instancetype)bridgeWithBaseId:(NSString *)baseId apiKey:(NSString *)key;

- (NSURLSessionDataTask *)loadTable:(NSString *)tableName
                           atOffset:(NSString *)offset
                         maxRecords:(NSInteger)maxRecords
                           viewName:(NSString *)viewName
                  completionHandler:(void (^)(NSDictionary *results, NSString *offset, NSError *error))handler;

- (NSURLSessionDataTask *)loadTable:(NSString *)tableName
                           atOffset:(NSString *)offset
                      filterFormula:(NSString *)filterFormula
                         maxRecords:(NSInteger)maxRecords
                           viewName:(NSString *)viewName
                  completionHandler:(void (^)(NSDictionary *results, NSString *offset, NSError *error))handler;

- (NSURLSessionDataTask *)loadRecordIDs:(NSArray *)recordIDs
                               atOffset:(NSString *)offset
                              tableName:(NSString *)tableName
                               viewName:(NSString *)viewName
                      completionHandler:(void (^)(NSDictionary *results, NSString *offset, NSError *error))handler;

- (NSURLSessionDataTask *)loadRecordWithID:(NSString *)recordID
                                 tableName:(NSString *)tableName
                         completionHandler:(void (^)(NSDictionary *results, NSError *error))handler;

- (NSURLSessionDataTask *)createRecord:(NSDictionary *)record
                               inTable:(NSString *)tableName
                     completionHandler:(void (^)(NSString *newRecordID, NSError *error))handler;

- (NSURLSessionDataTask *)updateRecordID:(NSString *)recordID
                              withFields:(NSDictionary *)fields
                                 inTable:(NSString *)tableName
                       completionHandler:(void (^)(NSString *recordID, NSError *error))handler;

- (NSURLSessionDataTask *)deleteRecord:(NSString *)recordID
                               inTable:(NSString *)tableName
                     completionHandler:(void(^)(BOOL deletedSuccessfully, NSError *error))handler;

@end
