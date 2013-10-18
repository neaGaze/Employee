//
//  Connection.m
//  Employee
//
//  Created by STC on 9/24/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "Connection.h"
#import "Employee.h"

@implementation Connection

@synthesize data =_data;
@synthesize employees;

/** For singleton object **/
+(Connection *)init
{
    Connection *connection;
    if(connection == nil)
    {
        // self = [super init];
        connection = [[Connection alloc] init];
    }
    return connection;
}

/** Startup a connection with the webservice and  **/
-(NSData *)startHTTP:(NSString *)url dictionaryForQuery:(NSDictionary *)dictionary
{
    NSMutableString *fullUrl = [NSMutableString stringWithFormat:@"http://192.168.100.2/EMSWebService/Service1.svc/json/%@",url];
    employees = [[NSMutableArray alloc] init];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    NSError *error = [[NSError alloc] init];
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSDictionary *dict = dictionary;
    NSData *json = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    //  NSString *stringData = @"{'Username':'jon','Password':'jon'}";
    NSString *stringData = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    //  NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    /** Use synchonous connection **/
    NSURLResponse *response = nil;
    NSData* receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    return receivedData;
    //  [self receiveData:receivedData];
    //  [self performSelectorOnMainThread:@selector(connect:) withObject:request waitUntilDone:YES];
    
}

/** Used for asynchronous connection and invoke self delegate **/
-(void)connect:(NSMutableURLRequest *)req
{
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
}

/** For parsing the results of GetEmployees query **/
- (void)receiveData:(NSData *)responseData {
    //parse out the json data
    NSError *error = [[NSError alloc] init];
    
    NSDictionary *empList = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray *arr = [empList objectForKey:@"GetEmployeeListResult"];
    
    for(NSDictionary *dict in arr){
        [employees addObject:[[Employee alloc] initWithDict:dict]];
        NSLog(@"Dictionary found is: %@ desig: %@",[dict objectForKey:@"EmployeeName"],dict[@"Designation"]);
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    
    _data = [[NSMutableData alloc] init];
    if(_data != nil)
    {
        NSLog(@"Response vayo");
        [self performSelectorOnMainThread:@selector(receiveData:) withObject:_data waitUntilDone:YES];
        //  [self receiveData:_data];
    }
    else{
        NSLog(@"data is empty. Error on retrieving data");
    }}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)nsdata {
    // Append the new data to the instance variable you declared
    [_data appendData:nsdata];
    if(_data != nil)
    {
        NSString *responseDatas = [[NSString alloc] initWithData:_data
                                                        encoding:NSUTF8StringEncoding];
        
        //    NSLog(@"Data received :%@",responseDatas);
        
        [self performSelectorOnMainThread:@selector(receiveData:) withObject:_data waitUntilDone:YES];
        //  [self receiveData:_data];
    }
    else{
        NSLog(@"data is empty. Error on retrieving data");
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    NSString *responseString = [[NSString alloc] initWithData:_data
                                                     encoding:NSUTF8StringEncoding];
    //   NSLog(@"%@",responseString);
    
    NSLog(@"Connection finished Loading");
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    NSLog(@"Error: %@",[error localizedDescription]);
}

@end
