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
<<<<<<< Updated upstream

- (void)getAutoCompleteIngredientSearch:(void(^)(NSDictionary *ingredients, NSError *error))completion;
=======
<<<<<<< HEAD
- (void)getAutocompleteIngredients:(void(^)(NSDictionary *ingredients, NSError *error))completion;
=======

- (void)getAutoCompleteIngredientSearch:(void(^)(NSDictionary *ingredients, NSError *error))completion;
>>>>>>> 4bb776a70622a92f71178b709f7107de67df73ef
>>>>>>> Stashed changes
@end

NS_ASSUME_NONNULL_END
