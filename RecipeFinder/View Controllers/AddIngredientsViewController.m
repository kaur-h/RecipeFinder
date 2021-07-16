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

@interface AddIngredientsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (strong,nonatomic) UITableView *autocompleteTableView;
@property (strong, nonatomic) NSArray *autocompleteResults;
@end

@implementation AddIngredientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addButton.layer.cornerRadius = 5;
    self.autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, 320, 120) style:UITableViewStylePlain];
    self.autocompleteTableView.delegate = self;
    self.autocompleteTableView.dataSource = self;
    self.autocompleteTableView.scrollEnabled = YES;
    self.autocompleteTableView.hidden = YES;
    [self.view addSubview:self.autocompleteTableView];
    
}
- (IBAction)addTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)endEditingIngredientName:(id)sender {
    NSLog(@"Editing End");
}


- (IBAction)editingIngredientName:(id)sender {
    NSLog(@"ingredient name changed");
    [[APIManager shared] getAutoCompleteIngredientSearch:^(NSDictionary *ingredients, NSError *error){
            if(error){
                NSLog(@"Error");
            }
            else{
                NSLog(@"Here: %@", ingredients);
            }
        }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


@end
