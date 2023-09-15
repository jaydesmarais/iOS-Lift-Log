# CMSC 436 Milestone 1: Health App

## Project Group 42
- Jay Desmarais
- Vernon Edejar

### Milestone 1: April 18, 2023
- The ability to navigate between tabs for workouts, and meals/water.
- The ability to submit workouts and related information like calories burned, time, and length.
- A scrolling view to see entered workouts and their info.
- A counter for the calories burned in a day

The above milestone has been completed and although we are behind the projected timeline by 2 days, we plan to stick to the same milestone schedule.

### Tasks Accomplished
- Adding tab pages for Nutrition and Activity
- Adding a tabbar item to add activity (plus sign)
- Adding navigation and a view for viewing data as well as for editing data (editing is not yet functional but the view is there)
- Adding a sorted list of all completed workouts that can be clicked on to navigate to the more detailed view/edit page
- Adding a calorie counter that counts the last week worth of calories burned

### Difficulties Encountered
- It was more difficult than imagained to work with the new NavigationStack as NavigationView is being deprecated. With little documentation, it was hard to figure out some bugs that appear to occur when combining a NavigationStack with other elements and getting it to behave as we would like.
- There were some challenges in designing how we wanted users to navigate through the app as we though into the future of how users would be interacting with the app as a whole and incorporating new features.
