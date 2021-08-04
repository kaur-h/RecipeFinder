//
//  Ingredient.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/16/21.
//

#import "Ingredient.h"
#import "Parse/Parse.h"

@implementation Ingredient

@dynamic objectID;
@dynamic name;
@dynamic category;
@dynamic image;
@dynamic quantity;
@dynamic createdAtString;
@dynamic user;


+ (nonnull NSString *)parseClassName {
    return @"Ingredient";
}

+ (void) postIngredient: ( UIImage * _Nullable )image withName: ( NSString * _Nullable )name withQuantity: (NSNumber *) quantity withCategory: (NSString *)category withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    
    Ingredient *newIngredient = [Ingredient new];
    newIngredient.name = name;
    newIngredient.image = [self getPFFileFromImage:image];
    newIngredient.quantity = quantity;
    newIngredient.user = [PFUser currentUser];
    newIngredient.category = category;
    
    [newIngredient saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    // get image data and check if that is not nil
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
