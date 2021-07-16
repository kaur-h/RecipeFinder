//
//  APIManager.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/16/21.
//

#import "APIManager.h"
#import <Foundation/Foundation.h>

static NSString * const baseURLString = @"";

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)getAutoCompleteIngredientSearch:(void(^)(NSDictionary *ingredients, NSError *error))completion {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
         
    NSString *key= [dict objectForKey: @"RapidAPIKey"];
    NSDictionary *headers = @{ @"x-rapidapi-key":key,
                               @"x-rapidapi-host": @"spoonacular-recipe-food-nutrition-v1.p.rapidapi.com" };

NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/ingredients/autocomplete?query=appl&number=10&intolerances=egg"]
                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval:10.0];
[request setHTTPMethod:@"GET"];
[request setAllHTTPHeaderFields:headers];

NSURLSession *session = [NSURLSession sharedSession];
NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if (error) {
                                                    NSLog(@"%@", error);
                                                } else {
                                                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//                                                    NSLog(@"%@", httpResponse);
                                                    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                    NSLog(@"%@", dataDictionary);
                                                }
                                            }];
[dataTask resume];
}

@end
