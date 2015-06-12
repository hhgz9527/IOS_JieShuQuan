//
//  MyBooksCollectionViewController.m
//  TWJieShuQuan
//
//  Created by Jianning Zheng on 6/3/15.
//  Copyright (c) 2015 Jianing. All rights reserved.
//

#import "MyBooksCollectionViewController.h"
#import "BookService.h"
#import "MyBooksCollectionViewCell.h"   
#import "BookEntity.h"
#import "BookDetailViewController.h"

@interface MyBooksCollectionViewController ()
@property (nonatomic, strong) NSArray *myBooks;
@end

@implementation MyBooksCollectionViewController

static NSString * const reuseIdentifier = @"MyBooksCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure layout
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat cellWidth = screenWidth/3;
    [self.flowLayout setItemSize:CGSizeMake(cellWidth, 145)];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.flowLayout.minimumLineSpacing = 10.f;
    self.flowLayout.minimumInteritemSpacing = 0.0f;
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    
    self.collectionView.bounces = YES;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:YES];
    
    
    [BookService fetchBookEntitiesForCurrentUserWithSucceedCallback:^(NSArray *myBooksObject) {
        self.myBooks = myBooksObject;
        
        [self.collectionView reloadData];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myBooks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BookEntity *currentBook = self.myBooks[indexPath.row];
    
    MyBooksCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell refreshCellWithBookEntity:currentBook];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:bookDetailSegue sender:[collectionView cellForItemAtIndexPath:indexPath]];
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:bookDetailSegue]) {
        BookDetailViewController *destViewController = (BookDetailViewController *)segue.destinationViewController;
        NSInteger row = [self.collectionView indexPathForCell:sender].row;
        destViewController.bookEntity = self.myBooks[row];
    }
}


@end
