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
    [self favoritedOrNot];
}

-(void) favoritedOrNot{
    //based on if the recipe is in favorites or not change the image displayed on the button
    if([self.recipe[@"favorited"] isEqual:@YES]){
        [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
    }
    else{
        [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    }
}

- (IBAction)favoriteButtonTapped:(id)sender {
    //if already favorited then unfavorite
    if([self.recipe[@"favorited"] isEqual:@YES]){
        self.recipe[@"favorited"] = @NO;
        [self.recipe saveInBackground];
        [self favoritedOrNot];
    }
    else{
        self.recipe[@"favorited"] = @YES;
        [self.recipe saveInBackground];
        [self favoritedOrNot];
    }
}


@end
