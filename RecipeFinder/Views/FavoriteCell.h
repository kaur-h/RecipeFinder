//
//  FavoriteCell.h
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) Recipe *recipe;
- (void) setRecipe: (Recipe *) recipe;

@end

NS_ASSUME_NONNULL_END
