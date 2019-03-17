//
//  ViewController.h
//  MacApp
//
//  Created by Alberto on 2/19/19.
//  Copyright © 2019 Alberto Franco. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCDAsyncSocket.h"

@class GCDAsyncSocket;

@interface ViewController : NSViewController <GCDAsyncSocketDelegate, NSTableViewDataSource, NSTabViewDelegate>

@property GCDAsyncSocket *asyncSocket;
@property NSMutableArray *tableData;

@property (weak) IBOutlet NSTextField *inputTextField;
@property (weak) IBOutlet NSButton *listFilesButton;
@property (weak) IBOutlet NSTextFieldCell *connectionStatus;
@property (weak) IBOutlet NSTableView *fileNameTable;


@end

