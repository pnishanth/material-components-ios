/*
 Copyright 2017-present the Material Components for iOS authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <XCTest/XCTest.h>

#import "../../src/private/MDCBottomNavigationItemView.h"

#import "MaterialInk.h"

static UIImage *fakeImage(void) {
  CGSize imageSize = CGSizeMake(24, 24);
  UIGraphicsBeginImageContext(imageSize);
  [UIColor.whiteColor setFill];
  UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

@interface MDCBottomNavigationItemView (Testing)
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *label;
@end

@interface BottomNavigationItemViewTests : XCTestCase

@end

@implementation BottomNavigationItemViewTests

- (void)testVerticalMarginLayout {
  // Given
  MDCBottomNavigationItemView *view = [[MDCBottomNavigationItemView alloc] init];
  view.title = @"Test Content";
  view.image = fakeImage();
  view.bounds = CGRectMake(0, 0, 100, 100);
  view.contentVerticalMargin = 20;
  view.contentHorizontalMargin = 20;
  view.titleVisibility = MDCBottomNavigationBarTitleVisibilityAlways;

  // When
  view.titleBelowIcon = YES;
  [view layoutSubviews];

  // Then
  CGFloat contentHeight =
      CGRectGetHeight(view.label.bounds) + CGRectGetHeight(view.iconImageView.bounds);
  CGFloat expectedDistance = contentHeight / 2 + view.contentVerticalMargin;
  XCTAssertEqualWithAccuracy(view.label.center.y - view.iconImageView.center.y,
                             expectedDistance,
                             0.001f);
}

- (void)testHorizontalMarginLayout {
  // Given
  MDCBottomNavigationItemView *view = [[MDCBottomNavigationItemView alloc] init];
  view.title = @"Test Content";
  view.image = fakeImage();
  view.bounds = CGRectMake(0, 0, 100, 100);
  view.contentVerticalMargin = 20;
  view.contentHorizontalMargin = 20;
  view.titleVisibility = MDCBottomNavigationBarTitleVisibilityAlways;

  // When
  view.titleBelowIcon = NO;
  [view layoutSubviews];

  // Then
  CGFloat contentWidth =
      CGRectGetWidth(view.label.bounds) + CGRectGetWidth(view.iconImageView.bounds);
  CGFloat expectedDistance = contentWidth / 2 + view.contentHorizontalMargin;
  XCTAssertEqualWithAccuracy(view.label.center.x - view.iconImageView.center.x,
                             expectedDistance,
                             0.001f);
}

- (void)testContentInsetLayout {
  // Given
  MDCBottomNavigationItemView *view = [[MDCBottomNavigationItemView alloc] init];
  view.title = @"Test Content";
  view.image = fakeImage();
  view.bounds = CGRectMake(0, 0, 100, 100);
  view.contentVerticalMargin = 20;
  view.contentHorizontalMargin = 20;
  view.titleVisibility = MDCBottomNavigationBarTitleVisibilityAlways;

  // When
  view.titleBelowIcon = YES;
  view.contentInsets = UIEdgeInsetsMake(10, 10, 5, 5);
  [view layoutSubviews];

  // Then
  CGRect contentRect = UIEdgeInsetsInsetRect(view.bounds, view.contentInsets);
  XCTAssert(view.label.center.x == CGRectGetMidX(contentRect));
  XCTAssert(view.iconImageView.center.x == CGRectGetMidX(contentRect));
  CGFloat contentSpan = CGRectGetMaxY(view.label.frame) - CGRectGetMinY(view.iconImageView.frame);
  XCTAssertEqualWithAccuracy(CGRectGetMinY(view.iconImageView.frame) + contentSpan / 2,
                             CGRectGetMidY(contentRect),
                             0.001f);
}

- (void)testSetSelectedItemTintColorUpdatesInkColor {
  // Given
  MDCBottomNavigationItemView *item1 = [[MDCBottomNavigationItemView alloc] init];
  MDCBottomNavigationItemView *item2 = [[MDCBottomNavigationItemView alloc] init];
  item1.selected = YES;
  UIColor *item1DefaultInkColor = item1.inkView.inkColor;
  UIColor *item2DefaultInkColor = item2.inkView.inkColor;

  // When
  item1.selectedItemTintColor = UIColor.cyanColor;
  item2.selectedItemTintColor = UIColor.cyanColor;

  // Then
  XCTAssertNotEqualObjects(item1.inkView.inkColor, item1DefaultInkColor);
  XCTAssertNotEqualObjects(item2.inkView.inkColor, item2DefaultInkColor);
}

@end
