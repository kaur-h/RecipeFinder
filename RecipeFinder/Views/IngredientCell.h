//
//  IngredientCell.h
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Ingredient.h"
@import Parse;
 
NS_ASSUME_NONNULL_BEGIN

@interface IngredientCell : UITableViewCell
@property (strong, nonatomic) Ingredient *ingredient;
@property (weak, nonatomic) IBOutlet PFImageView *ingredientImage;
@property (weak, nonatomic) IBOutlet UILabel *ingredientName;
@property (weak, nonatomic) IBOutlet UILabel *ingredientQuantity;
@property (weak, nonatomic) IBOutlet UIView *progressView;

- (void)setIngredient:(Ingredient *)ingredient;

@end

NS_ASSUME_NONNULL_END
