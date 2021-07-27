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
            });
        }
    }];
}

-(void) displayRecipeInfo:(Recipe *) recipe{
    _recipe = recipe;

}
- (IBAction)viewFullRecipeTapped:(id)sender {
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ExtendedIngredientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExtendedIngredientCell"];
    [cell setIngredient:self.extendedIngredients[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.extendedIngredients.count;
}

@end
