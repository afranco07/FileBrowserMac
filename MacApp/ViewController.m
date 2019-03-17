//
//  ViewController.m
//  MacApp
//
//  Created by Alberto on 2/19/19.
//  Copyright © 2019 Alberto Franco. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    _listFilesButton.enabled = false;
    [self connectToGoApp];
    [_fileNameTable setDataSource:self];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [_tableData count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    return [_tableData objectAtIndex:rowIndex];
}

- (IBAction)sendDirectoryToGoApp:(id)sender {
    _tableData = [[NSMutableArray alloc] init];
    NSString *inputString = _inputTextField.stringValue;
    NSData *inputStringBytes = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    [_asyncSocket writeData:inputStringBytes withTimeout:-1 tag:0];
    NSData *term = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
    [_asyncSocket readDataToData:term withTimeout:-1 tag:0];
}

- (void)connectToGoApp {
    _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_asyncSocket setDelegate:self];
    NSError *err = nil;
    
    if (![_asyncSocket connectToHost:@"localhost" onPort:8080 error:&err]) {
        NSLog(@"Error while creating socket: %@", err);
    }
}

- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"Connected to Go App");
    _listFilesButton.enabled = true;
    _connectionStatus.stringValue = @"Connected!";
    _connectionStatus.textColor = [NSColor greenColor];
}

- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag {
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [_tableData addObject:stringData];
    NSData *term = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
    [_asyncSocket readDataToData:term withTimeout:-1 tag:0];
    [_fileNameTable reloadData];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error {
    _connectionStatus.stringValue = @"No Connection (Check Go App)";
    _connectionStatus.textColor = [NSColor systemRedColor];
    _listFilesButton.enabled = false;
    NSLog(@"Disconnected from server");
    [_fileNameTable reloadData];
    [self connectToGoApp];
}


@end
