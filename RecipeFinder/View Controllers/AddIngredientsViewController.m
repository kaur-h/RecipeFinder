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
@property (strong, nonatomic) NSArray *autocompleteResults;
@end

@implementation AddIngredientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addButton.layer.cornerRadius = 5;
    
    self.nameTextField.delegate = self;
    
    self.autoCompleteTableView.delegate = self;
    self.autoCompleteTableView.dataSource = self;
    self.autoCompleteTableView.scrollEnabled = YES;
    self.autoCompleteTableView.hidden = YES;
    [self.view addSubview:self.autoCompleteTableView];
    
    self.autocompleteResults = [[NSArray alloc] initWithObjects:@"Egg", @"Butter", @"Milk", nil];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = [textField.text stringByAppendingString:string];
    if (string.length == 0) {
        text = [text stringByReplacingCharactersInRange:range withString:@""];
    }
    if (text.length > 0) {
        self.autoCompleteTableView.hidden = NO;
//            [[APIManager shared] getAutoCompleteIngredientSearch:^(NSDictionary *ingredients, NSError *error){
//                    if(error){
//                        NSLog(@"Error");
//                    }
//                    else{
//                        self.autocompleteResults = ingredients;
//
//                    }
//                }];
        [self.autoCompleteTableView reloadData];
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
    return self.autocompleteResults.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.nameTextField.text = [self.autocompleteResults objectAtIndex:indexPath.row];
    self.autoCompleteTableView.hidden = YES;
}

@end
