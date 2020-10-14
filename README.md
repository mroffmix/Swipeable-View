<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->


<p align="center">
  <h1 align="center">Swipeable View</h1>
  <p align="center">
   <a href="https://github.com/github_username/repo_name">
     <img src="https://github.com/mroffmix/SwipebleView/blob/main/Resources/logo.jpg" alt="Logo" width="400">
   </a>
    <br />
    <a href="https://github.com/mroffmix/SwipebleViewExample"><strong>Check usage example »</strong></a>
    <br />
    <br /
    ·
    <a href="https://github.com/mroffmix/SwipebleView/issues">Report Bug</a>
    ·
    <a href="https://github.com/mroffmix/SwipebleView/issues">Request Feature</a>
  </p>
</p>


<!-- Description-->
## Description
Simple "editActionsForRowAt" functionality, written on SWIFTUI 
Can be applied without list to every view. 

![Swipeable View](https://github.com/mroffmix/SwipebleView/blob/main/Resources/WholeScreen.gif)
<!-- Installation-->
## Installation

It requires iOS 14 and Xcode 12!

In Xcode got to `File -> Swift Packages -> Add Package Dependency` and paste inthe repo's url: `https://github.com/mroffmix/SwipebleView`


### Import:

import the package in the file you would like to use it: `import SwipebleView`



### Demo

Added an example project, with **iOS** target: https://github.com/mroffmix/SwipebleViewExample

<!-- USAGE EXAMPLES -->
### Usage

### Create array of actions

```swift
var leftActions = [
        Action(title: "Note", iconName: "pencil", bgColor: .note, action: {}),
        Action(title: "Edit doc", iconName: "doc.text", bgColor: .edit, action: {}),
        Action(title: "New doc", iconName: "doc.text.fill", bgColor: .done, action: {})
    ]   
var rightActions = [Action(title: "Delete", iconName: "trash", bgColor: .delete, action: {})]
```
### Create SwipeableView
```swift
SwipeableView(content: {

  // your view content here
  
  },
  leftActions: Example.leftActions,
  rightActions: Example.rightActions,
  rounded: false)
  .frame(height: 90)
```

![Swipeable View](https://github.com/mroffmix/SwipebleView/blob/main/Resources/IndependedView.gif)

### SwipeableView in container
If you want to use your views in a container, as Table view, you have to ctreate 
```swift
var container = SwManager()
```
And put your SwipeableViews to this container
```swift
SwipeableView(content: {

  // your view here 

},
leftActions: Example.leftActions,
rightActions: Example.rightActions,
rounded: true,
container: container)
.frame(height: 140)
```
Views behaviour in a container

![Swipeable View](https://github.com/mroffmix/SwipebleView/blob/main/Resources/ViewsInAContainer.gif)

<!-- ROADMAP -->
### Roadmap

See the [open issues](https://github.com/mroffmix/Swipeable-View/issues) for a list of proposed features (and known issues).



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch 
3. Commit your Changes 
4. Push to the Branch 
5. Open a Pull Request


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Ilya Mikhailov - [@mix_off](https://twitter.com/mix_off) - mihailoov@gmail.com

Project Link: [https://github.com/mroffmix/SwipebleView](https://github.com/mroffmix/SwipebleView)


