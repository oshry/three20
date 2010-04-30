//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "Three20/TTTableViewCell.h"

// UI
#import "Three20/TTGlobalUI.h"

const CGFloat   kTableCellSmallMargin = 6;
const CGFloat   kTableCellSpacing     = 8;
const CGFloat   kTableCellMargin      = 10;
const CGFloat   kTableCellHPadding    = 10;
const CGFloat   kTableCellVPadding    = 10;

const NSInteger kTableMessageTextLineCount = 2;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  return TT_ROW_HEIGHT;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
  self.object = nil;
  [super prepareForReuse];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)object {
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
}


@end
