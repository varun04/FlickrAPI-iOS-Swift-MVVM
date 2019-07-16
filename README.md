# FlickrPhotosApp iOS Swift
Use Flickr photos API (you can create a developer account and bundle the API key in the source code) to query the photos against the search text entered in the top bar. • Implement network call and after parsing the results, add the placeholder for all the images fetched. Actual images must be fetched lazily • When user scrolls to the bottom of the view show a loader in the footer of the section so as to not block the user and make the network call to fetch next page • When the results of the next page is received, append the photos to the data model and continue the process as long as there are images for the searched term.

USAGE :
Just type any keyword in searchbar to search related images.
