//
//  CollectionViewController.m
//  Created by Vitali Bondur on 1/18/15.
//

#import "CollectionViewController.h"

#import "CollectionViewCell.h"

#import <TRMultipanelViewController/TRMultipanelViewController.h>
#import <AssetsLibrary/AssetsLibrary.h>

static CGFloat ContainerPadding = 10;
static CGFloat ImagesPerLine = 2;
static CGFloat CellMargin = 10;

@interface CollectionViewController ()

@property (strong, nonatomic) ALAssetsLibrary* library;
@property (strong, nonatomic) NSMutableArray* assets;

@end

@implementation CollectionViewController

- (NSMutableArray*)assets {
    if (!_assets) {
        _assets = [NSMutableArray new];
    }
    return _assets;
}

- (ALAssetsLibrary*)library {
    if (!_library) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self collectImages];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onToggleMultipanelSide:)
                                                 name:TRMultipanelDidShowSideNotification
                                               object:nil];
    
    if (self.updateAfterResize)
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onToggleMultipanelSide:)
                                                     name:TRMultipanelWillHideSideNotification
                                                   object:nil];
    else
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onToggleMultipanelSide:)
                                                     name:TRMultipanelDidHideSideNotification
                                                   object:nil];


    [self updateLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.collectionView.contentInset = UIEdgeInsetsZero;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class]) forIndexPath:indexPath];
    
    ALAsset* asset = [self.assets objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
    
    return cell;
}

- (void)collectImages {

    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:
     ^(ALAssetsGroup *group, BOOL *stop) {
         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
         [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *innerStop) {
             if (asset) {
                 [self.assets addObject:asset];
             } else {
                 [self.collectionView reloadData];
             }
         }];
     } failureBlock: ^(NSError *error) {
         NSLog(@"Enumerate groups failed: %@",error);
     }];
}

- (void)onToggleMultipanelSide:(NSNotification*)notification {
    [self updateLayout];
}

- (void)updateLayout {
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    NSLog(@"Layut update: width = %f", self.view.frame.size.width);
    
    CGFloat width = (self.view.frame.size.width - 2 * ContainerPadding - ((ImagesPerLine - 1) * CellMargin)) / ImagesPerLine;
    
    layout.itemSize = CGSizeMake(width, width);
    [self.collectionView setCollectionViewLayout:layout animated:NO];
}

@end
