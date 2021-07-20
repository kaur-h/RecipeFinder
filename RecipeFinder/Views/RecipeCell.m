//
//  RecipeCell.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/14/21.
//

#import "RecipeCell.h"
#import "Recipe.h"

@implementation RecipeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRecipe:(Recipe *)recipe{
    _recipe = recipe;
    self.recipeImage.file = recipe[@"image"];
    self.recipeName.text = recipe[@"title"];
    [self.recipeImage loadInBackground];
}

@end
