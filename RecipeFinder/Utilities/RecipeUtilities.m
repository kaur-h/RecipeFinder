//
//  RecipeUtilities.m
//  RecipeFinder
//
//  Created by Harleen Kaur on 7/22/21.
//

#import "RecipeUtilities.h"
#import "Recipe.h"

@implementation RecipeUtilities

-(NSArray *) seperateRecipes: (NSInteger)selection with: (NSArray *) recipes{
    NSMutableArray *chosenRecipes = [[NSMutableArray alloc] init];
    for(Recipe *currRecipe in recipes){
        //Need to only select the recipes that have 0 missing ingredients
        if(selection == 1 && [currRecipe[@"missedIngredientCount"] intValue] == 0){
            [chosenRecipes addObject:currRecipe];
        }
        //Need to select the recipes that have more than 1 missing ingredients
        else if(selection == 2 && [currRecipe[@"missedIngredientCount"] intValue] > 0){
            [chosenRecipes addObject:currRecipe];
        }
    }
    return chosenRecipes;
}

-(NSArray *)sortRecipes: (NSArray *)recipes{
    NSMutableArray *sortedRecipes = [[NSMutableArray alloc] initWithArray:recipes];
    NSInteger arrLength = sortedRecipes.count;
    
    //Modified version of bubble sort based on three comparators
    for(int i = 0; i < arrLength - 1; i++){
        for(int j = 0; j < arrLength - i - 1; j++){
            
            int currMissedIngredientCount = [sortedRecipes[j][@"missedIngredientCount"] intValue];
            int nextMissedIngredientCount = [sortedRecipes[j+1][@"missedIngredientCount"] intValue];
            
            int currUsedIngredientCount = [sortedRecipes[j][@"usedIngredientCount"] intValue];
            int nextUsedIngredientCount = [sortedRecipes[j+1][@"usedIngredientCount"] intValue];
            
            NSString *currTitle = sortedRecipes[j][@"title"];
            NSString *nextTitle = sortedRecipes[j+1][@"title"];
            
            
            //Sorting based on missed ingredient count
            if(currMissedIngredientCount > nextMissedIngredientCount){
                [sortedRecipes exchangeObjectAtIndex:j withObjectAtIndex:(j+1)];
            }
            //if missed ingredient count is the same then sort based on used ingredient count
            else if((currMissedIngredientCount == nextMissedIngredientCount) && (currUsedIngredientCount > nextUsedIngredientCount)){
                    [sortedRecipes exchangeObjectAtIndex:j withObjectAtIndex:(j+1)];
            }
            //if used and missed ingredient count are the same then sort based on recipe title
            else if((currMissedIngredientCount == nextMissedIngredientCount) && (currUsedIngredientCount == nextUsedIngredientCount) && ([currTitle compare:nextTitle] == NSOrderedDescending)){
                [sortedRecipes exchangeObjectAtIndex:j withObjectAtIndex:(j+1)];
            }
        }
    }

    return sortedRecipes;
}

@end
