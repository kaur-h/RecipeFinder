//
//  RecipeDetailViewController.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/14/21.
//

#import "RecipeDetailViewController.h"
#import "Recipe.h"
#import "APIManager.h"
#import "Parse/Parse.h"
#import "ExtendedIngredientCell.h"

@import Parse;
@import Cosmos;

@interface RecipeDetailViewController ()  <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet PFImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *recipeTime;
@property (weak, nonatomic) IBOutlet UIButton *viewFullRecipeButton;
@property (weak, nonatomic) IBOutlet CosmosView *starRatings;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *recipeDetails;
@property (strong, nonatomic) NSArray *extendedIngredients;
@end

@implementation RecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.recipeImage.file = self.recipe[@"image"];
    self.recipeName.text = self.recipe[@"title"];
    
    [self fetchRecipeDetails];
}

-(void) fetchRecipeDetails {
    [[APIManager shared] getRecipeInformation:[self.recipe recipeID] completion:^(NSDictionary *recipeInfo, NSError *error){
        if(error){
            NSLog(@"Error %@", error.localizedDescription);
        }
        else{
            self.recipeDetails = recipeInfo;
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.recipeTime.text = [[NSString stringWithFormat:@"%@", self.recipeDetails[@"readyInMinutes"]] stringByAppendingString:@" mins"];
                self.starRatings.rating = ([self.recipeDetails[@"spoonacularScore"] doubleValue] / 100) * 5;
                self.extendedIngredients = self.recipeDetails[@"extendedIngredients"];
                [self.tableView reloadData];
                [self favoritedOrNot];
            });
        }
    }];
}

-(void) displayRecipeInfo:(Recipe *) recipe{
    _recipe = recipe;

}
- (IBAction)viewFullRecipeTapped:(id)sender {
    NSURL *url = [[NSURL alloc] initWithString:self.recipeDetails[@"sourceUrl"]];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(bool success){
        if(success){
            NSLog(@"Successfully opened url!");
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ExtendedIngredientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExtendedIngredientCell"];
    [cell setIngredient:self.extendedIngredients[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.extendedIngredients.count;
}
- (IBAction)favoriteButtonTapped:(id)sender {
    //if already favorited then unfavorite
    if([self.recipe[@"favorited"] isEqual:@YES]){
        self.recipe[@"favorited"] = @NO;
    }
    else{
        self.recipe[@"favorited"] = @YES;
    }
    [self.recipe save];
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
    [NSNotificationCenter.defaultCenter postNotificationName:@"refreshCollectionView" object:nil];
    [NSNotificationCenter.defaultCenter postNotificationName:@"refreshFavoritesTable" object:nil];
}

@end
