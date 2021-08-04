//
//  AddIngredientsViewController.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/13/21.
//

#import "AddIngredientsViewController.h"
#import "Ingredient.h"
#import "APIManager.h"
#import "IngredientCell.h"
#import "UIImageView+AFNetworking.h"

@interface AddIngredientsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *autoCompleteTableView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (strong, nonatomic) NSArray *autocompleteResults;
@property (strong, nonatomic) NSArray *autocompleteImageNames;
@property (strong, nonatomic) NSString *ingredientImageName;
@property (strong, nonatomic) NSArray *ingredientCategories;
@end

@implementation AddIngredientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addButton.layer.cornerRadius = 5;
    self.backgroundView.layer.cornerRadius = 10;
    
    self.nameTextField.delegate = self;
    self.categoryTextField.delegate = self;
    
    self.ingredientCategories = [[NSArray alloc] initWithObjects:@"Dairy", @"Vegetables", @"Fruits", @"Baking & Grains", @"Spices", @"Meats", @"Seafood", @"Condiments", @"Oils", @"Seasonings", @"Nuts", @"Other", nil];
    
    //autocomplete ingredient name table view
    self.autoCompleteTableView.delegate = self;
    self.autoCompleteTableView.dataSource = self;
    self.autoCompleteTableView.scrollEnabled = YES;
    self.autoCompleteTableView.hidden = YES;
    self.autoCompleteTableView.frame = CGRectMake(self.backgroundView.frame.origin.x + self.nameTextField.frame.origin.x, self.backgroundView.frame.origin.y + self.nameTextField.frame.origin.y + self.nameTextField.frame.size.height, 315, 175);
    [self.view addSubview:self.autoCompleteTableView];
    
    //category table view
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    self.categoryTableView.hidden = YES;
    CGFloat x = self.backgroundView.frame.origin.x + self.categoryTextField.frame.origin.x;
    CGFloat y = self.backgroundView.frame.origin.y + self.categoryTextField.frame.origin.y + self.categoryTextField.frame.size.height;
    self.categoryTableView.frame = CGRectMake(x, y, 315, 175);
    [self.view addSubview:self.categoryTableView];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByAppendingString:string];
    if (string.length == 0) {
        text = [text stringByReplacingCharactersInRange:range withString:@""];
    }
    if([textField isEqual:self.nameTextField]){
        if (text.length > 0) {
            self.autoCompleteTableView.hidden = NO;
                [[APIManager shared] getAutoCompleteIngredientSearch:text completion:^(NSArray *ingredientNames, NSArray *ingredientImages, NSError *error){
                        if(error){
                            NSLog(@"Error");
                        }
                        else{
                            self.autocompleteResults = [[NSArray alloc] initWithArray:ingredientNames];
                            self.autocompleteImageNames = [[NSArray alloc] initWithArray:ingredientImages];
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [self.autoCompleteTableView reloadData];
                            });
                        }
                    }];
        }
        else {
            self.autoCompleteTableView.hidden = YES;
        }
    }
    else if([textField isEqual:self.categoryTextField]){
        if(text.length > 0){
            self.categoryTableView.hidden = NO;
            [self.categoryTableView reloadData];
        }
        else{
            self.categoryTableView.hidden = YES;
        }
    }
    return YES;
}

- (IBAction)addTapped:(id)sender {
    NSString *name = self.nameTextField.text;
    NSNumber *quantity = [NSNumber numberWithInt:[self.quantityTextField.text intValue]];
    NSString *category = self.categoryTextField.text;
    
    NSString *baseURLString = @"https://spoonacular.com/cdn/ingredients_100x100/";
    NSString *fullImageURLString = [baseURLString stringByAppendingString:self.ingredientImageName];
    NSURL *fullImageURL = [NSURL URLWithString:fullImageURLString];

    NSData *data = [NSData dataWithContentsOfURL:fullImageURL];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    [Ingredient postIngredient:img withName:name withQuantity:quantity withCategory:category withCompletion:^(BOOL completed, NSError *error){
        if(completed){
            NSLog(@"Successfully posted ingredient!");
            [NSNotificationCenter.defaultCenter postNotificationName:@"refreshIngredients" object:nil];
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else{
            NSLog(@"Error posting ingredient: %@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AutocompleteCell"];
    if([tableView isEqual:self.autoCompleteTableView]){
        cell.textLabel.text = [self.autocompleteResults objectAtIndex:indexPath.row];
    }
    else if([tableView isEqual:self.categoryTableView]){
        cell.textLabel.text = [self.ingredientCategories objectAtIndex:indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:self.autoCompleteTableView]){
        self.nameTextField.text = [self.autocompleteResults objectAtIndex:indexPath.row];
        self.ingredientImageName = [self.autocompleteImageNames objectAtIndex:indexPath.row];
        self.autoCompleteTableView.hidden = YES;
    }
    else if([tableView isEqual:self.categoryTableView]){
        self.categoryTextField.text = [self.ingredientCategories objectAtIndex:indexPath.row];
        self.categoryTableView.hidden = YES;
    }
}

@end
