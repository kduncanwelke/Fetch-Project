# Fetch Recipe App 

## Summary
<img width="24%" alt="Recipe List" src="https://github.com/user-attachments/assets/0aeec9e8-d601-4f11-9834-34924be422ac" /> 
<img width="24%" alt="Recipe Detail" src="https://github.com/user-attachments/assets/e3a50417-269a-4eec-877b-fca2e6b719a9" />
<img width="24%" alt="Recipe Filtering" src="https://github.com/user-attachments/assets/4a7cb0d1-9908-413d-a4e3-33f86e792e0f" />
<img width="24%" alt="Recipe List Dark Mode" src="https://github.com/user-attachments/assets/30e9d355-e394-4bcb-9c42-34282362cda1" />

### Overview
This app features two views - one that displays a list of recipes with their names, cuisine types, and small images, and one that displays a detail for a selected recipe. This view includes the name, cuisine type, large image, and links (if available) to a website with the recipe and a YouTube video version of the recipe.

The project uses a MVVM design pattern, and relies on a view model to do most of the logic. The interface was created with SwiftUI, and Swift Concurrency handles the API and image download calls. Users can refresh the list by pulling down on it, which is used here since it is a familiar interaction. 

### Details
If all recipe data is missing an overlay and error information will be displayed, which shows specific errors including missing recipe information, parsing problems due to malformed JSON, or networking problems. 

The recipe list requests its small images as needed, and images in the detail view are also requested on display as needed. Recipes and images alike are cached (recipes in an array and images in their own dictionaries with recipe IDs as keys, for fast lookup). Displaying data from these caches is prioritized, to prevent extra networking calls.

The recipes list view offers searching and filtering options, so users can search by a recipe name or cuisine type, and choose to filter recipes by all, recipes with links, recipes with videos, or recipes with both links and videos. The filter button appears at the upper right and uses a picker to easily convey the selected item. If no results match a user's search, an overlay with feedback about their unsuccessful search will display.

The detail view shows a larger version of the recipe image, along with a caption giving its name and cuisine type. Relevant links show below this information and allow users to tap them to visit each in their browser. The domains for recipe website links are used to convey which site the user will visit, without having to display the entire link. Links and images can be missing for a given recipe, so placeholders show when these are unavailable. 

The interface emphasizes simplicity and uses lists to display data, for a consistent and simple interface. The design supports light and dark mode and is adaptable to various screen sizes. The app supports iOS 17.6 and up, due to using observable and .searchPresentationToolbarBehavior to prevent hiding the filters in the toolbar upon tapping the search bar.

The project includes some Swift Testing of the networking connection, handling malformed or empty data, JSON parsing, and downloading recipes and images.

## Focus Areas
Throughout this app I prioritized features that would help the user, by supplying them with information, allowing them to find what they need, and supplying feedback to prevent confusion.

I focused on the networking and caching elements of this project, as this app's functionality depends on successfully networking to get recipe data to show the user. Without downloading and holding onto the data, the app can't supply any recipes to the user (or allow them manipulate that information) so its usefulness depends on getting the recipe data to begin with.

Next I focused on displaying the recipes in an easy-to-use manner, and giving users the ability to find specific recipes with search and filter features. When presented with a long list of data users may choose to peruse it, but they may also need to find something specific so I provided features to facilitate that. 

Then, in order to prevent confusion, I ensured that the app gives useful feedback for errors and missing information, so users don't get stuck waiting for a screen to load information that's unavailable. I included image placeholders for unloaded images and text placeholders to convey when links are unavailable.

For the sake of good user experience I ensured that the toolbar would not collapse upon tapping the search bar. The toolbar collapsing would prevent users from being able to apply filters while searching (as the toolbar collapse hides the filter button). I also added descriptions to images to ensure that users with screen readers can experience all aspects of the app unhindered. 

## Time Spent
I worked on this project for under two weeks, with variable hours each day based on availability. I allocated a significant portion of my time to learning new skills I needed to apply for this project, including Swift Concurrency and building an app in SwiftUI, which I had not done before (my SwiftUI experience has been with Widgets and Watch apps). I also had to learn how to apply the MVVM design pattern to a SwiftUI project.

The rest of the time I spent coding and building out the functionality, beginning with networking and JSON parsing, then moving into display and manipulation of the recipe data. I focused on the data and networking first, then moved on to the interface, as the core functionality has to be the first priority. I reworked some areas of the code from a version that functioned to one that had better separation of concerns and reusability, and replaced any code that wasn't DRY.

### Trade-offs and Decisions
I decided to open the links to websites and videos in the browser, rather than in a WebView. SwiftUI does not have its own WebView, so I would have had to import the UIKit WebView, which has its own inconsistencies. For the sake of providing a reliable experience for users I chose to open links in the browser, since it is reliable, familiar, and built-in. 

I also chose to display recipes and their details in lists, rather than using a NavigationSplitView, due to aesthetics, consistency of the experience, and personal preference. The visual of moving from one list to another creates a cohesive experience and design, whereas a NavigationSplitView creates two halves that are visually different, with a distinct sidebar. I wanted to avoid the visual distinction of a split view in favor of a more united design that offers the same experience regardless of device. 

## Weakest Part of the Project
The testing is probably the weakest part of this project, as I do not have much experience in testing myself, and only have superficial knowledge of it. I used Swift Testing in this app instead of XCTest, as Swift Testing is a more modern version and likely will be the future of testing for iOS. I focused on tests of the networking, parsing, and caching, but likely only scratched the surface of how Swift Testing can be applied.

## Additional Information
I considered adding favoriting recipes to this app, but decided against it due to time constraints. The feature could be redundant in this case, as a user could simply bookmarking a recipe link  when viewing it in their browser. If the recipe itself were served by the API then a favorite feature might be more useful, since the recipe and its favorite status could be persisted in the app and be available even when the user is offline. Since the API only delivers links to the recipes, however, a favorite within the app would not achieve much more than a bookmark in the browser.

I also discovered a situation where the API delivered data that was likely encoded as UTF-8, but decoded as Windows-1252 before being sent by the API. This resulted in the ś character in the Polish Pancakes recipe name - Polskie Naleśniki - being shown as Å› instead, since it was improperly decoded. I manually replaced the Å› with ś in the function that downloads the recipe, as I wasn't sure how to account for this situation otherwise, since my reading suggested that the data should be corrected in the API.
