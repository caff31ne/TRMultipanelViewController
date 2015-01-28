# TRMultipanelViewController

iOS panel view controller with left and right side panels. Central part is tied to side panels by constraints. When any side panel slide inside visible area central content area is resized. 
You can customize left, right and center views.

## Demo
![multipanel demo](https://raw.github.com/incaffeine/TRMultipanelViewController/master/multipanel-demo.gif)

# Usage 
There are two modes of multipanel. First is when central view is connected to side view by constraints. In this case when side view change position central view cange his size accordingly. This is default mode. 
In the second mode central view doesn't connected directly to sides. It has left/right constraints to superview. When any side slide on/off screen parent multipanel change appropriate constraint on the center view. You can't turn this mode by setting  *connectCenterViewToSides* to *YES*

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



