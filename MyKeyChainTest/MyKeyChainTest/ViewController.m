//
//  ViewController.m
//  MyKeyChainTest
//
//  Created by dbromac on 08/07/2019.
//  Copyright © 2019 dbromac. All rights reserved.
//

#import "ViewController.h"
#import <Security/Security.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)getPasswordPressed:(id)sender {
    
    //Let's create an empty mutable dictionary
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    NSString *username = self.usernameTxtFld.text;
    NSString *website = @"http://cards.danbrohub.live";
    NSLog(@"Username: %@", username);
    
    //Populate it with the data and the attributes we want to use
    
    //we specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    // This item can only be accessed when the user unlocks the device
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    keychainItem[(__bridge id)kSecAttrServer] = website;
    keychainItem[(__bridge id)kSecAttrAccount] = username;
    
    //Check if this keychain item already exists
    
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    CFDictionaryRef result = nil;
    
    OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    
    NSLog(@"Error Code: %d", (int)sts);
    
    if (sts == noErr)
    {
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        NSData *pswd = resultDict[(__bridge id)kSecValueData];
        NSString *password = [[NSString alloc] initWithData:pswd encoding:NSUTF8StringEncoding];
        
        self.passwordLbl.text = password;
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                    @"The Item Doesn't Exist"
                                    message:@"No keychain item found for this user"
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        // Show alert
        [self presentViewController:alert animated:YES completion:^{}];
    }
    
    
    
}

- (IBAction)deleteItemPressed:(id)sender {
    //Let's create an empty mutable dictionary
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    NSString *username = self.usernameTxtFld.text;
    NSString *website = @"http://cards.danbrohub.live";
    
    //Populate it with the data and the attributes we want to use
    
    //we specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    // This item can only be accessed when the user unlocks the device
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    keychainItem[(__bridge id)kSecAttrServer] = website;
    keychainItem[(__bridge id)kSecAttrAccount] = username;
    
    //Check if this keychain item already exists
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr){
        
        OSStatus sts = SecItemDelete((__bridge CFDictionaryRef) keychainItem);
        NSLog(@"Error Code: %d", (int)sts);
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                    @"The item Doesn't Exist."
                                    message:@"The item doesn't exist. It may have already been deleted."
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        // Show alert
        [self presentViewController:alert animated:YES completion:^{}];
    }
    
    
}

- (IBAction)saveButtonPressed:(id)sender {
    
    //Let's create an empty mutable dictionary
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    NSString *username = self.nwUsernameTxtFld.text;
    NSString *password = self.passwordTxtFld.text;
    NSString *website = @"http://cards.danbrohub.live";
    
    //Populate it with the data and the attributes we want to use
    
    //we specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    // This item can only be accessed when the user unlocks the device
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    keychainItem[(__bridge id)kSecAttrServer] = website;
    keychainItem[(__bridge id)kSecAttrAccount] = username;
    
    //Check if this keychain item already exists
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                    @"The Item Already Exists"
                                    message:@"Please update it instead"
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        // Show alert
        [self presentViewController:alert animated:YES completion:^{}];
    }else{
        keychainItem[(__bridge id)kSecValueData] = [password dataUsingEncoding: NSUTF8StringEncoding];
        
        OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
        NSLog(@"Error Code %d", (int)sts);
    }
    
}

- (IBAction)updateButtonPressed:(id)sender {
    
    //Let's create an empty mutable dictionary:
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    NSString *username = self.nwUsernameTxtFld.text;
    NSString *password = self.passwordTxtFld.text;
    NSString *website = @"http://cards.danbrohub.live";
    
    //Populate it with the data and the attributes we want to use.
    
    //We specify what kind of kechain item this is
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    //This item can only be accessed when the user unlocks the device.
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    keychainItem[(__bridge id)kSecAttrServer] = website;
    keychainItem[(__bridge id)kSecAttrAccount] = username;
    
    //Check if the keychain item alreay exists
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr) {
        
        //The item was found.
        //We can update the keychain item
        
        NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
        attributesToUpdate[(__bridge id)kSecValueData] = [password dataUsingEncoding:NSUTF8StringEncoding];
        
        OSStatus sts = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)attributesToUpdate);
        NSLog(@"Error Code: %d", (int)sts);
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                    @"Item Doesn't Exist."
                                    message:@"The item you want to update doesn't exist."
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        // Show alert
        [self presentViewController:alert animated:YES completion:^{}];
    }
}

@end
