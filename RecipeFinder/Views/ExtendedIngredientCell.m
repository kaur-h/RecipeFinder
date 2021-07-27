//
//  ExtendedIngredientCell.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/27/21.
//

#import "ExtendedIngredientCell.h"
#import "Parse/Parse.h"
#import "Ingredient.h"

@implementation ExtendedIngredientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setIngredient:(NSDictionary *) ingredientInfo{
    _ingredientDetails = ingredientInfo;
    self.ingredientName.text = ingredientInfo[@"name"];
    
    NSString *baseURLString = @"https://spoonacular.com/cdn/ingredients_100x100/";
    NSString *fullImageURLString = [baseURLString stringByAppendingString:ingredientInfo[@"image"]];
    NSURL *fullImageURL = [NSURL URLWithString:fullImageURLString];

    NSData *data = [NSData dataWithContentsOfURL:fullImageURL];
    UIImage *img = [[UIImage alloc] initWithData:data];
    self.ingredientImage.image = img;
    
    [self isExistingIngredient:ingredientInfo[@"name"] completion:^(bool isExisting, NSError *error){
        if(isExisting){
            self.includedImage.image = [UIImage systemImageNamed:@"checkmark"];
        }
    }];
}

-(void) isExistingIngredient:(NSString *) ingredientName completion:(void(^) (bool isExisting, NSError *error))completion{
    PFQuery *ingredientQuery = [Ingredient query];
    [ingredientQuery orderByDescending:@"createdAt"];
    // fetch data asynchronously
    [ingredientQuery findObjectsInBackgroundWithBlock:^(NSArray<Ingredient *> * _Nullable ingredients, NSError * _Nullable error) {
        if (ingredients) {
            // do something with the data fetched
            for(Ingredient *currIngredient in ingredients){
                if([ingredientName containsString:currIngredient[@"name"]]){
                    completion(true, nil);
                }
            }
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
