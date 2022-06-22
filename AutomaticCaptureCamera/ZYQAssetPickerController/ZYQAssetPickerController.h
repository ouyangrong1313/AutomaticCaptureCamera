//
//  ZYQAssetPickerController.h
//  ZYQAssetPickerControllerDemo
//
//  Created by Zhao Yiqi on 13-12-25.
//  Copyright (c) 2013年 heroims. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SSCustomNarBarButton.h"
#import "UIBarButtonItem+SSBarButtonItem.h"
#pragma mark - ZYQAssetPickerController


#pragma mark - /*** 相册浏览调用 ***/
@interface ZYQAssetVCHelp : NSObject
/**
 *  调用选择多张图片的方法  sourceType  1  调用相机  2 调用系统的相册  3 调用多张图片
 *
 *  @param maxNumber       最大选择的张数
 *  @param viewController 当前的控制期
 *  @param sourceType     类型  1  调用相机  2 调用系统的相册  3 调用多张图片
 */
+ (void)showImagePickerController:(NSInteger)maxNumber viewController:(UIViewController *)viewController sourceType:(NSInteger)sourceType delegate:(id)delegate;

@end


@protocol ZYQAssetPickerControllerDelegate;

@interface ZYQAssetPickerController : UINavigationController

@property (nonatomic, weak) id <UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate> myDelegate;

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

@property (nonatomic, copy, readonly) NSArray *indexPathsForSelectedItems;

@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;

@property (nonatomic, strong) NSPredicate *selectionFilter;

@property (nonatomic, assign) BOOL showCancelButton;

@property (nonatomic, assign) BOOL showEmptyGroups;

@property (nonatomic, assign) BOOL isFinishDismissViewController;



@end

@protocol ZYQAssetPickerControllerDelegate <NSObject>

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets;

@optional

-(void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker;

-(void)assetPickerController:(ZYQAssetPickerController *)picker didSelectAsset:(ALAsset*)asset;

-(void)assetPickerController:(ZYQAssetPickerController *)picker didDeselectAsset:(ALAsset*)asset;

-(void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker;

-(void)assetPickerControllerDidMinimum:(ZYQAssetPickerController *)picker;

@end

#pragma mark - ZYQAssetViewController

@interface ZYQAssetViewController : UITableViewController

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *indexPathsForSelectedItems;
#pragma mark - 新增的参数 maxNumberSelect
@property (nonatomic, assign) NSInteger maxNumberSelect ;
@property (nonatomic,assign) NSInteger number;     //新加的，选中的张数

@end

#pragma mark - ZYQVideoTitleView

@interface ZYQVideoTitleView : UILabel

@end

#pragma mark - ZYQTapAssetView

@protocol ZYQTapAssetViewDelegate <NSObject>

-(void)touchSelect:(BOOL)select;
-(BOOL)shouldTap;

@end

@interface ZYQTapAssetView : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, weak) id<ZYQTapAssetViewDelegate> delegate;
#pragma mark - 新增的参数 maxNumberSelect
@property (nonatomic, assign) NSInteger maxNumberSelect ;
@end

#pragma mark - ZYQAssetView

@protocol ZYQAssetViewDelegate <NSObject>

-(BOOL)shouldSelectAsset:(ALAsset*)asset;
-(void)tapSelectHandle:(BOOL)select asset:(ALAsset*)asset;

@end

@interface ZYQAssetView : UIView
#pragma mark - 新增的参数 maxNumberSelect
@property (nonatomic, assign) NSInteger maxNumberSelect ;
- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced;

@end

#pragma mark - ZYQAssetViewCell

@protocol ZYQAssetViewCellDelegate;

@interface ZYQAssetViewCell : UITableViewCell

@property(nonatomic,weak)id<ZYQAssetViewCellDelegate> delegate;
#pragma mark - 新增的参数 maxNumberSelect
@property (nonatomic, assign) NSInteger maxNumberSelect ;
- (void)bind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing columns:(int)columns assetViewX:(float)assetViewX;

@end

@protocol ZYQAssetViewCellDelegate <NSObject>

- (BOOL)shouldSelectAsset:(ALAsset*)asset;
- (void)didSelectAsset:(ALAsset*)asset;
- (void)didDeselectAsset:(ALAsset*)asset;

@end

#pragma mark - ZYQAssetGroupViewCell

@interface ZYQAssetGroupViewCell : UITableViewCell
#pragma mark - 新增的参数 maxNumberSelect
@property (nonatomic, assign) NSInteger maxNumberSelect ;
- (void)bind:(ALAssetsGroup *)assetsGroup;

@end

#pragma mark - ZYQAssetGroupViewController

@interface ZYQAssetGroupViewController : UITableViewController
#pragma mark - 新增的参数 maxNumberSelect
@property (nonatomic, assign) NSInteger maxNumberSelect ;
@end

