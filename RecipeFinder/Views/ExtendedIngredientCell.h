//
//  ExtendedIngredientCell.h
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/27/21.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ExtendedIngredientCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ingredientImage;
@property (weak, nonatomic) IBOutlet UILabel *ingredientName;
@property (weak, nonatomic) IBOutlet UIImageView *includedImage;
@property (strong, nonatomic) NSDictionary *ingredientDetails;
- (void) setIngredient:(NSDictionary *) ingredientInfo;
@end

NS_ASSUME_NONNULL_END
