# TRMultipanelViewController

iOS panel view controller with left and right side panels. When any side panel slide inside visible area central content area is resized. 
You can customize left, right and center views.

## Demo
![multipanel demo](https://raw.github.com/incaffeine/TRMultipanelViewController/master/multipanel-demo.gif)

## Usage 
There are two modes of multipanel. First mode tightly connects central view to side views by constraints. When side view change position then central view changes his frame according to constraints. This is default mode. 

In the second mode central view is not directly connected to sides. It has left/right constraints to superview. When any side slide on/off screen parent multipanel change appropriate constraint value on the center view. You can turn this mode by setting  *connectCenterViewToSides* to *YES*

Typcal initialization

    [self.multipanel setConnectCenterViewToSides:YES];
    [self.multipanel setWidth:240 forSide:TRMultipanelSideTypeLeft];
    [self.multipanel setWidth:240 forSide:TRMultipanelSideTypeRight];
    
    [self.multipanel setCenterController:centerController];

    [self.multipanel setContentController:leftController
                             forSide:TRMultipanelSideTypeLeft];
    
    [self.multipanel setContentController:rightController
                             forSide:TRMultipanelSideTypeRight];

You can hide/show/toggle sides manually. For example: 

	[self.multipanel toggleSide:TRMultipanelSideTypeRight animated:YES];

You can subscribe on show/hide notifications:

    TRMultipanelWillShowSideNotification
    TRMultipanelDidShowSideNotification
    TRMultipanelWillHideSideNotification
    TRMultipanelDidHideSideNotification

##License

This project is distributed under the terms and conditions of the [MIT license](LICENSE). 


