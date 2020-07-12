# KGMail
Test submission by Simon Bromberg on July 12 2020

Design Implementation:

* Some minor fussing with constraints / stack view settings needed to get displaying properly, in the interest of time moved on to other tasks

Tests:

* Could definitely add more / cleanup but focused on demonstrating basic test functionality in the interest of time 

Other:

* Fixed small bug with constraint warning on `LabelsViewController`
* Noticed bug with nav bar on `LabelsViewController` when initially presented, although didn't get a chance to fix it
* Would probably want to make it harder to accidentally dismiss the main view, which can just be dragged down right now because of the iOS 13 modal style changes, probably would want instead to cover full context instead and have log out functionality; or could keep the modal as is and ask user if they want to log out when they drag the view down
* App could use some loading indicators for initial load + after filters applied
