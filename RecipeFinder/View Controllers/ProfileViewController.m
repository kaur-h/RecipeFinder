//
//  ProfileViewController.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/12/21.
//

#import "ProfileViewController.h"
@import Parse;
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "Ingredient.h"
#import "Recipe.h"

@interface ProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ingredientCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.logoutButton.layer.cornerRadius = 4;
    self.profileImage.layer.cornerRadius = 80;
    
    //getting profile image of user
    PFUser *user = [PFUser currentUser];
    PFFileObject *userProfileFile = user[@"profileImage"];
    if(userProfileFile){
        NSData *imageData = [userProfileFile getData];
        self.profileImage.image = [[UIImage alloc] initWithData:imageData];
    }
    
    
    //displaying username
    self.usernameLabel.text = user.username;
    
    [self displayIngredientsAndFavorites];
   
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(displayIngredientsAndFavorites) name:@"refreshFavoritesTable" object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(displayIngredientsAndFavorites) name:@"refreshCollectionView" object:nil];
}

-(void) displayIngredientsAndFavorites{
    //displaying number of ingredients
    PFQuery *ingredientQuery = [Ingredient query];
    [ingredientQuery includeKey:@"user"];
    [ingredientQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [ingredientQuery findObjectsInBackgroundWithBlock:^(NSArray<Ingredient *> * _Nullable ingredients, NSError * _Nullable error) {
        if (ingredients) {
            self.ingredientCountLabel.text = [NSString stringWithFormat:@"%lu", ingredients.count];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    //displaying number of favorites
    PFQuery *recipeQuery = [Recipe query];
    [recipeQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [recipeQuery whereKey:@"favorited" equalTo:@YES];
    
    // fetch data asynchronously
    [recipeQuery findObjectsInBackgroundWithBlock:^(NSArray<Recipe *> * _Nullable recipes, NSError * _Nullable error) {
        if (recipes) {
            self.favoriteCountLabel.text = [NSString stringWithFormat:@"%lu", recipes.count];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)logoutTapped:(id)sender {
    //Logging out user
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    //Changing the view back to login screen
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
}

- (IBAction)imageTapped:(id)sender {
    NSLog(@"Image Clicked");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use a
    self.profileImage.image = editedImage;
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 1.0);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    [imageFile saveInBackground];

    PFUser *user = [PFUser currentUser];
    [user setObject:imageFile forKey:@"profileImage"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Successfully changed profile picture!");
        }
        else{
            NSLog(@"Error %@", error.localizedDescription);
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
