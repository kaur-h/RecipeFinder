//
//  RecipeViewController.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/12/21.
//

#import "RecipeViewController.h"
#import "RecipeCell.h"
#import "APIManager.h"
#import "Ingredient.h"
#import "Recipe.h"
#import "RecipeUtilities.h"
#import "RecipeDetailViewController.h"

@interface RecipeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property (weak, nonatomic) IBOutlet UIPickerView *recipeDisplayPicker;
@property (nonatomic, strong) NSArray *arrayOfRecipes;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, strong) NSArray *selectedRecipes;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@end

@implementation RecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //CollectionView setup
    self.topCollectionView.delegate = self;
    self.topCollectionView.dataSource = self;
    
    //UIPicker setup
    self.pickerData = [[NSArray alloc] initWithObjects: @"All Recipes", @"Ready to make Recipes", @"Recipes missing one or more ingredients", nil];
    self.recipeDisplayPicker.delegate = self;
    self.recipeDisplayPicker.dataSource = self;

    [self fetchAllRecipes];
    [self findRecipes];
    
    //CollectionView Layout setup
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.topCollectionView.collectionViewLayout;
    
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    
    CGFloat recipesPerLine = 2;
    CGFloat itemWidth = (self.topCollectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing * (recipesPerLine - 1)) / recipesPerLine;
    layout.itemSize = CGSizeMake( itemWidth, (itemWidth - layout.sectionInset.top)*1.5);
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadCollectionView) name:@"refreshCollectionView" object:nil];
    
    //Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = UIColor.blackColor;
    [self.refreshControl addTarget:self action:@selector(fetchAllRecipes) forControlEvents:UIControlEventValueChanged];
    [self.topCollectionView insertSubview:self.refreshControl atIndex:0];
    
}

- (void) findRecipes{
    //extracting the string with the ingredient names
    NSString *fullIngredientsList = @"";
    NSString *delimeter = @"%2C";

    for(Ingredient *ingredient in self.userIngredients){
        fullIngredientsList = [[ingredient[@"name"] stringByAppendingString:delimeter] stringByAppendingString:fullIngredientsList];
    }
    fullIngredientsList = [fullIngredientsList substringToIndex:fullIngredientsList.length - 3];

    //Making an API call to get the recipes
    [[APIManager shared] getRecipesBasedOnIngredients:fullIngredientsList completion:^(NSDictionary *recipes, NSError *error){
        if(error){
            NSLog(@"Error");
        }
        else{
            //if API call successful then initiate the recipes returned
            dispatch_sync(dispatch_get_main_queue(), ^{
                for(NSDictionary *innerDictionary in recipes){
                    //if recipe title does not already exists in parse then add the recipe
                    if([self isExistingRecipe:innerDictionary[@"title"]] == false){
                        
                        [Recipe initRecipeWithDictionary:innerDictionary withCompletion:^(BOOL completed, NSError *error){
                            if(completed){
                                NSLog(@"Successfully posted recipe!");
                            }
                            else{
                                NSLog(@"Error posting recipe: %@", error.localizedDescription);
                            }
                        }];
                    }
                }
            });
            //reload the collection view with the newly added recipes
            [self fetchAllRecipes];
        }
    }];
}

- (void) fetchAllRecipes{
    PFQuery *recipeQuery = [Recipe query];
    [recipeQuery includeKey:@"user"];
    [recipeQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [recipeQuery findObjectsInBackgroundWithBlock:^(NSArray<Recipe *> * _Nullable recipes, NSError * _Nullable error) {
        if (recipes) {
            NSLog(@"Successfully loaded recipes");
            self.arrayOfRecipes = recipes;
            self.selectedRecipes = recipes;
            [self.topCollectionView reloadData];
            [self.refreshControl endRefreshing];
            [self.recipeDisplayPicker selectRow:0 inComponent:0 animated:true];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RecipeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecipeCell" forIndexPath:indexPath];
    Recipe *recipe = self.selectedRecipes[indexPath.row];
    [cell setRecipe:recipe];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.selectedRecipes.count;
}

- (void) deleteExistingRecipes{
    __block NSArray<Recipe *> *recipesToDelete;
    PFQuery *recipeQuery = [Recipe query];
    
    [recipeQuery findObjectsInBackgroundWithBlock:^(NSArray<Recipe *> * _Nullable recipes, NSError * _Nullable error) {
        if (recipes) {
            // do something with the data fetched
            recipesToDelete = [[NSArray alloc] initWithArray:recipes];
            NSLog(@"In update ingredient method %lu", recipesToDelete.count);
            
            [PFObject deleteAllInBackground:recipesToDelete block:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    // The array of objects was successfully deleted.
                    NSLog(@"Deleted all recipes");
                    [self findRecipes];
                    
                } else {
                    // There was an error. Check the errors localizedDescription.
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (BOOL) isExistingRecipe: (NSString *)name{
    //Goes through all recipes and if any of the recipe's name matches the parameter then recipe already exists
    for(Recipe *currRecipe in self.arrayOfRecipes){
        if([currRecipe[@"title"] isEqualToString:name]){
            return true;
        }
    }
    return false;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.pickerData[row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    RecipeUtilities *recipeUtil = [[RecipeUtilities alloc] init];
    //If user does want to see all recipes, seperate them based on user choice
    if(row == 1 || row == 2){
        NSArray *chosenRecipes = [recipeUtil seperateRecipes:row with:self.arrayOfRecipes];
        self.selectedRecipes = [[NSArray alloc] initWithArray:chosenRecipes];
        
        //If user wants to see recipes with more than one missing ingredients then sort the recipes
        if(row == 2){
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.selectedRecipes];
            self.selectedRecipes = [recipeUtil performQuickSort:arr];
        }
    }
    //The user wants to see all the recipes
    else{
        self.selectedRecipes = [[NSArray alloc] initWithArray:self.arrayOfRecipes];
    }
    //Reload the recipes that the user sees
    [self.topCollectionView reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont fontWithName:@"Didot" size:20];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    [pickerLabel setText:[self.pickerData objectAtIndex:row]];
    return pickerLabel;
}

- (void)reloadCollectionView{
    [self fetchAllRecipes];
    [self.recipeDisplayPicker reloadAllComponents];
    [self.recipeDisplayPicker selectRow:0 inComponent:0 animated:true];
    [self.topCollectionView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString: @"recipeDetailsSegue"]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.topCollectionView indexPathForCell:tappedCell];
        Recipe *recipe = self.selectedRecipes[indexPath.row];
        RecipeDetailViewController *detailController = [segue destinationViewController];
        [detailController displayRecipeInfo:recipe];
    }
}

@end
