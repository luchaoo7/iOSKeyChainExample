//
//  ViewController.h
//  MyKeyChainTest
//
//  Created by dbromac on 08/07/2019.
//  Copyright © 2019 dbromac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nwUsernameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtFld;

@property (weak, nonatomic) IBOutlet UILabel *passwordLbl;


- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)updateButtonPressed:(id)sender;
- (IBAction)getPasswordPressed:(id)sender;
- (IBAction)deleteItemPressed:(id)sender;
- (void)closePopUp;
- (void)popUpTimer;
@end

