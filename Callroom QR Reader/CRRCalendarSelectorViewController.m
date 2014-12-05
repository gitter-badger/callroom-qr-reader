//
//  CRRCalendarSelectorViewController.m
//  Callroom QR Reader
//
//  Created by Patryk Kaczmarek on 05.12.2014.
//  Copyright (c) 2014 Netguru. All rights reserved.
//

#import "CRRCalendarSelectorViewController.h"
#import "QRCodeReaderViewController.h"
#import "CRRCalendarSelectorView.h"

#import "CRRCalendar.h"

@interface CRRCalendarSelectorViewController () <UITableViewDelegate, UITableViewDataSource, QRCodeReaderDelegate>

@property (nonatomic, weak) CRRCalendarSelectorView *aView;
@property (nonatomic, strong) NSArray *model;

@end

@implementation CRRCalendarSelectorViewController

- (instancetype)initWithModel:(NSArray *)model {
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (void)loadView {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CRRCalendarSelectorView *view = [[CRRCalendarSelectorView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    _aView = view;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_aView.QRButton addTarget:self action:@selector(QRButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    _aView.tableView.delegate = self;
    _aView.tableView.dataSource = self;
    
    self.title = @"Choose source";
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Available calendars";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CRRCalendar *calendar = self.model[indexPath.row];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *calendarSelectorCellIdentifier = @"calendarSelectorCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:calendarSelectorCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:calendarSelectorCellIdentifier];
    }
    
    CRRCalendar *calendar = self.model[indexPath.row];
    
    return cell;
}

#pragma mark UIControl Methods

- (void)QRButtonDidClick:(UIButton *)button {
    
    QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    reader.delegate = self;
    [self presentViewController:reader animated:YES completion:NULL];
}

#pragma mark QRCodeReaderDelegate

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", result);
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end