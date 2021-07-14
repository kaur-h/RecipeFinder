//
//  IngredientCell.h
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/13/21.
//

#import <UIKit/UIKit.h>
@import Parse;
 
NS_ASSUME_NONNULL_BEGIN

@interface IngredientCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *ingredientImage;
@property (weak, nonatomic) IBOutlet UILabel *ingredientName;
@property (weak, nonatomic) IBOutlet UILabel *ingredientQuantity;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

NS_ASSUME_NONNULL_END
