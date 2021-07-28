//
//  FavoritesViewController.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/13/21.
//

#import "FavoritesViewController.h"
#import "FavoriteCell.h"
#import "Recipe.h"

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *favoritesSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfFavorites;
@property (nonatomic,strong) UIRefreshControl *refreshControl;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
    return self.arrayOfFavorites.count;
}

- (UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteCell"];
    Recipe *recipe = self.arrayOfFavorites[indexPath.row];
    [cell setRecipe:recipe];
    return cell;
}

- (void) reloadTableView{
    [self fetchFavoriteRecipes];
    [self.tableView reloadData];
}

@end
