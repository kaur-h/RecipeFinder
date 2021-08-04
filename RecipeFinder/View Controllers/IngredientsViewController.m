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

@interface IngredientsViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfIngredients;
@property (weak, nonatomic) IBOutlet UIButton *addIngredientButton;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIButton *viewRecipesButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *pickerData;
@property (nonatomic, strong) NSArray *selectedIngredients;
@end

@implementation IngredientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setting data source & delegate for table source
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    [self fetchIngredients];
    
    self.addIngredientButton.layer.cornerRadius = 4;
    self.viewRecipesButton.layer.cornerRadius = 4;
    
    self.pickerData = [[NSArray alloc] initWithObjects:@"All Ingredients", @"Dairy", @"Vegetables", @"Fruits", @"Baking & Grains", @"Spices", @"Meats", @"Seafood", @"Condiments", @"Oils", @"Seasonings", @"Nuts", @"Other", nil];
    
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
            //find all ingredients that the user has
            NSLog(@"Successfully loaded home feed");
            self.arrayOfIngredients = ingredients;
            self.selectedIngredients = ingredients;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            [self.pickerView selectRow:0 inComponent:0 animated:true];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.selectedIngredients.count;
}

- (UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IngredientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IngredientCell"];
    Ingredient *ingredient = self.selectedIngredients[indexPath.row];
    [cell setIngredient:ingredient];
    return cell;
}

- (IBAction)viewRecipesTapped:(id)sender {
    UINavigationController *navController = self.tabBarController.viewControllers[1];
    RecipeViewController *recipeController = navController.viewControllers[0];
    recipeController.userIngredients = self.arrayOfIngredients;
    [self.tabBarController setSelectedIndex:1];
}

- (void) swipedTableCell: (UITapGestureRecognizer *) sender{
    //Finding out on what cell in table view the tap gesture was called for
    CGPoint location = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    IngredientCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [UIView animateWithDuration:1 delay:0.05 options:0 animations:^{cell.progressView.alpha = 1;
        [cell.progressView setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
        cell.progressView.backgroundColor = [UIColor redColor];} completion:^(BOOL finished){
            NSLog(@"Color transformation Completed");
            //Locating the ingredient corresponding to the cell and deleting it
            PFQuery *ingredientQuery = [Ingredient query];
            [ingredientQuery getObjectInBackgroundWithId:[cell.ingredient objectId] block:^(PFObject *parseObject, NSError *error) {
                if(parseObject){
                    NSLog(@"Object found and is being deleted");
                    cell.progressView.backgroundColor = [UIColor clearColor];
                    cell.progressView.frame = CGRectMake(349, 6, 45, 46);
                    [parseObject delete];
                    [self fetchIngredients];
                }
            }];
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.pickerData[row];
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

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //makes a query based on what category of ingredients the user wants to view
    [self getCategoriedIngredients:self.pickerData[row]];
    [self.tableView reloadData];
}

- (void) getCategoriedIngredients: (NSString *) category{
    //if the user wants to see all ingredients then do not need to make an extra query
    if([category isEqual:@"All Ingredients"]){
        self.selectedIngredients = self.arrayOfIngredients;
        [self.tableView reloadData];
        return;
    }
    // construct query
    PFQuery *ingredientQuery = [Ingredient query];
    [ingredientQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [ingredientQuery whereKey:@"category" equalTo:category];
    
    // fetch data asynchronously
    [ingredientQuery findObjectsInBackgroundWithBlock:^(NSArray<Ingredient *> * _Nullable ingredients, NSError * _Nullable error) {
        if (ingredients) {
            //set the data to display to the result of the query
            self.selectedIngredients = ingredients;
            [self.tableView reloadData];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
