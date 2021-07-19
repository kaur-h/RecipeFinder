//
//  IngredientsViewController.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/12/21.
//

#import "IngredientsViewController.h"
#import "IngredientCell.h"

@interface IngredientsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *ingredientSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfIngredients;
@property (weak, nonatomic) IBOutlet UIButton *addIngredientButton;
@end

@implementation IngredientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setting data source & delegate for table source
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.addIngredientButton.layer.cornerRadius = 4;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IngredientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IngredientCell"];
    return cell;
}

- (IBAction)addIngredientsTapped:(id)sender {
}


@end
