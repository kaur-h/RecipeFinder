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

@interface RecipeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property (weak, nonatomic) IBOutlet UIPickerView *recipeDisplayPicker;
@property (nonatomic, strong) NSArray *arrayOfRecipes;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, strong) NSArray *selectedRecipes;
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
//    [self findRecipes];
    
    //Collection View Layout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.topCollectionView.collectionViewLayout;
    
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = (self.topCollectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    layout.itemSize = CGSizeMake( itemWidth, (itemWidth - layout.sectionInset.top)*1.5);
    
}

-(void) findRecipes{
    
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

-(void) fetchAllRecipes{
    PFQuery *recipeQuery = [Recipe query];
    [recipeQuery includeKey:@"user"];
    
    [recipeQuery findObjectsInBackgroundWithBlock:^(NSArray<Recipe *> * _Nullable recipes, NSError * _Nullable error) {
        if (recipes) {
            // do something with the data fetched
            NSLog(@"Successfully loaded recipes");
            self.arrayOfRecipes = recipes;
            self.selectedRecipes = recipes;
            [self.topCollectionView reloadData];
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

-(void) deleteExistingRecipes{
    
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

-(BOOL) isExistingRecipe: (NSString *)name{
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
    if(row == 1 || row == 2){
        NSArray *chosenRecipes = [self seperateRecipes:row];
        self.selectedRecipes = [[NSArray alloc] initWithArray:chosenRecipes];
        if(row == 2){
            self.selectedRecipes = [self sortRecipes:self.selectedRecipes];
            NSLog(@"");
            for(Recipe *x in self.selectedRecipes){
                NSLog(@"%i", [x.usedIngredientCount intValue]);
            }
        }
    }
    else{
        self.selectedRecipes = [[NSArray alloc] initWithArray:self.arrayOfRecipes];
    }
    [self.topCollectionView reloadData];
}

-(NSArray *) seperateRecipes: (NSInteger)selection{
    NSMutableArray *chosenRecipes = [[NSMutableArray alloc] init];
    for(Recipe *currRecipe in self.arrayOfRecipes){
        //Need to only select the recipes that have 0 missing ingredients
        if(selection == 1 && [currRecipe[@"missedIngredientCount"] intValue] == 0){
            [chosenRecipes addObject:currRecipe];
        }
        //Need to select the recipes that have more than 1 missing ingredients
        else if(selection == 2 && [currRecipe[@"missedIngredientCount"] intValue] > 0){
            [chosenRecipes addObject:currRecipe];
        }
    }
    return chosenRecipes;
}

-(NSArray *)sortRecipes: (NSArray *)recipes{
    NSMutableArray *sortedRecipes = [[NSMutableArray alloc] initWithArray:recipes];
    NSInteger arrLength = sortedRecipes.count;
    
    for(int i = 0; i < arrLength - 1; i++){
        for(int j = 0; j < arrLength - i - 1; j++){
            
            int currMissedIngredientCount = [sortedRecipes[j][@"missedIngredientCount"] intValue];
            int nextMissedIngredientCount = [sortedRecipes[j+1][@"missedIngredientCount"] intValue];
            
            int currUsedIngredientCount = [sortedRecipes[j][@"usedIngredientCount"] intValue];
            int nextUsedIngredientCount = [sortedRecipes[j+1][@"usedIngredientCount"] intValue];
            
            NSString *currTitle = sortedRecipes[j][@"title"];
            NSString *nextTitle = sortedRecipes[j+1][@"title"];
            
            
            //Sorting based on missed ingredient count
            if(currMissedIngredientCount > nextMissedIngredientCount){
                [sortedRecipes exchangeObjectAtIndex:j withObjectAtIndex:(j+1)];
            }
            //if missed ingredient count is the same then sort based on used ingredient count
            else if((currMissedIngredientCount == nextMissedIngredientCount) && (currUsedIngredientCount > nextUsedIngredientCount)){
                    [sortedRecipes exchangeObjectAtIndex:j withObjectAtIndex:(j+1)];
            }
            //if used and missed ingredient count are the same then sort based on recipe title
            else if((currMissedIngredientCount == nextMissedIngredientCount) && (currUsedIngredientCount == nextUsedIngredientCount) && ([currTitle compare:nextTitle] == NSOrderedDescending)){
                [sortedRecipes exchangeObjectAtIndex:j withObjectAtIndex:(j+1)];
            }
        }
    }

    return sortedRecipes;
}


@end
