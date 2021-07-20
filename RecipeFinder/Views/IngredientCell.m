//
//  IngredientCell.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/13/21.
//

#import "IngredientCell.h"
#import "Ingredient.h"

@implementation IngredientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIngredient:(Ingredient *)ingredient {
    _ingredient = ingredient;
    self.ingredientName.text = ingredient[@"name"];
    self.ingredientQuantity.text = [NSString stringWithFormat: @"%@", ingredient[@"quantity"]];
    self.ingredientImage.file = ingredient[@"image"];
    [self.ingredientImage loadInBackground];
}

@end
