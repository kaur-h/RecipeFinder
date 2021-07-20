//
//  RecipeCell.h
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface RecipeCell : UICollectionViewCell
@property (strong, nonatomic) Recipe *recipe;
@property (weak, nonatomic) IBOutlet PFImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (void)setRecipe:(Recipe *)recipe;
@end

NS_ASSUME_NONNULL_END
