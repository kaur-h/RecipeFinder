//
//  FavoritesViewController.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/13/21.
//

#import "FavoritesViewController.h"
#import "FavoriteCell.h"

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *favoritesSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfFavorites;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteCell"];
    return cell;
}

@end
