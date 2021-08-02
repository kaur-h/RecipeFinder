//
//  FavoriteCell.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/13/21.
//

#import "FavoriteCell.h"
#import "Recipe.h"

@implementation FavoriteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setRecipe: (Recipe *) recipe{
    _recipe = recipe;
    self.recipeName.text = self.recipe[@"title"];
    self.recipeImage.file = self.recipe[@"image"];
    self.recipeImage.layer.cornerRadius = 5;
    [self.recipeImage loadInBackground];
    [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
}

- (IBAction)favoriteTapped:(id)sender {
    //remove recipe from favorites
    self.recipe[@"favorited"] = @NO;
    [self.recipe saveInBackground];
    [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    [NSNotificationCenter.defaultCenter postNotificationName:@"refreshFavoritesTable" object:nil];
    [NSNotificationCenter.defaultCenter postNotificationName:@"refreshCollectionView" object:nil];
    
}

@end
