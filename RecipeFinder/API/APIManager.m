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

- (void)getAutoCompleteIngredientSearch:(NSString *)text completion:(void(^)(NSArray *ingredientNames, NSArray *ingredientImages, NSError *error))completion {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
         
    NSString *key= [dict objectForKey: @"RapidAPIKey"];
    NSDictionary *headers = @{ @"x-rapidapi-key":key,
                               @"x-rapidapi-host": @"spoonacular-recipe-food-nutrition-v1.p.rapidapi.com" };
    
    NSString *begginingRequest = @"https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/ingredients/autocomplete?query=";
    NSString *endRequest = @"&number=10";
    NSString *fullRequest = [[begginingRequest stringByAppendingString:text] stringByAppendingString:endRequest];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullRequest] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if (error) {
                                                    NSLog(@"%@", error);
                                                    completion(nil, nil, error);
                                                } else {
                                                    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
                                                    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
                                                    for(NSDictionary *innerDictionary in dataDictionary){
                                                        [nameArray addObject:innerDictionary[@"name"]];
                                                        [imageArray addObject:innerDictionary[@"image"]];
                                                    }
                                                    completion(nameArray,imageArray, nil);
                                                }
                                            }];
[dataTask resume];
}


-(void) getRecipesBasedOnIngredients:(NSString *)ingredients completion:(void(^) (NSDictionary *recipes, NSError *error))completion{
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
         
    NSString *key= [dict objectForKey: @"RapidAPIKey"];
    NSDictionary *headers = @{ @"x-rapidapi-key": key,
                           @"x-rapidapi-host": @"spoonacular-recipe-food-nutrition-v1.p.rapidapi.com" };
    
    NSString *begginingRequest = @"https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?ingredients=";
    NSString *endRequest = @"&ignorePantry=true&ranking=2";
    NSString *fullRequest = [[begginingRequest stringByAppendingString:ingredients] stringByAppendingString:endRequest];
    

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullRequest]
                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if (error) {
                                                    NSLog(@"%@", error);
                                                    completion(nil, error);
                                                } else {
                                                    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                    completion(dataDictionary, nil);
                                                }
                                            }];
[dataTask resume];
    
}

-(void) getRecipeInformation:(NSNumber *) ingredientId completion:(void(^) (NSDictionary *information, NSError *error))completion{
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
         
    NSString *key= [dict objectForKey: @"RapidAPIKey"];
    NSDictionary *headers = @{ @"x-rapidapi-key": key,
                           @"x-rapidapi-host": @"spoonacular-recipe-food-nutrition-v1.p.rapidapi.com" };
    
    NSString *begginingRequest = @"https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/";
    NSString *endRequest = @"/information";
    NSString *fullRequest = [[begginingRequest stringByAppendingString:[ingredientId stringValue]] stringByAppendingString:endRequest];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullRequest]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        completion(nil, error);
                                                    } else {
                                                        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                        completion(dataDictionary, nil);
                                                    }
                                                }];
    [dataTask resume];
}

@end
