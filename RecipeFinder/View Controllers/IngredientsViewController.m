//
//  IngredientsViewController.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/12/21.
//

#import "IngredientsViewController.h"
#import "IngredientCell.h"
#import "Ingredient.h"
#import "Parse/Parse.h"

@interface IngredientsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *ingredientSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfIngredients;
@property (weak, nonatomic) IBOutlet UIButton *addIngredientButton;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIButton *viewRecipesButton;
@end

@implementation IngredientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setting data source & delegate for table source
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchIngredients];
    
    self.addIngredientButton.layer.cornerRadius = 4;
    self.viewRecipesButton.layer.cornerRadius = 4;
    
    //Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = UIColor.blackColor;
    [self.refreshControl addTarget:self action:@selector(fetchIngredients) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) fetchIngredients{
    // construct query
    PFQuery *ingredientQuery = [Ingredient query];
    [ingredientQuery orderByDescending:@"createdAt"];
    [ingredientQuery includeKey:@"user"];
    ingredientQuery.limit = 20;
    
    // fetch data asynchronously
    [ingredientQuery findObjectsInBackgroundWithBlock:^(NSArray<Ingredient *> * _Nullable ingredients, NSError * _Nullable error) {
        if (ingredients) {
            // do something with the data fetched
            NSLog(@"Successfully loaded home feed");
            self.arrayOfIngredients = ingredients;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}



- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfIngredients.count;
}

- (UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IngredientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IngredientCell"];
    Ingredient *ingredient = self.arrayOfIngredients[indexPath.row];
    [cell setIngredient:ingredient];
    return cell;
}

- (IBAction)addIngredientsTapped:(id)sender {
}

- (IBAction)viewRecipesTapped:(id)sender {
}

@end
