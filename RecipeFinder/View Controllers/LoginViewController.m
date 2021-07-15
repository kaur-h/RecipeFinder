//
//  LoginViewController.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/12/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginButton.layer.cornerRadius = 4;
    self.signUpButton.layer.cornerRadius = 4;
}

- (IBAction)loginTapped:(id)sender {
    if([self.usernameTextField.text isEqual:@""]){
        [self alert:@"Username"];
    }
    else if([self.passwordTextField.text isEqual:@""]){
        [self alert:@"Password"];
    }
    else{
        [self loginUser];
    }
}

- (void) loginUser{
    //get the username and password entered by user and login asynchronously
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"tabBarSegue" sender:nil];
        }
    }];
}

- (void) alert: (NSString *)field{
    //Compose error message
    NSString *message = [field stringByAppendingString:@" field is empty!"];
    
    //instantiate the alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                               message:message
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    //present the alert
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

@end
