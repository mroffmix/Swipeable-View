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

![Swipeable View](https://github.com/mroffmix/SwipebleView/blob/main/Resources/sample.gif)
<!-- Installation-->
## Installation

It requires iOS 13 and Xcode 11!

In Xcode got to `File -> Swift Packages -> Add Package Dependency` and paste inthe repo's url: `https://github.com/mroffmix/SwipebleView`


### Usage:

import the package in the file you would like to use it: `import SwipebleView`



### Demo

Added an example project, with **iOS** target: https://github.com/mroffmix/SwipebleViewExample


<!-- USAGE EXAMPLES -->
## Usage
```swift


SwipebleView(content: {
    HStack {
        Spacer()
        Text("Swipe left to see values")
        Spacer()
    }
    .frame(maxHeight: .infinity)
    .background(Color.blue)
}, viewModel: example(count: $0))
.frame(height: 100)
```
Create view model with actions (using SwipebleViewModel protocol)

```swift
class example: SwipebleViewModel {
    var count: Int
    @Published var dragOffset: CGSize = CGSize.zero
    @Published var actions: EditActionsVM
    
    init(count: Int) {
        actions =  EditActionsVM([
            Action(title: "Delete", iconName: "trash", bgColor: .delete, action: {/* place your action here */}),
            Action(title: "Edit existing document", iconName: "doc.text", bgColor: .edit, action: {/* place your action here */}),
            Action(title: "New doc", iconName: "doc.text.fill", bgColor: .delete, action: {/* place your action here */}),
            Action(title: "Create", iconName: "pencil.circle", bgColor: .done, action: {/* place your action here */})
        ], maxActions: count)
        self.count = count
    }
}

```

<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/github_username/repo_name/issues) for a list of proposed features (and known issues).



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


