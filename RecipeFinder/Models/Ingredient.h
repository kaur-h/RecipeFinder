//
//  Ingredient.h
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/16/21.
//
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Ingredient : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSString *createdAtString;

+ (void) postIngredient: ( UIImage * _Nullable )image withName: ( NSString * _Nullable )name withQuantity: (NSNumber *) quantity withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
