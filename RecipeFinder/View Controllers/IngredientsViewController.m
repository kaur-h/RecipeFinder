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
#import "RecipeViewController.h"

@interface IngredientsViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
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
    
    //Swipe Gesture
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedTableCell:)];
    recognizer.delegate = self;
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableView addGestureRecognizer:recognizer];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(fetchIngredients) name:@"refreshIngredients" object:nil];
}

- (void) fetchIngredients{
    // construct query
    PFQuery *ingredientQuery = [Ingredient query];
    [ingredientQuery orderByDescending:@"createdAt"];
    [ingredientQuery includeKey:@"user"];
    [ingredientQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    
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
    UINavigationController *navController = self.tabBarController.viewControllers[1];
    RecipeViewController *recipeController = navController.viewControllers[0];
    recipeController.userIngredients = self.arrayOfIngredients;
    [self.tabBarController setSelectedIndex:1];
}

-(void) swipedTableCell: (UITapGestureRecognizer *) sender{

    //Finding out on what cell in table view the tap gesture was called for
    CGPoint location = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    IngredientCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    
    [UIView animateWithDuration:0.5 delay:0.05 options:0 animations:^{cell.progressView.alpha = 1;
        [cell.progressView setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
        cell.progressView.backgroundColor = [UIColor redColor];} completion:^(BOOL finished){
            NSLog(@"Color transformation Completed");
            //Locating the ingredient corresponding to the cell and deleting it
            PFQuery *ingredientQuery = [Ingredient query];
            [ingredientQuery getObjectInBackgroundWithId:[cell.ingredient objectId] block:^(PFObject *parseObject, NSError *error) {
                if(parseObject){
                    NSLog(@"Object found and is being deleted");
                    [parseObject delete];
                    [self fetchIngredients];
                }
            }];
    }];
    

}


@end
