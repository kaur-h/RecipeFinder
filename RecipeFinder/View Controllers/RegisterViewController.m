//
//  RegisterViewController.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/15/21.
//

#import "RegisterViewController.h"
#import "Parse/Parse.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)signUpTapped:(id)sender {
    [self registerUser];
}

- (void) registerUser{
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    //set user properties
    newUser.username = self.usernameTextField.text;
    newUser.password = self.passwordTextField.text;
    newUser.email = self.emailTextField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
            [self performSegueWithIdentifier:@"tabBarSegue" sender:nil];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
