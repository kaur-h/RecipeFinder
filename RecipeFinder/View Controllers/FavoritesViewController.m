//
//  FavoritesViewController.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/13/21.
//

#import "FavoritesViewController.h"
#import "FavoriteCell.h"
#import "Recipe.h"
#import "RecipeDetailViewController.h"

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *favoritesSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfFavorites;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *filteredData;
@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.favoritesSearchBar.delegate = self;
    
    [self fetchFavoriteRecipes];
    
    //Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = UIColor.blackColor;
    [self.refreshControl addTarget:self action:@selector(fetchFavoriteRecipes) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadTableView) name:@"refreshFavoritesTable" object:nil];
}

- (void) fetchFavoriteRecipes{
    // construct query
    PFQuery *recipeQuery = [Recipe query];
    [recipeQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [recipeQuery whereKey:@"favorited" equalTo:@YES];
    
    // fetch data asynchronously
    [recipeQuery findObjectsInBackgroundWithBlock:^(NSArray<Recipe *> * _Nullable recipes, NSError * _Nullable error) {
        if (recipes) {
            self.arrayOfFavorites = recipes;
            self.filteredData = recipes;
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
    return self.filteredData.count;
}

- (UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteCell"];
    Recipe *recipe = self.filteredData[indexPath.row];
    [cell setRecipe:recipe];
    return cell;
}

- (void) reloadTableView{
    [self fetchFavoriteRecipes];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Recipe *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredData = [self.arrayOfFavorites filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredData = self.arrayOfFavorites;
    }
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.favoritesSearchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.favoritesSearchBar.showsCancelButton = NO;
    self.favoritesSearchBar.text = @"";
    [self fetchFavoriteRecipes];
    [self.favoritesSearchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.tableView reloadData];
    [self.favoritesSearchBar resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString: @"favoriteDetailSegue"]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Recipe *recipe = self.arrayOfFavorites[indexPath.row];
        RecipeDetailViewController *detailController = [segue destinationViewController];
        [detailController displayRecipeInfo:recipe];
    }
}

@end
