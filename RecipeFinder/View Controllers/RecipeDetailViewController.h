//
//  RecipeDetailViewController.h
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecipeDetailViewController : UIViewController
-(void) displayRecipeInfo:(Recipe *) recipe;
@property (strong, nonatomic) Recipe *recipe;
@end

NS_ASSUME_NONNULL_END
