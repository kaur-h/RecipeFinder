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

- (void)getAutoCompleteIngredientSearch:(NSString *)text completion:(void(^)(NSArray *ingredientNames, NSArray *ingredientImages, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
