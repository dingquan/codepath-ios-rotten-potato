# codepath-ios-rotten-potato
# Rotten Tomato client

This is an iOS demo application for displaying the latest box office movies using the [RottenTomatoes API](http://www.rottentomatoes.com/). See the [RottenTomatoes Networking Tutorial](http://guides.thecodepath.com/android/RottenTomatoes-Networking-Tutorial) on our cliffnotes for a step-by-step tutorial.

Time spent: hard to track. 20+ hours at least. feels like 40hr/wk full time job :)

Completed user stories:

 * [x] Required: User can view a list of latest box office movies including title, cast and tomatoes rating
 * [x] Required: User can click on a movie in the list to bring up a details page with additional information such as synopsis
 * [x] Optional: Placeholder image is used for movie posters loaded in from the network

 * [x] Required: User can view a list of movies from Rotten Tomatoes. Poster images must be loading asynchronously.
 * [x] Required: User can view movie details by tapping on a cell.
 * [x] Required: User sees loading state while waiting for movies API. 
 * [x] Required: User sees error message when there's a networking error. 
 * [x] Required: User can pull to refresh the movie list. Guide: Using UIRefreshControl
 * [x] Optional: Add a tab bar for Box Office and DVD. (optional)
 * [x] Optional: Implement segmented control to switch between list view and grid view (optional)
 * [x] Optional: Add a search bar. (optional)
 * [x] Optional: All images fade in (optional)
 * [x] Optional: For the large poster, load the low-res image first, switch to high-res when complete (optional)

Notes:

If you are in search result, pull-to-refresh will reset it back to the box office movies list. haven't got time to create a control for it.

Walkthrough of all user stories:

![Video Walkthrough](rottenpotato.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).
