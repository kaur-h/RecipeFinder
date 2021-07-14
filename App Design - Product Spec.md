# App Design - Product Spec


## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Data-Models)

## Overview
### Description
This app will let the user enter whatever ingredients they have available at the moment and will be able to find recipes that contain most of those ingredients. The user will be provided with links to the recipes that are accessible online. 

### App Evaluation
Categories:
- **Mobile:** The user experience will be uniquely mobile as it will allow the user to use the camera in order to detect ingredients and will also be able to push notifications to remind the user if a logged ingredient is about to expire.
- **Story:** Allows user to make their life more convenient by keeping track of what ingredients they already have and what they can make from those.
- **Market:** Useful app for college students or anyone that needs help finding recipes and do not have to search online for every single ingredients.
- **Habit:** Will notify user if they haven't used an ingredient that they already have or if they havent used the app to find a recipe in a while.
- **Scope:** Can start out as just a recipe finder but has potential to build into a more nutritional based app.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can create an account
* User can login and logout successfully 
* User can add ingredients that they have
* User can search for ingredients
* User can view a list of ingredients that they inputted
* User can view a list of recipes that can be made from the ingredients


**Optional Nice-to-have Stories**

* User can like/unlike a recipe to store to their favorites
* User can be notified when an ingredient is about to expire
* User will be able to take photos of ingredients for recognition
* User can scroll through recipes if they want to browse

### 2. Screen Archetypes

* Login Screen
    * User can login
* Registration Screen
    * User can create a new account
* Ingredients Screen
    * User can view all the ingredients they have listed
    * User can add new ingredients
    * User can search for ingredients
* Recipe Screen
    * User can find new recipes
    * User can view a list of popular recipes
* Favorite Screen
    * User can view the recipes that they have favorited

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Recipes
* Ingredients
* Favorites
* Profile

**Flow Navigation** (Screen to Screen)

* Login Screen
   * Profile
* Registration Screen
   * Profile
* Ingredients Screen
    * Recipes 
* Recipe Screen
    * None

# Wireframes
![](https://i.imgur.com/dyoTBqT.jpg)

# APIs
API: 
https://rapidapi.com/edamam/api/recipe-search-and-diet/

API Documentation:
https://developer.edamam.com/edamam-docs-recipe-api

# Data Models
Model: Ingredient

| Property | Type   | Description |
| -------- | ------ | -------- |
| objectId | String | unique id for the ingredient |
| name     | String | name of the ingredient |
| quantity | Number | amount of ingredient|
| category | String | category the ingredient falls into|
|image | File | image of the ingredient
| addedAt | DateTime | date when the user added the ingredient

Model: Recipe

| Property | Type | Description |
| -------- | -------- | -------- |
| objectId | String   | unique id for the recipe |
| name | String | name of the recipe|
| image | File | image to be displayed of the recipe|
| rating | Number | number of stars the recipe has
| cookTime | DateTime | the time it takes to cook the recipe|
| favorite | Boolean | indicates if the recipe is in the user's favorite or not
| url | String | link to the full recipe
| ingredientList | Array of Pointer to Ingredient | all the ingredients in the recipe that the user has

Model: User


| Property | Type  | Description |
| -------- | -------- | -------- |
| username | String   | user's name |
| password | String | user's password | 
| email | String | user's email |
| image | File | user's profile image |
| ingredientList | Array of Pointer to Ingredient | the ingredients the user has already added|
| favoriteList | Array of Pointer to Recipe | the recipes that the user has favorited



# Parse Network Requests
List of network requests by screen:

* Ingredient Screen
    * (Read/GET) If the user is signed in then fetch all the ingredients that the user has added
    * (Create/POST) Add ingredients to the list
    * (Delete) Delete ingredient from the list
* Recipe Screen
    * (Create/POST) Create new recipe objects
    * (Update/PUT) Update recipe if the user adds to favorite
* Favorite Screen
    * (Read/GET) If the user is signed in then fetch all the recipes that they have favorited
    * (Delete) Delete recipe from favorite
* Profile Screen
    * (Read/GET) Query logged in user object
    * (Update/PUT) Update the user object


