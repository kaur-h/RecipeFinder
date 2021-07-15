//
//  RegisterViewController.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/15/21.
//

#import "RegisterViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"

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
    //If any of the fields are empty alert the user else perform registration
    if([self.usernameTextField.text isEqual:@""]){
        [self alert:@"Username"];
    }
    else if([self.passwordTextField.text isEqual:@""]){
        [self alert:@"Password"];
    }
    else if([self.emailTextField.text isEqual:@""]){
        [self alert:@"Email"];
    }
    else{
        [self registerUser];
    }
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
            
            //Changing the view to the tab bar
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarScene"];
            myDelegate.window.rootViewController = tabBarController;
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
