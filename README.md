# HueInspired 
<img src="Images/screenshot_table.png" width="200"> <img src="Images/screenshot_detail.png" width="200">

## Application Description

An application that helps artists discover inspiration from their photo collection. It picks a series of dominant colors from a photo to form a color palette. Users can see the currently trending photos on Flickr transformed as palettes as well as their own photo collection. Under the hood we use leverage Vanilla NSURLSessions with PromiseKit for networking and Core Data for our persistence.

## System Overview

<img src="Images/diagram_architecture.png" width="600"> 

The app is designed to be cleanly separated into two parts: Core and Features.

Core defines components of the app which others can rely on. Its consists of the main data model and lower level services like networking and persistence. These are both presented behind protocols to decouple consuming code from concrete implementations. Through abstract factories we provide data layer objects without having client code specify explicit classes.

Features are components designed together to fulfil a user facing requirement. We aim for clean vertical slicing between them with the goal that a change to one feature should _NEVER_ effect another. The components that make up a feature can only depend on each other and core. They have no knowledge of any class or struct created within another feature. 

The benefits of this approach:

- Strong modularity between features, everything can be put behind a feature flag allowing you to turn on and off features as required - great for testing and feature roll out. 
- A Explicit understanding of a changes scope. Features can generally be freely refactored, where as changes to core require caution. 

Features can interact with each other, but its through core protocols i.e.. view controllers from Feature A will interact with services in feature B via a delegate protocol exposed in core. 

### Feature Architecture 
<img src="Images/diagram_viewLayer.png" width="400"> 

Individual features are best described as following a passive MVP architecture. 

The View Controller is responsible for setting up the views and updating based on model notifications.
It delegates user actions to the presenter object via its delegate protocol. The presenter will implement the 
business logic required and is the place where we can start to depend on other application services. This keeps
the ViewControllers clean and as reusable as possible.

NOTE: There isn't always a seperate protocol between the view controller and its presenter as subviews are kept
private so that in test it's possible to easily provide mock subclasses that don't rely on loading any UIKit views.








## Building
HueInspired depends on PromiseKit and Swinject which can be handled by Carthage

### Steps:

1. Install Carthage ( see https://github.com/Carthage/Carthage )
2. Clone repository
3. Run Carthage Bootstrap in repo root

And thats it, open in xcode and run.


