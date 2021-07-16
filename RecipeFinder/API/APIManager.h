//
//  APIManager.h
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/16/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject
+ (instancetype)shared;
- (void)getAutoCompleteIngredientSearch:(void(^)(NSDictionary *ingredients, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
