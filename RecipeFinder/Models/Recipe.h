//
//  Recipe.h
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/20/21.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Recipe : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSString *recipeID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *usedIngredientCount;
@property (nonatomic, strong) NSNumber *missedIngredientCount;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic) BOOL favorited;

+(void) initRecipeWithDictionary: (NSDictionary *) data withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
