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

@interface AddIngredientsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *autoCompleteTableView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) NSArray *autocompleteResults;
@end

@implementation AddIngredientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addButton.layer.cornerRadius = 5;
    self.backgroundView.layer.cornerRadius = 10;
    
    self.nameTextField.delegate = self;
    
    self.autoCompleteTableView.delegate = self;
    self.autoCompleteTableView.dataSource = self;
    self.autoCompleteTableView.scrollEnabled = YES;
    self.autoCompleteTableView.hidden = YES;
    self.autoCompleteTableView.frame = CGRectMake(self.backgroundView.frame.origin.x + self.nameTextField.frame.origin.x, self.backgroundView.frame.origin.y + self.nameTextField.frame.origin.y + self.nameTextField.frame.size.height, 315, 175);
    [self.view addSubview:self.autoCompleteTableView];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = [textField.text stringByAppendingString:string];
    if (string.length == 0) {
        text = [text stringByReplacingCharactersInRange:range withString:@""];
    }
    if (text.length > 0) {
        self.autoCompleteTableView.hidden = NO;
            [[APIManager shared] getAutoCompleteIngredientSearch:text completion:^(NSArray *ingredientNames, NSArray *ingredientImages, NSError *error){
                    if(error){
                        NSLog(@"Error");
                    }
                    else{
                        
                        self.autocompleteResults = [[NSArray alloc] initWithArray:ingredientNames];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.autoCompleteTableView reloadData];
                            });
                    }
                }];
    }
    else {
        self.autoCompleteTableView.hidden = YES;
    }
        
    return YES;
}


- (IBAction)addTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AutocompleteCell"];
    cell.textLabel.text = [self.autocompleteResults objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.nameTextField.text = [self.autocompleteResults objectAtIndex:indexPath.row];
    self.autoCompleteTableView.hidden = YES;
}

@end
