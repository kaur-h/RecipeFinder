//
//  RecipeUtilities.h
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/22/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecipeUtilities : NSObject

-(NSArray *) seperateRecipes: (NSInteger)selection with: (NSArray *) recipes;
-(NSArray *)sortRecipes: (NSArray *)recipes;

@end

NS_ASSUME_NONNULL_END
