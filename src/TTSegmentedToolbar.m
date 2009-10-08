//
//  TTSegmentedToolbar.m
//  Three20
//
//  Created by Rodrigo Mazzilli on 10/8/09.
//

#import "TTSegmentedToolbar.h"
#import "Three20/TTDefaultStyleSheet.h"

#define	kMargin		8.0f

@implementation TTSegmentedToolbar

- (void)dealloc {
	TT_RELEASE_SAFELY(_segmentedControl);
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
		self.tintColor = TTSTYLEVAR(toolbarTintColor);
	}
	return self;
}

// TODO: We need to do a better job here to manage and support changes in
// orientation, addition and removal of new items.

- (void)setSegmentedItems:(NSArray *)itemNames {
	if (itemNames && [itemNames count] > 0) {
		if (_segmentedControl) {
			TT_RELEASE_SAFELY(_segmentedControl);
		}
		_segmentedControl = [[UISegmentedControl alloc] initWithItems:itemNames];
		_segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		_segmentedControl.tintColor = TTSTYLEVAR(segmentedControlTintColor);
		_segmentedControl.selectedSegmentIndex = 0;
		
		CGFloat newWidthWithMargins = (self.bounds.size.width - 2*kMargin);
		CGFloat segmentWidth = (newWidthWithMargins / _segmentedControl.numberOfSegments);
		for (int seg = 0; seg < _segmentedControl.numberOfSegments; seg++) {
			[_segmentedControl setWidth:segmentWidth forSegmentAtIndex:seg];
		}
		
		UIBarButtonItem *spaceLeftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *spaceRightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *segmentedControlItem = [[UIBarButtonItem alloc] initWithCustomView:_segmentedControl];
		NSMutableArray *barButtons = [[NSMutableArray alloc] initWithObjects:spaceLeftItem, segmentedControlItem, spaceRightItem, nil];
		self.items = barButtons;
		[spaceLeftItem release];
		[spaceRightItem release];
		[segmentedControlItem release];
		[barButtons release];
	}
}

@end
