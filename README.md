# Project 1 - *Flixter*

**Name of your app** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **X** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User sees an app icon on the home screen and a styled launch screen.
- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.
- [x] User sees an error message when there's a networking error.
- [x] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

The following **optional** features are implemented:

- [x] User can tap a poster in the collection view to see a detail screen of that movie
- [x] User can search for a movie.
- [ ] All images fade in as they are loading.
- [ ] User can view the large movie poster by tapping on a cell.
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [ ] Customize the selection effect of the cell.
- [ ] Customize the navigation bar.
- [ ] Customize the UI.
- [ ] Run your app on a real device.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I think that we could talk more about how to lay things out nicely on the screen and different design element.
2. I'd like to talk about scrolling to the bottom of the description in the detail page instead of it just cutting off.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

https://drive.google.com/file/d/1hxzDI1G-SFi7FL1iJOI_KiHm_stU0MIx/view?usp=sharing

Anyone in meta should be able to open this link

## Notes

Describe any challenges encountered while building the app.
- Displaying the movies was difficult until I found the Hint videos and they were very helpful!
- Making the segue to the new detail was a bit tough
- It was difficult to figure out how to test the loading state initially
- generally coding in objective c. I'm not super familiar with the language and although I have gotten much better through this project, it's still tricky and I wish that I had a more comprehensive understanding.
- Doing the spacing for both table view and collection view
- getting keyboard to show up for search bar, but all I had to do was toggle something in the simulator and it worked



## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- FLixter_assets

## License

    Copyright [2022] [Laura Jankowski]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
