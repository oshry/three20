//
//  TTSegmentedToolbar.h
//  Three20
//
//  Created by Rodrigo Mazzilli on 10/8/09.
//

#import "Three20/TTView.h"

/**
 * A segmented toolbar has a UISegmentedControl inside and manages
 * its width accordingly.
 */

@interface TTSegmentedToolbar : UIToolbar {
	UISegmentedControl *_segmentedControl;
}
@property (nonatomic, readonly) UISegmentedControl *segmentedControl;

- (void)setSegmentedItems:(NSArray *)itemNames;

@end
