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

-(NSInteger) partition: (NSMutableArray *) arr withLow:(NSInteger)low withHigh:(NSInteger)high{
    //pivot to compare the elements to
    NSInteger partitionPivot = [arr[high][@"missedIngredientCount"] intValue];
    //index that indicates where the elements smaller than the pivot
    NSInteger i = low - 1;
    
    //Goes through the array elements within the low and high range
    for(int j = (int) low; j <= high - 1; j++){
        //if the missed ingredient count of the current element is lower than the pivot then move the element to be at the left of the pivot
        if([arr[j][@"missedIngredientCount"] intValue] < partitionPivot){
            i++;
            [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
        //if the missed ingredient count is the same compare in relation to used ingredient count
        else if(([arr[j][@"missedIngredientCount"] intValue] == partitionPivot) && ([arr[j][@"usedIngredientCount"] intValue] < [arr[high][@"usedIngredientCount"] intValue])){
            i++;
            [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
        //if the used ingredient count is the same then compare in relation to the title of the recipe
        else if(([arr[j][@"usedIngredientCount"] intValue] == [arr[high][@"usedIngredientCount"] intValue]) &&
                ([arr[j][@"title"] compare:arr[high][@"title"]] == NSOrderedAscending)){
            i++;
            [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
    //swap the elements the so the pivot and the last element are in the correct place
    [arr exchangeObjectAtIndex:i+1 withObjectAtIndex:high];
    return i+1;
}

-(void) quickSort:(NSMutableArray *) arr withLow:(NSInteger)low withHigh:(NSInteger)high{
    if(low < high){
        //partition the array
        int q = (int) [self partition:arr withLow:low withHigh:high];
        
        //keep sorting the 2 arrays to the left and right of the partition
        [self quickSort:arr withLow:low withHigh:q-1];
        [self quickSort:arr withLow:q+1 withHigh:high];
    }
}

-(NSArray *) performQuickSort:(NSMutableArray *)arr{
    //Quicksort the array and returned the sorted array
    [self quickSort:arr withLow:0 withHigh:arr.count -1];
    NSArray *retArr = [[NSArray alloc] initWithArray:arr];
    return retArr;
}

@end
