//
//  Recipe.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/20/21.
//

#import "Recipe.h"
#import "Parse/Parse.h"

@implementation Recipe

@dynamic objectID;
@dynamic recipeID;
@dynamic title;
@dynamic image;
@dynamic usedIngredientCount;
@dynamic missedIngredientCount;
@dynamic likes;
@dynamic user;

+ (nonnull NSString *)parseClassName {
    return @"Recipe";
}

+(void) initRecipeWithDictionary: (NSDictionary *) data withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    
    Recipe *newRecipe = [Recipe new];
    newRecipe.recipeID = data[@"id"];
    newRecipe.title = data[@"title"];
    
    NSURL *imageURL = [NSURL URLWithString:data[@"image"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *img = [[UIImage alloc] initWithData:imageData];
    newRecipe.image = [self getPFFileFromImage:img];
    
    newRecipe.usedIngredientCount = data[@"usedIngredientCount"];
    newRecipe.missedIngredientCount = data[@"missedIngredientCount"];
    newRecipe.likes = data[@"likes"];
    
    newRecipe.user = [PFUser currentUser];
    
    [newRecipe saveInBackgroundWithBlock: completion];
    
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
