//
//  Connection.h
//  Employee
//
//  Created by STC on 9/24/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Connection : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *data;
    NSMutableArray *employees;
}
@property(nonatomic,retain) NSMutableData *data;
@property (nonatomic,retain) NSMutableArray *employees;

-(NSData *)startHTTP:(NSString *)url dictionaryForQuery:(NSDictionary *)dictionary;
- (void)receiveData:(NSData *)responseData;
+(Connection *)init;

@end
