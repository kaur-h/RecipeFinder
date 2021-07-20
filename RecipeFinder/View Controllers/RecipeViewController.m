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

@interface RecipeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;
@property (nonatomic, strong) NSArray *arrayOfRecipes;
@end

@implementation RecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topCollectionView.delegate = self;
    self.bottomCollectionView.delegate = self;
    
    self.topCollectionView.dataSource = self;
    self.bottomCollectionView.dataSource = self;
    
    [self findRecipes];
    [self fetchRecipes];
    
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

    [[APIManager shared] getRecipesBasedOnIngredients:fullIngredientsList completion:^(NSDictionary *recipes, NSError *error){
        if(error){
            NSLog(@"Error");
        }
        else{
            for(NSDictionary *innerDictionary in recipes){
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
    }];
}

-(void) fetchRecipes{
    PFQuery *recipeQuery = [Recipe query];
    [recipeQuery includeKey:@"user"];
    
    [recipeQuery findObjectsInBackgroundWithBlock:^(NSArray<Recipe *> * _Nullable recipes, NSError * _Nullable error) {
        if (recipes) {
            // do something with the data fetched
            NSLog(@"Successfully loaded home feed");
            self.arrayOfRecipes = recipes;
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
    Recipe *recipe = self.arrayOfRecipes[indexPath.row];
    [cell setRecipe:recipe];
   return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.arrayOfRecipes.count;
}


@end
